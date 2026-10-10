return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      -- Register blink.compat as a dependency for blink.cmp
      { "saghen/blink.compat", version = "*", opts = {} },
    },
    opts = {
      sources = {
        -- Optionally add "neorg" to your default blink sources if you want it active globally
        compat = {
          -- Tells blink.compat to handle the 'neorg' source namespace
          "neorg",
        },
        providers = {
          neorg = {
            name = "neorg",
            module = "blink.compat.source",
            score_offset = -3, -- Adjust priority if needed
          },
        },
      },
    },
  },
}
