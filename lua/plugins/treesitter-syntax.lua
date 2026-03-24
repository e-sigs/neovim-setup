-- treesitter-syntax - Syntax highlighting
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Languages for backend/GitOps development
      local ensure_installed = {
        -- Backend
        "go", "gomod", "gosum", "python", "rust",
        -- GitOps/DevOps
        "terraform", "hcl", "yaml", "json", "jsonc", "toml", "dockerfile", "bash", "make",
        -- Config/Misc
        "lua", "luadoc", "vim", "vimdoc", "markdown", "markdown_inline",
        "gitcommit", "gitignore", "diff", "regex",
      }

      -- Install parsers
      require("nvim-treesitter").install(ensure_installed)

      -- Enable features via vim.treesitter
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
