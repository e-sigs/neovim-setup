-- OpenCode AI assistant integration
return {
  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "opencode_output" },
      },
      -- Use blink.cmp for completion (already in your config)
      "saghen/blink.cmp",
      -- Use snacks.nvim for picker (already in your config)
      "folke/snacks.nvim",
    },
    cmd = "Opencode",
    keys = {
      { "<leader>og", desc = "Toggle OpenCode" },
      { "<leader>oi", desc = "Open input" },
      { "<leader>oo", desc = "Open output" },
      { "<leader>os", desc = "Select session" },
      { "<leader>oq", desc = "Close OpenCode" },
    },
    config = function()
      require("opencode").setup({
        -- Use existing plugins for picker/completion
        preferred_picker = "snacks",
        preferred_completion = "blink",

        -- Default to build mode
        default_mode = "build",

        ui = {
          position = "right",
          window_width = 0.40,
          display_model = true,
          display_cost = true,
        },

        context = {
          enabled = true,
          current_file = {
            enabled = true,
            show_full_path = true,
          },
          selection = {
            enabled = true,
          },
          diagnostics = {
            warning = true,
            error = true,
          },
        },
      })
    end,
  },
}
