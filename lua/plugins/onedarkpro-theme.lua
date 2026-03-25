-- OneDarkPro colorscheme and statusline
return {
  -- OneDarkPro colorscheme
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
        keywords = "italic",
        functions = "NONE",
        variables = "NONE",
      },
      options = {
        cursorline = true,
        transparency = false,
        terminal_colors = true,
        highlight_inactive_windows = false,
      },
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      vim.cmd.colorscheme("onedark")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "quickfix" },
    },
  },
}
