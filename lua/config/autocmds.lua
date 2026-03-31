-- Autocommands configuration
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings group
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when Vim is resized
autocmd("VimResized", {
  group = general,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Show dashboard when opening a directory (e.g. `svim .`)
autocmd("VimEnter", {
  group = general,
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      -- wipe the empty directory buffer and clear arglist
      vim.cmd.bdelete()
      vim.cmd("%argdelete")
      -- render dashboard inline (buf=0/win=0 avoids a floating window)
      Snacks.dashboard.open({ buf = 0, win = 0 })
    end
  end,
})

-- GitOps/DevOps file type detection
local filetypes = augroup("FileTypes", { clear = true })

-- Terraform
autocmd({ "BufRead", "BufNewFile" }, {
  group = filetypes,
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.bo.filetype = "terraform"
  end,
})

-- Helm templates
autocmd({ "BufRead", "BufNewFile" }, {
  group = filetypes,
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl" },
  callback = function()
    vim.bo.filetype = "helm"
  end,
})

-- Dockerfile variants
autocmd({ "BufRead", "BufNewFile" }, {
  group = filetypes,
  pattern = { "Dockerfile*", "*.dockerfile" },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})

-- Set YAML settings for common config files
autocmd({ "BufRead", "BufNewFile" }, {
  group = filetypes,
  pattern = {
    "*.yaml",
    "*.yml",
    ".yamllint",
    "docker-compose*.yml",
    "ansible.cfg",
  },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
