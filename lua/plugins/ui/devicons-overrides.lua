-- Custom file icon overrides
return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        ["go"] = { icon = "Go", color = "#00ADD8", cterm_color = "38", name = "Go" },
      },
      override_by_filename = {
        ["go.mod"] = { icon = "Go", color = "#00ADD8", cterm_color = "38", name = "GoMod" },
        ["go.sum"] = { icon = "Go", color = "#00ADD8", cterm_color = "38", name = "GoSum" },
        ["go.work"] = { icon = "Go", color = "#00ADD8", cterm_color = "38", name = "GoWork" },
      },
    },
  },
}
