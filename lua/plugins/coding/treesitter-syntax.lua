-- treesitter-syntax - Syntax highlighting
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin to last version supporting Neovim 0.11 (remove when upgrading to 0.12+)
    commit = "90cd6580",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- Parsers to auto-install
      local ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "hcl",
        "helm",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "terraform",
        "toml",
        "yaml",
      }

      -- Install missing parsers on startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local installed = require("nvim-treesitter.config").get_installed()
          for _, lang in ipairs(ensure_installed) do
            if not vim.tbl_contains(installed, lang) then
              vim.cmd("TSInstall " .. lang)
            end
          end
        end,
      })

      -- Enable highlighting for all filetypes with treesitter support
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- Configure the plugin
      require("nvim-treesitter-textobjects.config").update({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")
      local keymap = vim.keymap.set

      -- Selection keymaps (visual and operator-pending modes)
      keymap({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer") end, { desc = "Select outer function" })
      keymap({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner") end, { desc = "Select inner function" })
      keymap({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer") end, { desc = "Select outer class" })
      keymap({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner") end, { desc = "Select inner class" })
      keymap({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer") end, { desc = "Select outer argument" })
      keymap({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner") end, { desc = "Select inner argument" })

      -- Movement keymaps
      keymap({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer") end, { desc = "Next function start" })
      keymap({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer") end, { desc = "Previous function start" })
      keymap({ "n", "x", "o" }, "]F", function() ts_move.goto_next_end("@function.outer") end, { desc = "Next function end" })
      keymap({ "n", "x", "o" }, "[F", function() ts_move.goto_previous_end("@function.outer") end, { desc = "Previous function end" })

      keymap({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer") end, { desc = "Next class start" })
      keymap({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer") end, { desc = "Previous class start" })
      keymap({ "n", "x", "o" }, "]C", function() ts_move.goto_next_end("@class.outer") end, { desc = "Next class end" })
      keymap({ "n", "x", "o" }, "[C", function() ts_move.goto_previous_end("@class.outer") end, { desc = "Previous class end" })

      keymap({ "n", "x", "o" }, "]a", function() ts_move.goto_next_start("@parameter.inner") end, { desc = "Next argument" })
      keymap({ "n", "x", "o" }, "[a", function() ts_move.goto_previous_start("@parameter.inner") end, { desc = "Previous argument" })
    end,
  },
}
