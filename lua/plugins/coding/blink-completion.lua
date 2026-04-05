return {
  "saghen/blink.cmp",
  -- Use release tag to download pre-built binaries (no Cargo/Rust required)
  version = "1.*",
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
      -- Use Rust fuzzy matcher if available, fall back to Lua (shows warning if Rust unavailable)
      implementation = "prefer_rust_with_warning",
    },
  },
  keys = {
    { "<C-Space>", "a<C-Space>", desc = "Trigger completion", mode = "n", remap = true },
  },
}
