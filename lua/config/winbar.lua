-- Per-window buffer tabs rendered in the winbar
-- Tracks which buffers belong to each window and renders clickable tabs

local M = {}

-- Window-local buffer lists: { [win_id] = { buf1, buf2, ... } }
-- Using vim.w to persist per-window so it survives across redraws
local api = vim.api

--- Get the buffer list for a window
---@param win number
---@return number[]
local function get_win_bufs(win)
  local ok, bufs = pcall(api.nvim_win_get_var, win, "winbar_bufs")
  if ok and type(bufs) == "table" then
    -- Filter out invalid/unlisted buffers
    return vim.tbl_filter(function(b)
      return api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end, bufs)
  end
  return {}
end

--- Save the buffer list for a window
---@param win number
---@param bufs number[]
local function set_win_bufs(win, bufs)
  if api.nvim_win_is_valid(win) then
    api.nvim_win_set_var(win, "winbar_bufs", bufs)
  end
end

--- Add a buffer to a window's list (if not already present)
---@param win number
---@param buf number
local function add_buf_to_win(win, buf)
  if not api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
    return
  end
  -- Skip special buffers
  local bt = vim.bo[buf].buftype
  if bt ~= "" then
    return
  end

  local bufs = get_win_bufs(win)
  for _, b in ipairs(bufs) do
    if b == buf then
      return -- Already tracked
    end
  end
  table.insert(bufs, buf)
  set_win_bufs(win, bufs)
end

--- Remove a buffer from a window's list
---@param win number
---@param buf number
function M.remove_buf_from_win(win, buf)
  local bufs = get_win_bufs(win)
  local new_bufs = vim.tbl_filter(function(b)
    return b ~= buf
  end, bufs)
  set_win_bufs(win, new_bufs)
end

--- Remove a buffer from all windows
---@param buf number
function M.remove_buf_from_all(buf)
  for _, win in ipairs(api.nvim_list_wins()) do
    M.remove_buf_from_win(win, buf)
  end
end

--- Switch to a buffer in the current window (click handler)
---@param buf number
function M.switch_to_buf(buf)
  if api.nvim_buf_is_valid(buf) then
    api.nvim_set_current_buf(buf)
  end
end

