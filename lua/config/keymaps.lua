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

-- Buffer navigation and movement handled by winbuf.nvim (see plugins/ui/winbuf-tabs.lua)

-- Close buffer/split with Ctrl-w (defined in whichkey-keys.lua)

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

-- Key lookup: press <leader>? then build a key combo, Enter to search
keymap("n", "<leader>?", function()
  local keys = {}

  while true do
    local prompt = #keys == 0
      and "Key lookup: press keys, <Enter> to search, <Esc> to cancel"
      or "Keys: " .. table.concat(keys, "") .. "  (<Enter> search, <Esc> cancel, <BS> undo)"
    vim.api.nvim_echo({ { prompt, "MoreMsg" } }, false, {})

    local ok, raw = pcall(vim.fn.getcharstr)
    if not ok then return end

    local name = vim.fn.keytrans(raw)
    if name == "<CR>" then
      break
    elseif name == "<Esc>" then
      vim.api.nvim_echo({ { "" } }, false, {})
      -- no input: just open the full keymaps picker
      if #keys == 0 then
        Snacks.picker.keymaps()
      end
      return
    elseif name == "<BS>" then
      table.remove(keys)
    else
      table.insert(keys, name)
    end
  end

  local query = table.concat(keys, "")
  if query == "" then
    Snacks.picker.keymaps()
  else
    Snacks.picker.keymaps({ pattern = "'" .. query })
  end
end, { desc = "Key lookup" })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- ============================================================
-- Vim motions cheat sheet
-- Maps native motions to themselves so they appear in keymaps finder
-- ============================================================

-- Scrolling & centering
keymap("n", "zz", "zz", { desc = "Center line on screen" })
keymap("n", "zt", "zt", { desc = "Scroll line to top" })
keymap("n", "zb", "zb", { desc = "Scroll line to bottom" })
keymap("n", "<C-f>", "<C-f>", { desc = "Page down" })
keymap("n", "<C-b>", "<C-b>", { desc = "Page up" })

-- Navigation
keymap("n", "gg", "gg", { desc = "Go to first line" })
keymap("n", "G", "G", { desc = "Go to last line" })
keymap("n", "0", "0", { desc = "Go to line start" })
keymap("n", "$", "$", { desc = "Go to line end" })
keymap("n", "^", "^", { desc = "Go to first non-blank" })
keymap("n", "w", "w", { desc = "Next word" })
keymap("n", "b", "b", { desc = "Previous word" })
keymap("n", "e", "e", { desc = "End of word" })
keymap("n", "W", "W", { desc = "Next WORD (whitespace-delimited)" })
keymap("n", "B", "B", { desc = "Previous WORD" })
keymap("n", "E", "E", { desc = "End of WORD" })
keymap("n", "%", "%", { desc = "Jump to matching bracket" })
keymap("n", "{", "{", { desc = "Previous paragraph" })
keymap("n", "}", "}", { desc = "Next paragraph" })
-- H/L remapped by winbuf.nvim to cycle buffers (see winbuf-tabs.lua)
keymap("n", "M", "M", { desc = "Jump to screen middle" })
keymap("n", "f", "f", { desc = "Find char forward" })
keymap("n", "F", "F", { desc = "Find char backward" })
keymap("n", "t", "t", { desc = "Till char forward" })
keymap("n", "T", "T", { desc = "Till char backward" })
keymap("n", ";", ";", { desc = "Repeat f/t forward" })
keymap("n", ",", ",", { desc = "Repeat f/t backward" })

