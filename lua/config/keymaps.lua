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

-- Buffer navigation (cycles within current window's buffer group)
local function cycle_win_buf(offset)
  local ok, winbar = pcall(require, "config.winbar")
  if not ok then
    -- Fallback to global bnext/bprev
    vim.cmd(offset > 0 and "bnext" or "bprevious")
    return
  end
  local win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_get_current_buf()
  local win_bufs_ok, bufs = pcall(vim.api.nvim_win_get_var, win, "winbar_bufs")
  if not win_bufs_ok or #bufs < 2 then
    return
  end
  -- Filter to valid listed buffers
  bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, bufs)
  if #bufs < 2 then
    return
  end
  -- Find current index
  local idx = 1
  for i, b in ipairs(bufs) do
    if b == cur_buf then
      idx = i
      break
    end
  end
  -- Cycle
  local new_idx = ((idx - 1 + offset) % #bufs) + 1
  vim.api.nvim_set_current_buf(bufs[new_idx])
end

keymap("n", "<S-l>", function() cycle_win_buf(1) end, { desc = "Next buffer (window)", silent = true })
keymap("n", "<S-h>", function() cycle_win_buf(-1) end, { desc = "Previous buffer (window)", silent = true })
keymap("n", "]b", function() cycle_win_buf(1) end, { desc = "Next buffer (window)", silent = true })
keymap("n", "[b", function() cycle_win_buf(-1) end, { desc = "Previous buffer (window)", silent = true })

-- Close buffer with Ctrl-w (defined in whichkey-keys.lua, closes split)

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
keymap("n", "<leader>qq", ":qa<CR>", { desc = "Quit all", silent = true })
keymap("n", "<leader>qw", ":wq<CR>", { desc = "Save and quit", silent = true })
keymap("n", "<leader>qQ", ":q!<CR>", { desc = "Quit without saving", silent = true })

-- Split windows (using leader since C-w is now close buffer)
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical", silent = true })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal", silent = true })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal split size" })

-- Move buffer to adjacent split (VS Code-style Option+h/j/k/l)
-- If a split exists in that direction, move the buffer there
-- If no split exists, create one and move the buffer there
local function move_buf_to_split(direction)
  local buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()

  -- Only move normal file buffers (not explorers, terminals, pickers, etc.)
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].buflisted then
    return
  end

  -- Try to move to the target direction
  vim.cmd("wincmd " .. direction)
  local target_win = vim.api.nvim_get_current_win()

  if target_win == cur_win then
    -- No split in that direction — create one
    if direction == "l" or direction == "h" then
      vim.cmd("vsplit")
    else
      vim.cmd("split")
    end
    if direction == "h" or direction == "k" then
      -- vsplit/split opens right/below, swap to put new window left/above
      vim.cmd("wincmd " .. direction:upper())
    end
    target_win = vim.api.nvim_get_current_win()
  end

  -- Go back to the original window first (before setting target buffer)
  vim.api.nvim_set_current_win(cur_win)

  -- Find another buffer in the source window to switch to
  local win_bufs = {}
  local wbok, wb = pcall(vim.api.nvim_win_get_var, cur_win, "winbar_bufs")
  if wbok and type(wb) == "table" then
    win_bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= buf
    end, wb)
  end

  -- Switch the source window to a different buffer (or close it)
  if #win_bufs > 0 then
    vim.api.nvim_win_set_buf(cur_win, win_bufs[#win_bufs])
  else
    -- No other buffers in this window — close the split
    vim.cmd("close")
  end

  -- Now remove the moved buffer from the source window's tracking
  local ok, winbar = pcall(require, "config.winbar")
  if ok then
    winbar.remove_buf_from_win(cur_win, buf)
  end

  -- Set the buffer in the target window (triggers BufEnter which adds to target)
  vim.api.nvim_set_current_win(target_win)
  vim.api.nvim_win_set_buf(target_win, buf)

  -- Force refresh all winbars
  if ok then
    winbar.refresh_all()
  end
end

keymap("n", "<A-l>", function() move_buf_to_split("l") end, { desc = "Move buffer right", silent = true })
keymap("n", "<A-h>", function() move_buf_to_split("h") end, { desc = "Move buffer left", silent = true })
keymap("n", "<A-j>", function() move_buf_to_split("j") end, { desc = "Move buffer down", silent = true })
keymap("n", "<A-k>", function() move_buf_to_split("k") end, { desc = "Move buffer up", silent = true })

-- Tab management
keymap("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab", silent = true })
keymap("n", "<leader><Tab>x", "<cmd>tabclose<CR>", { desc = "Close tab", silent = true })
keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab", silent = true })
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab", silent = true })

-- Diagnostic keymaps (using 0.11+ API)
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
keymap("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- Cmdline navigation (for noice popupmenu)
keymap("c", "<Down>", "<C-n>", { desc = "Next item" })
keymap("c", "<Up>", "<C-p>", { desc = "Previous item" })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })
