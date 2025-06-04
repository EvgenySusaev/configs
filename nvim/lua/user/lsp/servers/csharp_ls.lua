return {
  cmd = { "csharp-ls" },
  filetypes = { "cs" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git")(fname)
  end,
}

