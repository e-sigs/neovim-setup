-- Vimpack plugin management and configuration
-- Existing plugin files keep their current spec table shape during migration.

if not vim.pack then
  error("This configuration requires Neovim 0.12+ with vim.pack")
end

if vim.g.time_format_12hr == nil then
  vim.g.time_format_12hr = true
end

local function gh(repo)
  return "https://github.com/" .. repo .. ".git"
end

local plugins = {
  { src = gh("olimorris/onedarkpro.nvim") },
  { src = gh("nvim-tree/nvim-web-devicons") },
  { src = gh("folke/snacks.nvim") },
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
  { src = gh("echasnovski/mini.pairs") },
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "90cd6580" },
  { src = gh("nvim-treesitter/nvim-treesitter-textobjects") },
  { src = gh("kylechui/nvim-surround"), version = vim.version.range("*") },
  { src = gh("lewis6991/gitsigns.nvim") },
  { src = gh("neovim/nvim-lspconfig") },
  { src = gh("nvim-lualine/lualine.nvim") },
  { src = gh("MunifTanjim/nui.nvim") },
  { src = gh("rcarriga/nvim-notify") },
  { src = gh("folke/noice.nvim") },
  { src = gh("nvim-lua/plenary.nvim") },
  { src = gh("MeanderingProgrammer/render-markdown.nvim") },
  { src = gh("sudo-tee/opencode.nvim") },
  { src = gh("folke/which-key.nvim") },
}

local local_plugins = {
  "/Users/dojo/dev/projects/winbuf.nvim",
}

local main_modules = {
  ["blink.cmp"] = "blink.cmp",
  ["gitsigns.nvim"] = "gitsigns",
  ["lualine.nvim"] = "lualine",
  ["mini.pairs"] = "mini.pairs",
  ["noice.nvim"] = "noice",
  ["nvim-surround"] = "nvim-surround",
  ["nvim-web-devicons"] = "nvim-web-devicons",
  ["opencode.nvim"] = "opencode",
  ["render-markdown.nvim"] = "render-markdown",
  ["snacks.nvim"] = "snacks",
  ["winbuf.nvim"] = "winbuf",
}

local plugin_modules = {
  "plugins.ui.onedarkpro-theme",
  "plugins.ui.devicons-overrides",
  "plugins.ui.snacks-utils",
  "plugins.coding.blink-completion",
  "plugins.coding.minipairs-autopairs",
  "plugins.coding.treesitter-syntax",
  "plugins.editor.surround-edit",
  "plugins.git.gitsigns-git",
  "plugins.lsp.nvim-lspconfig-servers",
  "plugins.ui.noice-notifications",
  "plugins.ui.lualine-statusline",
  "plugins.ui.winbuf-tabs",
  "plugins.tools.opencode-ai",
  "plugins.ui.whichkey-keys",
}

local function add_local_plugins()
  for _, path in ipairs(local_plugins) do
    if vim.uv.fs_stat(path) then
      vim.opt.rtp:prepend(path)
    else
      vim.notify("Local plugin not found: " .. path, vim.log.levels.WARN)
    end
  end
end

local function add_pack_hooks()
  vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("VimpackHooks", { clear = true }),
    callback = function(ev)
      local data = ev.data or {}
      local spec = data.spec or {}
      local is_treesitter = spec.name == "nvim-treesitter"
      local changed = data.kind == "install" or data.kind == "update"
      if is_treesitter and changed then
        vim.schedule(function()
          pcall(vim.cmd, "TSUpdate")
        end)
      end
    end,
  })
end

local function plugin_name(spec)
  if type(spec) ~= "table" then
    return nil
  end

  if type(spec.name) == "string" then
    return spec.name
  end

  local source = spec[1] or spec.src or spec.url or spec.dir
  if type(source) ~= "string" then
    return nil
  end

  source = source:gsub("%.git$", "")
  return source:match("([^/]+)$")
end

local function is_plugin_spec(value)
  return type(value) == "table"
    and (
      type(value[1]) == "string"
      or type(value.src) == "string"
      or type(value.url) == "string"
      or type(value.dir) == "string"
      or type(value.name) == "string"
    )
