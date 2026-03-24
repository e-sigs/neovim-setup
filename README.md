# Neovim Configuration for Backend/GitOps Development

A modern Neovim configuration focused on **backend development** and **GitOps workflows**. Built for Neovim 0.11+ with lazy.nvim as the plugin manager.

## Features

| Feature | Implementation |
|---------|----------------|
| **Completions** | blink.cmp (LSP, snippets, buffer, path sources) |
| **Fuzzy Finder** | Snacks picker (files, grep, buffers, LSP symbols) |
| **LSP** | Mason auto-install with vim.lsp.config (0.11+ API) |
| **Notifications** | Snacks notifier |
| **Git Integration** | Gitsigns (hunks, blame) + Snacks lazygit |
| **UI Components** | Snacks (dashboard, indent guides, input, statuscolumn) |
| **Theme** | Tokyonight + Lualine statusline |
| **Syntax Highlighting** | Treesitter |
| **Keybinding Hints** | which-key |

## Language Server Support

Optimized for backend and DevOps workflows:

- **Go**: `gopls` (with gofumpt, staticcheck)
- **Python**: `pyright`
- **Rust**: `rust_analyzer` (with clippy)
- **Terraform**: `terraformls`, `tflint`
- **YAML**: `yamlls` (with K8s, Docker Compose, GitHub Actions schemas)
- **Docker**: `dockerls`, `docker_compose_language_service`
- **Shell**: `bashls`
- **Helm**: `helm_ls`
- **JSON**: `jsonls`
- **Lua**: `lua_ls` (for Neovim config)

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/neovim-setup.git ~/.config/nvim

# Launch Neovim - plugins will bootstrap automatically
nvim
```

### Requirements

- Neovim 0.11+
- Git
- A Nerd Font (for icons)
- `tree-sitter` CLI (`brew install tree-sitter`)
- `lazygit` (optional, for git TUI)
- `ripgrep` (for grep functionality)

## Keybindings

**Leader key: `Space`**

### General

| Key | Description |
|-----|-------------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<C-w>` | Close buffer |
| `<Esc>` | Clear search highlight |

### Navigation

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `n` / `N` | Next/prev search result (centered) |

### Window Management

| Key | Description |
|-----|-------------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equal split size |
| `<leader>sx` | Close split |
| `<C-Up/Down>` | Resize height |
| `<C-Left/Right>` | Resize width |

### File Finding (`<leader>f`)

| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fw` | Grep word under cursor |
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fd` | Diagnostics |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Buffer lines |
| `<leader>f:` | Command history |
| `<leader>/` | Grep open buffers |
| `<leader><leader>` | Smart picker |

### LSP / Code

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (normal + visual) |
| `<leader>cf` | Format buffer/selection (normal + visual) |

### Diagnostics (`<leader>d`)

| Key | Description |
|-----|-------------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>de` | Show diagnostic float |
| `<leader>dl` | Diagnostic list |

### Git (`<leader>g`)

| Key | Description |
|-----|-------------|
| `<leader>gg` | Lazygit |
| `<leader>gl` | Lazygit log |
| `<leader>gf` | Lazygit file log |
| `<leader>gB` | Git browse (open in GitHub/GitLab) |
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff |

### Git Hunks (`<leader>h`)

| Key | Description |
|-----|-------------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk (normal + visual) |
| `<leader>hr` | Reset hunk (normal + visual) |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this ~ |
| `ih` | Select hunk (text object) |

### Buffer Management (`<leader>b`)

| Key | Description |
|-----|-------------|
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |

### Toggles (`<leader>t`)

| Key | Description |
|-----|-------------|
| `<leader>tt` | Terminal |
| `<leader>tb` | Toggle line blame |
| `<leader>td` | Toggle diagnostics |
| `<leader>ts` | Toggle spelling |
| `<leader>tw` | Toggle wrap |
| `<leader>tl` | Toggle line numbers |
| `<leader>tL` | Toggle relative numbers |
| `<leader>tT` | Toggle treesitter |
| `<leader>th` | Toggle inlay hints |

### UI (`<leader>u`)

| Key | Description |
|-----|-------------|
| `<leader>un` | Dismiss notifications |
| `<leader>n` | Notification history |

### Misc

| Key | Description |
|-----|-------------|
| `<leader>e` | File explorer |
| `<leader>.` | Scratch buffer |
| `<leader>S` | Select scratch buffer |
| `<C-/>` | Toggle terminal |
| `]]` / `[[` | Next/prev reference (word highlight) |

### Visual Mode

| Key | Description |
|-----|-------------|
| `<` / `>` | Indent (stays in visual mode) |
| `J` / `K` | Move text up/down |
| `p` | Paste without overwriting register |

## Directory Structure

```
init.lua                    # Entry point
lua/
  config/
    options.lua             # Neovim options (vim.opt)
    keymaps.lua             # Global key mappings
    autocmds.lua            # Autocommands (filetype detection)
    lazy.lua                # Plugin manager bootstrap
  plugins/
    blink-completion.lua    # Completions (blink.cmp)
    gitsigns-git.lua        # Git hunks and blame
    lsp-config.lua          # LSP + Mason
    snacks-utils.lua        # All-in-one utilities (picker, notify, etc.)
    tokyonight-theme.lua    # Theme + statusline
    treesitter-syntax.lua   # Syntax highlighting
    whichkey-keys.lua       # Keybinding hints
```

## Validation

After installation, run these commands inside Neovim:

```vim
:checkhealth              " Run health checks
:Lazy                     " Open plugin manager
:Mason                    " Open LSP server manager
:LspInfo                  " Check LSP status
```

## Snacks.nvim Features

This configuration uses [snacks.nvim](https://github.com/folke/snacks.nvim) as a unified utility layer, replacing multiple plugins:

| Snacks Feature | Replaces |
|----------------|----------|
| `picker` | telescope.nvim |
| `notifier` | nvim-notify |
| `progress` | fidget.nvim |
| `indent` | indent-blankline.nvim |
| `input` | dressing.nvim |
| `dashboard` | alpha-nvim / dashboard-nvim |
| `bufdelete` | bufdelete.nvim |
| `lazygit` | lazygit.nvim |
| `terminal` | toggleterm.nvim |
| `gitbrowse` | git-browse.nvim |

## License

MIT
