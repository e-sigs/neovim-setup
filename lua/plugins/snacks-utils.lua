-- Snacks.nvim - All-in-one utilities by Folke
-- Replaces: indent-blankline, dressing, telescope, notify, and more
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

      -- Notifications (replaces nvim-notify)
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
      },

      -- Dashboard (startup screen)
      dashboard = {
        enabled = true,
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

      -- Terminal
      terminal = { enabled = true },

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
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

      -- Lazygit (perfect for GitOps workflows)
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file log" },

      -- Git browse (open in GitHub/GitLab)
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse" },

      -- Scratch buffers
      { "<leader>.", function() Snacks.scratch() end, desc = "Scratch buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },

      -- Notifications
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

      -- Terminal
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal" },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle terminal" },

      -- Words (highlight references)
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
    },
    init = function()
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
