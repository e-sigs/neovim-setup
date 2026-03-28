return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last message" },
    {
      "<leader>nn",
      function()
        local View = require("noice.view")
        local Manager = require("noice.message.manager")
        local view = View.get_view("split", { enter = true, format = "details" })
        -- Filter out msg_showcmd events (keypresses)
        local filter = {
          ["not"] = { event = "msg_showcmd" },
        }
        view:set(Manager.get(filter, { history = true, sort = true, reverse = true }))
        view:display()
      end,
      desc = "Noice messages (newest first)",
    },
    {
      "<leader>nN",
      function()
        local View = require("noice.view")
        local Manager = require("noice.message.manager")
        local view = View.get_view("split", { enter = true, format = "details" })
        -- Filter out msg_showcmd events (keypresses)
        local filter = {
          ["not"] = { event = "msg_showcmd" },
        }
        view:set(Manager.get(filter, { history = true, sort = true, reverse = false }))
        view:display()
      end,
      desc = "Noice messages (oldest first)",
    },
  },
}