-- Editing
keymap("n", "dd", "dd", { desc = "Delete line" })
keymap("n", "yy", "yy", { desc = "Yank line" })
keymap("n", "cc", "cc", { desc = "Change line" })
keymap("n", "C", "C", { desc = "Change to end of line" })
keymap("n", "D", "D", { desc = "Delete to end of line" })
keymap("n", "x", "x", { desc = "Delete char under cursor" })
-- s is used as a prefix by nvim-surround (ys/ds/cs), bare s still works
keymap("n", "S", "S", { desc = "Delete line and insert" })
keymap("n", "o", "o", { desc = "New line below" })
keymap("n", "O", "O", { desc = "New line above" })
keymap("n", "p", "p", { desc = "Paste after" })
keymap("n", "P", "P", { desc = "Paste before" })
keymap("n", "u", "u", { desc = "Undo" })
keymap("n", "<C-r>", "<C-r>", { desc = "Redo" })
keymap("n", ".", ".", { desc = "Repeat last change" })
keymap("n", "J", "J", { desc = "Join line below" })
keymap("n", "~", "~", { desc = "Toggle case" })
keymap("n", ">>", ">>", { desc = "Indent line" })
keymap("n", "<<", "<<", { desc = "Unindent line" })
keymap("n", "r", "r", { desc = "Replace char" })
keymap("n", "R", "R", { desc = "Replace mode" })

-- Text objects (operator-pending, used with d/c/y/v)
keymap("n", "ciw", "ciw", { desc = "Change inner word" })
keymap("n", "diw", "diw", { desc = "Delete inner word" })
keymap("n", "yiw", "yiw", { desc = "Yank inner word" })
keymap("n", "viw", "viw", { desc = "Select inner word" })
keymap("n", "ci'", "ci'", { desc = "Change inner single quotes" })
keymap("n", "ci\"", "ci\"", { desc = "Change inner double quotes" })
keymap("n", "ci(", "ci(", { desc = "Change inner parens" })
keymap("n", "ci{", "ci{", { desc = "Change inner braces" })
keymap("n", "ci[", "ci[", { desc = "Change inner brackets" })
keymap("n", "cit", "cit", { desc = "Change inner tag" })
keymap("n", "ca'", "ca'", { desc = "Change around single quotes" })
keymap("n", "ca\"", "ca\"", { desc = "Change around double quotes" })
keymap("n", "ca(", "ca(", { desc = "Change around parens" })
keymap("n", "ca{", "ca{", { desc = "Change around braces" })
keymap("n", "di'", "di'", { desc = "Delete inner single quotes" })
keymap("n", "di\"", "di\"", { desc = "Delete inner double quotes" })
keymap("n", "di(", "di(", { desc = "Delete inner parens" })
keymap("n", "di{", "di{", { desc = "Delete inner braces" })

-- Search
keymap("n", "*", "*", { desc = "Search word under cursor" })
keymap("n", "#", "#", { desc = "Search word backward" })
keymap("n", "g*", "g*", { desc = "Search word (partial match)" })
keymap("n", "g#", "g#", { desc = "Search word backward (partial)" })

-- Marks
keymap("n", "ma", "ma", { desc = "Set mark 'a'" })
keymap("n", "mb", "mb", { desc = "Set mark 'b'" })
keymap("n", "`a", "`a", { desc = "Jump to mark 'a'" })
keymap("n", "`b", "`b", { desc = "Jump to mark 'b'" })
keymap("n", "'a", "'a", { desc = "Jump to mark 'a' (line)" })
keymap("n", "'b", "'b", { desc = "Jump to mark 'b' (line)" })
keymap("n", "``", "``", { desc = "Jump to last position" })
keymap("n", "`.", "`.", { desc = "Jump to last edit" })

-- Visual mode
keymap("n", "v", "v", { desc = "Visual char mode" })
keymap("n", "V", "V", { desc = "Visual line mode" })
keymap("n", "<C-v>", "<C-v>", { desc = "Visual block mode" })
keymap("v", "gv", "gv", { desc = "Reselect last selection" })
keymap("v", "o", "o", { desc = "Swap cursor to other end" })

-- Insert mode entry
keymap("n", "i", "i", { desc = "Insert before cursor" })
keymap("n", "I", "I", { desc = "Insert at line start" })
keymap("n", "a", "a", { desc = "Append after cursor" })
keymap("n", "A", "A", { desc = "Append at line end" })
