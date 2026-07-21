return {
  -- 1. Use mojo.nvim strictly for Treesitter syntax & file detection
  {
    "Sarctiann/mojo.nvim",
    ft = { "mojo", "🔥" },
    build = ":TSUpdate mojo",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local mojo = require "mojo"

      -- We forcefully overwrite their setup routine so they CANNOT launch an LSP client
      mojo.setup = function() end
      mojo.setup_lsp = function() end

      -- Manually trigger just the syntax & filetype parts of the plugin
      if mojo.setup_treesitter then mojo.setup_treesitter() end
    end,
  },

  -- 2. Let AstroNvim cleanly handle the actual language server
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "mojo" },
      config = {
        mojo = {
          cmd = { "mojo-lsp-server" },
          filetypes = { "mojo", "🔥" },
          name = "mojo",
          -- Root directory detection so the LSP knows where your project starts
          root_dir = require("lspconfig.util").root_pattern("mojoproject.toml", "magic.toml", "pixi.toml", ".git"),
        },
      },
    },
  },
}
