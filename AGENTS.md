# AGENTS.md - AI Agent Guidelines for neovim-setup

This document provides guidelines for AI coding agents working with this Neovim configuration repository.

## Project Overview

This is a **Neovim configuration** written in Lua, focused on **backend/GitOps development**. It uses lazy.nvim as the plugin manager and provides LSP support for Go, Python, Rust, Terraform, Kubernetes, Docker, and other DevOps tools.

## Technology Stack

- **Language**: Lua (Neovim's native configuration language)
- **Plugin Manager**: lazy.nvim (folke/lazy.nvim)
- **Target Users**: Backend developers, DevOps/GitOps engineers

## Build/Lint/Test Commands

This is a Neovim configuration, not a compiled application. There are no traditional build/test commands.

### Installation & Usage

```bash
# Clone or symlink to Neovim config directory
ln -s /path/to/neovim-setup ~/.config/nvim

# Launch Neovim - plugins will bootstrap automatically
nvim
```

### Validation Commands (inside Neovim)

```vim
:checkhealth              " Run health checks for all plugins
:Lazy                     " Open plugin manager UI
:Lazy sync                " Update all plugins
:Lazy check               " Check for plugin updates
:LspInfo                  " Show LSP status for current buffer
```

### Linting Lua Files (optional, external)

```bash
# If luacheck is installed
luacheck lua/

# If stylua is installed
stylua --check lua/
```

## Directory Structure

```
init.lua                    # Entry point - loads config modules
lua/
  config/
    options.lua             # Neovim options (vim.opt)
    keymaps.lua             # Global key mappings
    autocmds.lua            # Autocommands
    lazy.lua                # Plugin manager bootstrap
  plugins/
    coding/                 # Coding-related plugins
      blink-completion.lua  # Completions
      minipairs-autopairs.lua
      treesitter-syntax.lua
    editor/                 # Editor enhancements
      surround-edit.lua
    git/                    # Git integration
      gitsigns-git.lua
    lsp/                    # Language server support
      nvim-lspconfig-servers.lua
    tools/                  # External tool integrations
      opencode-ai.lua
    ui/                     # UI components
      lualine-statusline.lua
      noice-notifications.lua
      onedarkpro-theme.lua
      snacks-utils.lua
      whichkey-keys.lua
```

## Code Style Guidelines

### Indentation & Formatting

- **Indentation**: 2 spaces (no tabs)
- **Line length**: No strict limit, but keep readable (~100 chars)
- **String quotes**: Double quotes (`"`) consistently
- **Trailing commas**: Always use in multi-line tables

### Naming Conventions

- **Plugin files**: `{plugin}-{purpose}.lua` (e.g., `telescope-finder.lua`, `lsp-config.lua`)
- **Filenames**: All lowercase with hyphens, descriptive suffixes
- **Variables**: `snake_case` for locals, follow Neovim API conventions
- **Augroup names**: PascalCase (e.g., `"General"`, `"FileTypes"`)

### Lua Idioms

```lua
-- Use local aliases for frequently accessed APIs
local opt = vim.opt
local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Options pattern
local opts = { noremap = true, silent = true }
```

### Plugin Configuration Pattern (lazy.nvim)

```lua
-- Single-line comment describing the plugin's purpose
return {
  {
    "author/plugin-name",
    event = { "BufReadPre", "BufNewFile" },  -- Lazy loading events
    dependencies = {
      "dependency/plugin",
      { "optional/plugin", opts = {} },      -- Inline opts for simple deps
    },
    opts = {
      -- Configuration options (auto-calls setup)
    },
    -- OR for complex configs:
    config = function()
      require("plugin").setup({
        -- Configuration
      })
    end,
  },
}
```

### Keymap Conventions

```lua
-- Always include desc for which-key integration
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- Use vim.keymap.set, not vim.api.nvim_set_keymap
keymap("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
```

### Autocommand Pattern

```lua
-- Always use named groups with clear = true
local group = augroup("GroupName", { clear = true })

autocmd("EventName", {
  group = group,
  pattern = "*.lua",
  callback = function()
    -- Handler code
  end,
})
```

## Key Bindings Reference

| Category | Prefix | Examples |
|----------|--------|----------|
| File operations | `<leader>f` | `ff` find, `fg` grep, `fb` buffers |
| Git operations | `<leader>g` | `gc` commits, `gb` branches, `gs` status |
| Git hunks | `<leader>h` | `hs` stage, `hr` reset, `hp` preview |
| LSP | `g` / `<leader>` | `gd` definition, `gr` references, `ca` code action |
| Toggles | `<leader>t` | `tb` toggle blame, `tc` toggle time format, `td` toggle diagnostics |
| Notifications | `<leader>n` | `nh` history (snacks), `nn` all messages (noice), `nd` dismiss |
| Windows | `<leader>s` | `sv` vertical, `sh` horizontal split |
| Diagnostics | `[d` / `]d` | Navigate prev/next diagnostic |

## LSP Servers Configured

Backend/GitOps focus:
- **Go**: `gopls` (with gofumpt, staticcheck)
- **Python**: `pyright`
- **Rust**: `rust_analyzer` (with clippy)
- **Terraform**: `terraformls`, `tflint`
- **YAML**: `yamlls` (with K8s, Docker Compose, GitHub Actions schemas)
- **Docker**: `dockerls`, `docker_compose_language_service`
- **Shell**: `bashls`
- **Helm**: `helm_ls`
- **Lua**: `lua_ls` (for Neovim config)
- **JSON**: `jsonls`

## Error Handling

- Use `pcall()` for operations that may fail (e.g., loading optional extensions)
- Prefer graceful degradation over hard errors
- Use `:checkhealth` to diagnose issues

```lua
-- Example: Safe extension loading
pcall(telescope.load_extension, "fzf")
```

## Important Notes for Agents

1. **No external dependencies**: This repo is self-contained Lua config
2. **Lazy loading**: Plugins use events/commands for deferred loading
3. **LSP servers are external tools**: Install them outside Neovim and keep them on `$PATH`
4. **Leader key is Space**: All `<leader>` mappings use spacebar
5. **Follow existing patterns**: Match the style of neighboring code
6. **Test changes**: After editing, open Neovim and run `:checkhealth`
7. **Plugin files return tables**: Each file in `lua/plugins/` must return a lazy.nvim spec table

## File Type Detection

Custom filetypes are detected in `lua/config/autocmds.lua`:
- `*.tf`, `*.tfvars` -> terraform
- `*/templates/*.yaml` -> helm
- `Dockerfile*` -> dockerfile

## Common Tasks

### Adding a New Plugin

1. Create `lua/plugins/{category}/{name}-{purpose}.lua`
2. Return a lazy.nvim spec table
3. Restart Neovim or run `:Lazy sync`

### Adding a New LSP Server

1. Add to the `servers` table in `lua/plugins/lsp/nvim-lspconfig-servers.lua`
2. Install the server executable outside Neovim and ensure it is available on `$PATH`
3. Restart Neovim or run `:LspInfo` to verify the server attaches

### Adding Global Keymaps

1. Edit `lua/config/keymaps.lua`
2. Use `vim.keymap.set()` with descriptive `desc` option

### Time Format Toggle

The config includes a unified time format toggle (`<leader>tc`) that syncs:
- Lualine statusline clock
- Noice message timestamps  
- Snacks notification timestamps

Default is 12-hour format. The toggle updates all three systems at runtime using:
- `vim.g.time_format_12hr` global variable
- Direct config updates to noice and snacks notifier
