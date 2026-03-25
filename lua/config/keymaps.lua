-- Keymaps configuration
local keymap = vim.keymap.set

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Window left" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Window down" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Window up" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up", silent = true })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down", silent = true })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left", silent = true })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right", silent = true })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Close buffer with Ctrl-w (defined in whichkey-keys.lua to use Snacks)

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Stay in indent mode when indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
keymap("n", "n", "nzzzv", { desc = "Next search centered" })
keymap("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Paste without overwriting register
keymap("v", "p", '"_dP', { desc = "Paste without yank" })

-- Quick save/quit (descriptions shown by which-key)
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file", silent = true })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit", silent = true })
keymap("n", "<leader>qq", ":qa<CR>", { desc = "Quit all", silent = true })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit", silent = true })

-- Split windows (using leader since C-w is now close buffer)
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical", silent = true })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal", silent = true })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal split size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close split", silent = true })

-- Diagnostic keymaps (using 0.11+ API)
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
keymap("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
