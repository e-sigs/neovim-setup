-- Snacks.nvim - All-in-one utilities by Folke
-- Note: notifier and progress are disabled (using noice.nvim instead)

-- Helper for terminal navigation
local function term_nav(dir)
  return function(self)
    return self:is_floating() and "<C-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Indentation guides (replaces indent-blankline)
      indent = {
        enabled = true,
        char = "│",
        scope = {
          enabled = true,
          char = "│",
        },
      },

      -- Better input/select UI (replaces dressing.nvim)
      input = { enabled = true },

      -- Notifications
      notifier = {
        enabled = true,
        date_format = vim.g.time_format_12hr and "%I:%M %p" or "%R",
      },

      -- Disabled: using noice.nvim for LSP progress
      progress = { enabled = false },

      -- Dashboard (startup screen)
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            "██╗  ██╗██╗    ███████╗██╗ ██████╗ ██╗",
            "██║  ██║██║    ██╔════╝██║██╔════╝ ██║",
            "███████║██║    ███████╗██║██║  ███╗██║",
            "██╔══██║██║    ╚════██║██║██║   ██║╚═╝",
            "██║  ██║██║    ███████║██║╚██████╔╝██╗",
            "╚═╝  ╚═╝╚═╝    ╚══════╝╚═╝ ╚═════╝ ╚═╝",
            "",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣧⣼⣧⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣭⣭⣤⣄⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣷⣤⣤⡄",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣼⣿⣮⣍⣉⣉⣀⣀⠀⠀⠀",
            "⠀⠀⣠⣶⣶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀",
            "⣴⣿⣿⣿⣿⣿⣯⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀",
            "⠉⣿⣿⣿⣿⣿⣿⣷⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀",
            "⠀⣿⣿⣿⣿⣿⣿⡟⠸⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀",
            "⠀⠘⢿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠉⠉⣿⣿⡏⠁⠀⠀⠀⠀⠀",
            "⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀",
          }, "\n"),
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },

      -- Picker (replaces telescope)
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
          explorer = {
            -- Custom floating preview: sidebar stays left, preview floats in center
            on_show = function(picker)
              local show = false -- Preview hidden by default, toggle with 'p'
              local gap = 2

              local position = picker.resolved_layout.layout.position
              local rel = picker.layout.root

              local update = function(win)
                local border = win:border_size().left + win:border_size().right
                local sidebar_width = vim.api.nvim_win_get_width(rel.win)
                local available_width = vim.o.columns - sidebar_width - border - gap

                -- Preview takes 70% of available space, centered in the remaining area
                local preview_width = math.floor(available_width * 0.7)
                preview_width = math.max(40, math.min(120, preview_width))

                -- Center horizontally in the space to the right of explorer
                local remaining_space = available_width - preview_width
                local horizontal_offset = math.floor(remaining_space / 2)

                -- Center vertically on screen
                local preview_height = math.floor(vim.o.lines * 0.7)
                local vertical_offset = math.floor((vim.o.lines - preview_height) / 2)

                win.opts.width = preview_width
                win.opts.height = preview_height

                if position == "left" then
                  win.opts.col = sidebar_width + gap + horizontal_offset
                end
                if position == "right" then
                  win.opts.col = horizontal_offset
                end
                win.opts.row = vertical_offset

                win:update()
              end

              -- Create floating preview window
              local preview_win = Snacks.win.new({
                relative = "editor",
                external = false,
                focusable = false,
                border = "rounded",
                backdrop = false,
                show = show,
                bo = {
                  filetype = "snacks_float_preview",
                  buftype = "nofile",
                  buflisted = false,
                  swapfile = false,
                  undofile = false,
                },
                on_win = function(win)
                  update(win)
                  picker:show_preview()
                end,
              })

              -- Close preview when leaving explorer
              rel:on("WinLeave", function()
                vim.schedule(function()
                  if not picker:is_focused() then
                    picker.preview.win:close()
                  end
                end)
              end)

              -- Update preview position on resize
              rel:on("WinResized", function()
                update(preview_win)
              end)

              -- Replace picker's preview window with floating one
              picker.preview.win = preview_win
              picker.main = preview_win.win
            end,

            on_close = function(picker)
              picker.preview.win:close()
            end,

            layout = {
              preset = "sidebar",
              preview = false, -- Disable built-in preview (using custom floating)
            },

            actions = {
              -- Override toggle_preview for floating window
              toggle_preview = function(picker)
                picker.preview.win:toggle()
              end,
            },

            win = {
              list = {
                keys = {
                  ["<CR>"] = "confirm",
                  ["p"] = "toggle_preview",
                },
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.8,
              height = 0.8,
              {
                box = "vertical",
                border = "rounded",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", border = "rounded", width = 0.5 },
            },
          },
        },
      },

      -- Better buffer delete
      bufdelete = { enabled = true },

      -- Lazygit integration (great for GitOps)
      lazygit = { enabled = true },

      -- Git utilities
      git = { enabled = true },
      gitbrowse = { enabled = true },

      -- Scratch buffers for quick notes
      scratch = { enabled = true },

      -- Quick scope for f/t motions
      quickfile = { enabled = true },

      -- Status column
      statuscolumn = { enabled = true },

      -- Word highlighting
      words = { enabled = true },

      -- Big file handling
      bigfile = { enabled = true },

      -- Terminal with window navigation
      terminal = {
        enabled = true,
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
            hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
            hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
          },
        },
      },

      -- Styles
      styles = {
        notification = {
          border = "rounded",
        },
      },
    },
    keys = {
      -- File explorer
      { "<leader>e", function() Snacks.picker.explorer() end, desc = "File explorer" },

      -- File pickers (replaces telescope)
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
      { "<leader>f/", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command history" },

      -- Git pickers
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff" },

      -- LSP pickers
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
      { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Go to definition" },
      { "gr", function() Snacks.picker.lsp_references() end, desc = "Go to references" },
      { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Go to implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Go to type definition" },

      -- Misc pickers
      { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>/", function() Snacks.picker.grep_buffers() end, desc = "Grep open buffers" },
      { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart picker" },

      -- Buffer management
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer (global)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

      -- Lazygit (perfect for GitOps workflows)
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file log" },

      -- Git browse (open in GitHub/GitLab)
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse" },

      -- Scratch buffers
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },

      -- Notifications handled by noice.nvim (see noice-ui.lua)

      -- Terminal (works in normal and terminal mode to toggle)
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle terminal" },

      -- Words (highlight references)
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
    },
    init = function()
      -- Noice handles vim.notify, no need for Snacks notifier queue
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Debug helpers
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          -- Toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
          Snacks.toggle.diagnostics():map("<leader>td")
          Snacks.toggle.line_number():map("<leader>tl")
          Snacks.toggle.treesitter():map("<leader>tT")
          Snacks.toggle.inlay_hints():map("<leader>th")
        end,
      })
    end,
  },
}
