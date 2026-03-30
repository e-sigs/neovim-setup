-- Per-window buffer tabs (VS Code-style editor groups)
return {
  {
    "e-sigs/winbuf.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      buf_delete = function(buf)
        Snacks.bufdelete(buf)
      end,
    },
    keys = {
      -- Cycle buffers within the current window group
      { "<S-h>", function() require("winbuf").cycle(-1) end, desc = "Previous buffer (window)" },
      { "<S-l>", function() require("winbuf").cycle(1) end, desc = "Next buffer (window)" },
      { "[b", function() require("winbuf").cycle(-1) end, desc = "Previous buffer (window)" },
      { "]b", function() require("winbuf").cycle(1) end, desc = "Next buffer (window)" },

      -- Move buffer to adjacent split
      { "<A-h>", function() require("winbuf").move_buf("h") end, desc = "Move buffer left" },
      { "<A-l>", function() require("winbuf").move_buf("l") end, desc = "Move buffer right" },
      { "<A-j>", function() require("winbuf").move_buf("j") end, desc = "Move buffer down" },
      { "<A-k>", function() require("winbuf").move_buf("k") end, desc = "Move buffer up" },
    },
  },
}
