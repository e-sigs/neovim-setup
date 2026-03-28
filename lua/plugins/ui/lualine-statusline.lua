-- lualine-statusline - Statusline
-- Global variable for time format toggle (true = 12hr, false = 24hr)
vim.g.time_format_12hr = true

local function get_time()
  if vim.g.time_format_12hr then
    return os.date("%I:%M %p") -- 12-hour format: 02:30 PM
  else
    return os.date("%H:%M") -- 24-hour format: 14:30
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
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
        lualine_z = { "location", get_time },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
    keys = {
      {
        "<leader>tc",
        function()
          vim.g.time_format_12hr = not vim.g.time_format_12hr
          local format = vim.g.time_format_12hr and "12-hour" or "24-hour"
          -- Update noice date format if available
          local ok, noice_config = pcall(require, "noice.config")
          if ok and noice_config.options and noice_config.options.format then
            noice_config.options.format.date = noice_config.options.format.date or {}
            noice_config.options.format.date.format = vim.g.time_format_12hr and "%I:%M:%S %p" or "%H:%M:%S"
          end
          vim.notify("Time format: " .. format, vim.log.levels.INFO)
        end,
        desc = "Toggle time format (12/24hr)",
      },
    },
  },
}
