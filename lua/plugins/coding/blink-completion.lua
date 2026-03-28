return {
  "saghen/blink.cmp",
  version = "1.*",
  build = "cargo build --release",
  opts = {
    completion = {
      menu = {
        border = "rounded",
      },
      ghost_text = {
        enabled = false,
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
    },
    keymap = {
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    fuzzy = {
      implementation = "prefer_rust",
    },
  },
  keys = {
    { "<C-Space>", "a<C-Space>", desc = "Trigger completion", mode = "n", remap = true },
  },
}
