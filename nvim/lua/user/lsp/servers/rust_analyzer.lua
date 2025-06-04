return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("Cargo.toml", ".git")(fname)
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy"
      }
    }
  }
}

