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
          local format_12hr = vim.g.time_format_12hr
          local format_name = format_12hr and "12-hour" or "24-hour"
          -- Update noice date format if available
          local ok, noice_config = pcall(require, "noice.config")
          if ok and noice_config.options and noice_config.options.format then
            noice_config.options.format.date = noice_config.options.format.date or {}
            noice_config.options.format.date.format = format_12hr and "%I:%M:%S %p" or "%H:%M:%S"
          end
          -- Update Snacks notifier date format
          -- Access the internal notifier instance through the module's upvalue
          local snacks_ok = pcall(function()
            local new_format = format_12hr and "%I:%M %p" or "%R"
            -- Update config for future notifications
            Snacks.config.notifier = Snacks.config.notifier or {}
            Snacks.config.notifier.date_format = new_format
            -- Update the running notifier instance opts directly
            local notifier_module = require("snacks.notifier")
            -- The show_history passes self (notifier instance) to render
            -- We need to patch the opts on the actual instance
            -- Try to get the instance by triggering a method that returns it
            for _, notif in ipairs(Snacks.notifier.get_history()) do
              -- This forces the module to load and we can check its state
              break
            end
            -- Patch via debug library to access the local 'notifier' variable
            local info = debug.getinfo(notifier_module.notify, "u")
            if info and info.nups > 0 then
              for i = 1, info.nups do
                local name, val = debug.getupvalue(notifier_module.notify, i)
                if name == "notifier" and val and val.opts then
                  val.opts.date_format = new_format
                  break
                end
              end
            end
          end)
          vim.notify("Time format: " .. format_name, vim.log.levels.INFO)
        end,
        desc = "Toggle time format (12/24hr)",
      },
    },
  },
}
