-- Custom file icon overrides
return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        ["go"] = { icon = "󰟓", color = "#00ADD8", cterm_color = "38", name = "Go" },
      },
      override_by_filename = {
        ["go.mod"] = { icon = "󰟓", color = "#00ADD8", cterm_color = "38", name = "GoMod" },
        ["go.sum"] = { icon = "󰟓", color = "#00ADD8", cterm_color = "38", name = "GoSum" },
        ["go.work"] = { icon = "󰟓", color = "#00ADD8", cterm_color = "38", name = "GoWork" },
      },
    },
  },
}
