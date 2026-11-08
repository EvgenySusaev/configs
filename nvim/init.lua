-- ~/.config/nvim/init.lua (репозиторий configs). Нативный LSP neovim 0.11+ (не LazyVim:
-- lazy.nvim здесь только менеджер плагинов). Серверы ставит роль dev_toolchains, их
-- пути в PATH — ~/.config/bash/toolchains.sh; здесь только запуск. Не установлен
-- сервер — ошибка появится при открытии файла соответствующего типа.

local o = vim.opt
o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.scrolloff = 8
o.undofile = true
o.mouse = "a"

-- Машина работает и в графике, и в голой tty (TERM=linux): truecolor и системный
-- буфер обмена включаем только там, где они есть. Иначе в tty — кривые цвета и
-- предупреждения про отсутствие clipboard-провайдера.
if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
  o.termguicolors = true
end
if vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY then
  o.clipboard = "unnamedplus"
end
o.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }

vim.g.mapleader = " "

-- ── LSP ──────────────────────────────────────────

-- Группы шаблонов по приоритету: корень — ближайший каталог с файлом из первой
-- группы, для которой такой каталог нашёлся выше по дереву (так решение .sln
-- важнее ближайшего .csproj). Не нашлось ничего — сервер не запускается.
local function root_by_first_match(groups)
  return function(bufnr, on_dir)
    for _, patterns in ipairs(groups) do
      local root = vim.fs.root(bufnr, function(name)
        for _, p in ipairs(patterns) do
          if name:match(p) then return true end
        end
        return false
      end)
      if root then return on_dir(root) end
    end
  end
end

local function root_by_pattern(patterns)
  return root_by_first_match({ patterns })
end

local npm_global = vim.fn.expand("~/.npm-global/lib/node_modules")

local servers = {
  -- C / C++
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  },
  -- Rust
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  },
  -- C#: корень — решение (.sln/.slnx), иначе ближайший проект (.csproj). Без них
  -- (.csx, одиночный .cs) csharp-ls не запускается: он работает только с проектами.
  csharp_ls = {
    cmd = { "csharp-ls" },
    filetypes = { "cs" },
    root_dir = root_by_first_match({ { "%.sln$", "%.slnx$" }, { "%.csproj$" } }),
  },
  -- JS / TS
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  },
  -- Angular (шаблоны *.component.html neovim определяет как htmlangular)
  angularls = {
    cmd = function(dispatchers, config)
      local root = config.root_dir or vim.uv.cwd()
      local probes = table.concat({ root .. "/node_modules", npm_global }, ",")
      return vim.lsp.rpc.start(
        { "ngserver", "--stdio", "--tsProbeLocations", probes, "--ngProbeLocations", probes },
        dispatchers
      )
    end,
    filetypes = { "typescript", "html", "htmlangular" },
    root_dir = root_by_pattern({ "^angular%.json$", "^nx%.json$" }),
  },
  html = { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" }, root_markers = { "package.json", ".git" } },
  cssls = { cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" }, root_markers = { "package.json", ".git" } },
  jsonls = { cmd = { "vscode-json-language-server", "--stdio" }, filetypes = { "json", "jsonc" }, root_markers = { ".git" } },
  -- Clojure
  clojure_lsp = {
    cmd = { "clojure-lsp" },
    filetypes = { "clojure" },
    root_markers = { "project.clj", "deps.edn", "bb.edn", "shadow-cljs.edn", ".git" },
  },
  -- Python
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "pyrightconfig.json", ".git" },
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  },
  -- PHP
  intelephense = {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
  },
  -- Perl (libperl-languageserver-perl из apt)
  perlls = {
    cmd = { "perl", "-MPerl::LanguageServer", "-e", "Perl::LanguageServer::run", "--", "--port 13603", "--nostdio 0" },
    filetypes = { "perl" },
    root_markers = { "Makefile.PL", "cpanfile", ".git" },
  },
  -- Ruby
  solargraph = {
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    root_markers = { "Gemfile", ".git" },
  },
  -- Lua
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },
  -- shell / yaml / docker
  bashls = { cmd = { "bash-language-server", "start" }, filetypes = { "sh", "bash" }, root_markers = { ".git" } },
  yamlls = { cmd = { "yaml-language-server", "--stdio" }, filetypes = { "yaml" }, root_markers = { ".git" } },
  dockerls = { cmd = { "docker-langserver", "--stdio" }, filetypes = { "dockerfile" }, root_markers = { "Dockerfile", ".git" } },
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
end
vim.lsp.enable(vim.tbl_keys(servers))

vim.diagnostic.config({ virtual_text = true, severity_sort = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    -- Уже есть по умолчанию: K hover, grn rename, gra code action, grr references,
    -- gri implementation, [d ]d диагностика, <C-w>d диагностика под курсором.
    local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = ev.buf }) end
    map("gd", vim.lsp.buf.definition)
    map("gD", vim.lsp.buf.declaration)
  end,
})

-- ── Плагины (lazy.nvim) ──────────────────────────
-- lazy.nvim клонируется ниже (закреплённый тег), плагины ставит playbook командой
-- `nvim --headless "+Lazy! sync"`. Все версии закреплены здесь: tag / commit. Обновить =
-- поменять значение и прогнать playbook (изменение init.lua запускает повторную установку).
-- lazy-lock.json вынесен из ~/.config, чтобы не попадать в репозиторий configs.

local ts_langs = {
  "angular", "bash", "c", "c_sharp", "clojure", "cmake", "cpp", "css", "diff", "dockerfile",
  "git_config", "gitcommit", "html", "javascript", "json", "lua", "make", "markdown",
  "markdown_inline", "perl", "php", "php_only", "python", "query", "regex", "ruby", "rust",
  "scss", "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

local lazy_tag = "v11.17.5"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=" .. lazy_tag,
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
if vim.uv.fs_stat(lazypath) then
  vim.fn.mkdir(vim.fn.stdpath("state"), "p") -- для lazy-lock.json на чистой машине
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup({
    { "folke/lazy.nvim", tag = lazy_tag },
    {
      -- ветка master (заморожена): поддерживает nvim 0.10/0.11 и tree-sitter-cli 0.25.x,
      -- то есть ровно то, что в apt Ubuntu 26.04. main требует nvim 0.12 и CLI 0.26.1+.
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      commit = "cf12346a3414fa1b06af75c79faebe7f76df080a",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = ts_langs,
          sync_install = true, -- блокирует старт, только если чего-то не хватает
          highlight = { enable = true },
        })
      end,
    },
    {
      -- форматтеры — внешние программы (ставит playbook), conform вызывает их по типу
      -- файла; если для типа форматтера нет — откат на LSP (напр. clojure-lsp).
      "stevearc/conform.nvim",
      tag = "v9.1.0",
      lazy = false,
      opts = {
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          htmlangular = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
          python = { "ruff_organize_imports", "ruff_format" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          rust = { "rustfmt" },
          cs = { "csharpier" },
          php = { "php_cs_fixer" },
          perl = { "perltidy" },
          ruby = { "rubocop" },
          sh = { "shfmt" },
          bash = { "shfmt" },
        },
        default_format_opts = { lsp_format = "fallback" },
      },
      keys = {
        { "<leader>f", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "Format" },
      },
    },
  }, {
    lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
    install = { missing = true },
    checker = { enabled = false },
    change_detection = { enabled = false },
  })
end