end

local function normalize_specs(value)
  if is_plugin_spec(value) then
    return { value }
  end
  return value or {}
end

local function resolve_opts(spec)
  if type(spec.opts) == "function" then
    return spec.opts(spec, {})
  end
  return spec.opts
end

local function setup_from_opts(spec)
  local name = plugin_name(spec)
  local main = main_modules[name]
  if not main then
    error("No setup module configured for plugin: " .. tostring(name))
  end

  local ok, module = pcall(require, main)
  if not ok then
    error("Failed to require " .. main .. " for " .. tostring(name) .. ": " .. module)
  end

  if type(module.setup) ~= "function" then
    error("Plugin module has no setup function: " .. main)
  end

  module.setup(resolve_opts(spec))
end

local function apply_keys(spec)
  if type(spec.keys) ~= "table" then
    return
  end

  for _, key in ipairs(spec.keys) do
    if type(key) == "table" and key[1] and key[2] ~= nil then
      local opts = {}
      for opt, value in pairs(key) do
        if type(opt) == "string" and opt ~= "mode" then
          opts[opt] = value
        end
      end

      vim.keymap.set(key.mode or "n", key[1], key[2], opts)
    end
  end
end

local configured = {}

local function apply_spec(spec)
  if type(spec) ~= "table" then
    return
  end

  if type(spec.dependencies) == "table" then
    for _, dep in ipairs(spec.dependencies) do
      if type(dep) == "table" then
        apply_spec(dep)
      end
    end
  end

  local name = plugin_name(spec)
  local has_setup = type(spec.config) == "function" or spec.opts ~= nil

  if has_setup and name and not configured[name] then
    if type(spec.config) == "function" then
      spec.config(spec, resolve_opts(spec))
    elseif spec.opts ~= nil then
      setup_from_opts(spec)
    end
    configured[name] = true
  end

  apply_keys(spec)
end

local function load_plugin_specs()
  local specs = {}

  for _, module_name in ipairs(plugin_modules) do
    local ok, module = pcall(require, module_name)
    if not ok then
      error("Failed to load plugin module " .. module_name .. ": " .. module)
    end

    for _, spec in ipairs(normalize_specs(module)) do
      specs[#specs + 1] = spec
    end
  end

  return specs
end

local function run_init_hooks(specs)
  for _, spec in ipairs(specs) do
    if type(spec.init) == "function" then
      spec.init(spec)
    end
  end
end

local function apply_plugin_configs(specs)
  for _, spec in ipairs(specs) do
    apply_spec(spec)
  end
end

local very_lazy_fired = false

local function fire_very_lazy()
  if very_lazy_fired then
    return
  end
  very_lazy_fired = true
  vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
end

local function add_pack_commands()
  vim.api.nvim_create_user_command("PackUpdate", function(opts)
    local names = #opts.fargs > 0 and opts.fargs or nil
    vim.pack.update(names)
  end, {
    nargs = "*",
    complete = function()
      return vim.tbl_map(function(plugin)
        return plugin.spec.name
      end, vim.pack.get(nil, { info = false }))
    end,
    desc = "Update Vimpack plugins",
  })

  vim.api.nvim_create_user_command("PackStatus", function()
    vim.pack.update(nil, { offline = true })
  end, {
    desc = "Show Vimpack plugin status",
  })

  vim.keymap.set("n", "<leader>l", "<cmd>PackStatus<cr>", { desc = "Plugin status" })
  vim.keymap.set("n", "<leader>pu", "<cmd>PackUpdate<cr>", { desc = "Update plugins" })
  vim.keymap.set("n", "<leader>ps", "<cmd>PackStatus<cr>", { desc = "Plugin status" })
end

add_local_plugins()
add_pack_hooks()

local specs = load_plugin_specs()
run_init_hooks(specs)

vim.pack.add(plugins, { load = true, confirm = false })
apply_plugin_configs(specs)
add_pack_commands()

if vim.v.vim_did_enter == 1 then
  vim.schedule(fire_very_lazy)
else
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("VimpackVeryLazy", { clear = true }),
    once = true,
    callback = fire_very_lazy,
  })
end
