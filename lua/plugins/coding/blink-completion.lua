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
    fuzzy = {
      implementation = "prefer_rust",
    },
  },
}