--- Close a buffer from the winbar tab (middle-click / close icon handler)
--- Removes from current window only; deletes buffer if no other window has it
---@param buf number
function M.close_buf(buf)
  if not api.nvim_buf_is_valid(buf) then
    return
  end

  local win = api.nvim_get_current_win()
  local win_bufs = get_win_bufs(win)

  -- Remove buffer from this window's tracking
  M.remove_buf_from_win(win, buf)

  -- If this buffer is currently displayed in this window, switch to another
  if api.nvim_win_get_buf(win) == buf then
    local remaining = vim.tbl_filter(function(b)
      return b ~= buf and api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end, win_bufs)

    if #remaining > 0 then
      api.nvim_win_set_buf(win, remaining[#remaining])
    else
      -- No buffers left in this window — close the split
      if #api.nvim_list_wins() > 1 then
        vim.cmd("close")
      else
        -- Last window, create an empty buffer
        vim.cmd("enew")
      end
    end
  end

  -- Check if any other window still has this buffer tracked
  local buf_in_other_win = false
  for _, w in ipairs(api.nvim_list_wins()) do
    if w ~= win then
      local wbufs = get_win_bufs(w)
      for _, b in ipairs(wbufs) do
        if b == buf then
          buf_in_other_win = true
          break
        end
      end
    end
    if buf_in_other_win then
      break
    end
  end

  -- Only fully delete the buffer if no other window is using it
  if not buf_in_other_win then
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.bufdelete then
      snacks.bufdelete(buf)
    else
      pcall(api.nvim_buf_delete, buf, { force = false })
    end
  end

  M.refresh_all()
end

--- Close the current split and delete any buffers that aren't tracked in other windows
function M.close_split_and_cleanup()
  local win = api.nvim_get_current_win()
  local win_bufs = get_win_bufs(win)

  -- Can't close the last window
  if #api.nvim_list_wins() <= 1 then
    return
  end

  -- Close the split first
  vim.cmd("close")

  -- Check each buffer from the closed window — delete if orphaned
  for _, buf in ipairs(win_bufs) do
    if api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local in_other_win = false
      for _, w in ipairs(api.nvim_list_wins()) do
        local wbufs = get_win_bufs(w)
        for _, b in ipairs(wbufs) do
          if b == buf then
            in_other_win = true
            break
          end
        end
        if in_other_win then
          break
        end
      end

      if not in_other_win then
        local ok, snacks = pcall(require, "snacks")
        if ok and snacks.bufdelete then
          snacks.bufdelete(buf)
        else
          pcall(api.nvim_buf_delete, buf, { force = false })
        end
      end
    end
  end

  M.refresh_all()
end

--- Render the winbar for a given window
---@param win number
---@return string
function M.render(win)
  local cur_buf = api.nvim_win_get_buf(win)
  local bufs = get_win_bufs(win)

  -- If no tracked buffers, show just the current file
  if #bufs == 0 then
    return ""
  end

  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  local parts = {}

  for _, buf in ipairs(bufs) do
    local name = vim.fn.fnamemodify(api.nvim_buf_get_name(buf), ":t")
    if name == "" then
      name = "[No Name]"
    end

    local is_active = buf == cur_buf
    local is_modified = vim.bo[buf].modified

    -- File icon
    local icon = ""
    if has_devicons then
      local ft_icon, _ = devicons.get_icon(name)
      if ft_icon then
        icon = ft_icon .. " "
      end
    end

    -- Build the tab
    local hl = is_active and "%#WinBarActive#" or "%#WinBarInactive#"
    local sep_hl = is_active and "%#WinBarActiveSep#" or "%#WinBarInactiveSep#"
    local mod_indicator = is_modified and " ●" or ""

    -- Click handler to switch buffer
    local click = string.format("%%@v:lua.require'config.winbar'.switch_to_buf_click_%d@", buf)

    -- Close button click handler
    local close_click = string.format("%%@v:lua.require'config.winbar'.close_buf_click_%d@", buf)
    local close_icon = " " .. close_click .. "󰅖" .. "%X"

    table.insert(parts, sep_hl .. "▎" .. hl .. click .. " " .. icon .. name .. mod_indicator .. close_icon .. " %X")
  end

  return table.concat(parts, "")
end

--- Generate the winbar string for the current window
---@return string
function M.eval()
  local win = api.nvim_get_current_win()
  local buf = api.nvim_win_get_buf(win)

  -- Skip special buffers
  local bt = vim.bo[buf].buftype
  if bt ~= "" then
    return ""
  end

  return M.render(win)
end

--- Set up highlight groups
local function setup_highlights()
  -- Active tab
  api.nvim_set_hl(0, "WinBarActive", {
    fg = "#ABB2BF",
    bg = "#2C313C",
    bold = true,
  })
  api.nvim_set_hl(0, "WinBarActiveSep", {
    fg = "#61AFEF",
    bg = "#2C313C",
  })
  -- Inactive tab
  api.nvim_set_hl(0, "WinBarInactive", {
    fg = "#5C6370",
    bg = "#22252C",
  })
  api.nvim_set_hl(0, "WinBarInactiveSep", {
    fg = "#3E4452",
    bg = "#22252C",
  })
end

--- Initialize the winbar system
function M.setup()
  setup_highlights()

  local group = api.nvim_create_augroup("WinBarBufferTabs", { clear = true })

  -- Track buffer entry per window
  api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      local win = api.nvim_get_current_win()
      local buf = api.nvim_get_current_buf()
      add_buf_to_win(win, buf)

      -- Refresh winbar for all windows
      M.refresh_all()
    end,
  })

  -- Also track on WinEnter to catch splits
  api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
      local win = api.nvim_get_current_win()
      local buf = api.nvim_get_current_buf()
      add_buf_to_win(win, buf)
      M.refresh_all()
    end,
  })

  -- Clean up when buffers are deleted
  api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(ev)
      M.remove_buf_from_all(ev.buf)
      vim.schedule(function()
        M.refresh_all()
      end)
    end,
  })

  -- Refresh on buffer modification state change
  api.nvim_create_autocmd({ "BufModifiedSet" }, {
    group = group,
    callback = function()
      M.refresh_all()
    end,
  })

  -- Refresh highlights on colorscheme change
  api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      setup_highlights()
    end,
  })

  -- Initial setup for existing windows
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    add_buf_to_win(win, buf)
  end

  M.refresh_all()
end

--- Refresh winbar for all windows
function M.refresh_all()
  for _, win in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_is_valid(win) then
      local buf = api.nvim_win_get_buf(win)
      local bt = vim.bo[buf].buftype
      -- Only set winbar for normal buffers
      if bt == "" then
        -- Use window-local option
        api.nvim_set_option_value("winbar", "%{%v:lua.require'config.winbar'.eval_win(" .. win .. ")%}", { win = win })
      else
        api.nvim_set_option_value("winbar", "", { win = win })
      end
    end
  end
end

--- Evaluate winbar for a specific window (called from winbar expression)
---@param win number
---@return string
function M.eval_win(win)
  if not api.nvim_win_is_valid(win) then
    return ""
  end
  local buf = api.nvim_win_get_buf(win)
  local bt = vim.bo[buf].buftype
  if bt ~= "" then
    return ""
  end
  return M.render(win)
end

-- Dynamically create click handler functions for each buffer
-- This is needed because winbar %@ click handlers need global function references
setmetatable(M, {
  __index = function(_, key)
    -- Match switch_to_buf_click_<bufnr>
    local switch_buf = key:match("^switch_to_buf_click_(%d+)$")
    if switch_buf then
      local buf = tonumber(switch_buf)
      return function(_, _, button, _)
        if button == "l" then
          M.switch_to_buf(buf)
        elseif button == "m" then
          M.close_buf(buf)
        end
      end
    end

    -- Match close_buf_click_<bufnr>
    local close_buf = key:match("^close_buf_click_(%d+)$")
    if close_buf then
      local buf = tonumber(close_buf)
      return function(_, _, _, _)
        M.close_buf(buf)
      end
    end
  end,
})

return M
