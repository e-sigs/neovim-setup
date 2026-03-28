-- which-key.nvim - Keybinding hints
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 0,  -- Show immediately, don't add to key timeout
      plugins = {
        spelling = { enabled = true },
      },
      win = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register key groups and individual keys
      wk.add({
        -- Groups (normal mode)
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostic" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>o", group = "OpenCode" },
        { "<leader>n", group = "Notifications" },
        { "<leader>r", group = "Rename" },
        { "<leader>s", group = "Split" },
        { "<leader>t", group = "Toggle" },

        -- Groups (visual mode)
        { "<leader>c", group = "Code", mode = "v" },
        { "<leader>g", group = "Git", mode = "v" },
        { "<leader>h", group = "Hunk", mode = "v" },

        -- Standalone leader keys
        { "<leader>e", function() Snacks.picker.explorer() end, desc = "File explorer" },
        { "<leader>/", function() Snacks.picker.grep_buffers() end, desc = "Grep buffers" },
        { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart picker" },

        -- Close buffer (override default C-w)
        { "<C-w>", function() Snacks.bufdelete() end, desc = "Close buffer" },

        -- Find group
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>f/", function() Snacks.picker.lines() end, desc = "Buffer lines" },
        { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command history" },

        -- Git group
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file log" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse" },
        { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff" },

        -- Buffer group
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

        -- Toggle group
        { "<leader>tt", function() Snacks.terminal() end, desc = "Terminal" },

        -- Notifications (using Snacks notifier)
        { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
        { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },

        -- Code group (from LSP) - works in normal and visual mode
        { "<leader>ca", desc = "Code action", mode = { "n", "v" } },
        { "<leader>cf", desc = "Format buffer/selection", mode = { "n", "v" } },
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },

        -- Rename group
        { "<leader>rn", desc = "Rename symbol" },

        -- Diagnostic group (actual keymaps in keymaps.lua)
        { "<leader>de", desc = "Show diagnostic" },
        { "<leader>dl", desc = "Diagnostic list" },

        -- Split group (actual keymaps in keymaps.lua)
        { "<leader>sv", desc = "Split vertical" },
        { "<leader>sh", desc = "Split horizontal" },
        { "<leader>se", desc = "Equal split size" },
        { "<leader>sx", desc = "Close split" },

        -- Quick save/quit (actual keymaps in keymaps.lua)
        { "<leader>w", desc = "Save file" },
        { "<leader>q", group = "Quit" },
        { "<leader>qq", desc = "Quit" },
        { "<leader>qa", desc = "Quit all" },
        { "<leader>qw", desc = "Save and quit" },
        { "<leader>qQ", desc = "Quit without saving" },

        -- Visual mode specific
        { "<leader>hs", desc = "Stage hunk", mode = "v" },
        { "<leader>hr", desc = "Reset hunk", mode = "v" },
      })
    end,
  },
}
