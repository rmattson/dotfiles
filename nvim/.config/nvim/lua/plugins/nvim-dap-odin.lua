return {
  {
    'NANDquark/nvim-dap-odin', -- Use the correct path to your local plugin
    name = "nvim-dap-odin",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- optionally override options by passing to setup({...})
      require("nvim-dap-odin").setup()
    end,
  },
}
