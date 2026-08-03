# Neovim Configuration for Backend/GitOps Development

A modern Neovim configuration focused on **backend development** and **GitOps workflows**.
Built for Neovim 0.12+ with Vimpack (`vim.pack`) as the plugin manager.

## Features

| Feature | Implementation |
|---------|----------------|
| **Completions** | blink.cmp (LSP, snippets, buffer, path sources) |
| **Fuzzy Finder** | Snacks picker (files, grep, buffers, LSP symbols) |
| **LSP** | Built-in `vim.lsp.config` / `vim.lsp.enable` APIs |
| **UI Enhancements** | noice.nvim (cmdline, messages, LSP docs) |
| **Notifications** | Snacks notifier (popup notifications + history) |
| **Git Integration** | Gitsigns (hunks, blame) + Snacks lazygit |
| **UI Components** | Snacks (dashboard, indent guides, input, statuscolumn) |
| **Theme** | OneDarkPro + Lualine statusline with clock |
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

## Requirements

### Required

| Dependency | Description | Installation |
|------------|-------------|--------------|
| **Neovim 0.12+** | Required for Vimpack, new LSP APIs, and Treesitter APIs | [neovim.io](https://neovim.io) |
| **Git** | Plugin management and git features | Pre-installed on most systems |
| **Nerd Font** | Icons throughout the UI | [nerdfonts.com](https://www.nerdfonts.com/) |
| **ripgrep** | Fast grep for file searching | `brew install ripgrep` |
| **tree-sitter CLI** | Required by nvim-treesitter | `brew install tree-sitter` |

### Optional (Recommended)

| Dependency | Description | Installation |
|------------|-------------|--------------|
| **lazygit** | Terminal UI for git (used by `<leader>gg`) | `brew install lazygit` |
| **fd** | Faster file finding | `brew install fd` |
| **fzf** | Fuzzy finder backend | `brew install fzf` |

### Language-Specific (for LSP)

Language servers are expected to be installed outside Neovim and available on `$PATH`:

| Language | Executable | Homebrew package |
|----------|------------|------------------|
| **Go** | `go`, `gopls` | `go`, `gopls` |
| **Python** | `pyright-langserver` | `pyright` |
| **Rust** | `rust-analyzer` | `rust-analyzer` |
| **Terraform** | `terraform-ls` | `terraform-ls` |
| **Terraform linting** | `tflint` | `terraform-linters/tap/tflint` |
| **YAML** | `yaml-language-server` | `yaml-language-server` |
| **Dockerfile** | `docker-langserver` | `dockerfile-language-server` |
| **Docker Compose** | `docker-compose-langserver` | `docker-compose-langserver` |
| **Shell** | `bash-language-server` | `bash-language-server` |
| **Helm** | `helm_ls` | `helm-ls` |
| **JSON** | `vscode-json-language-server` | `vscode-langservers-extracted` |
| **Lua** | `lua-language-server` | `lua-language-server` |

### Quick Install (macOS)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all dependencies
brew install neovim ripgrep tree-sitter fd fzf lazygit

# Install language servers used by this config
brew install go gopls pyright rust-analyzer terraform-ls yaml-language-server \
  dockerfile-language-server docker-compose-langserver bash-language-server \
  helm-ls lua-language-server vscode-langservers-extracted

# Optional Terraform linting LSP
brew tap terraform-linters/tap
brew install terraform-linters/tap/tflint

# Install a Nerd Font (e.g., JetBrains Mono)
brew install --cask font-jetbrains-mono-nerd-font
```

### Quick Install (Ubuntu/Debian)

```bash
# Neovim 0.12+ (use AppImage or build from source)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Install dependencies
sudo apt install git ripgrep fd-find

# tree-sitter CLI
cargo install tree-sitter-cli
# OR
npm install -g tree-sitter-cli

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

## Installation

### Option 1: Clone directly (recommended for most users)

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone the repository
git clone https://github.com/yourusername/neovim-setup.git ~/.config/nvim

# Launch Neovim - plugins will bootstrap automatically
nvim
```

### Option 2: Symlink (recommended for development)

If you want to keep the repo in a separate location (e.g., for easier version control or development):

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone to your preferred location
git clone https://github.com/e-sigs/neovim-setup.git ~/dev/neovim-setup

# Create symlink to Neovim config directory
ln -s ~/dev/neovim-setup ~/.config/nvim

# Launch Neovim
nvim
```

On first launch:
1. Vimpack will auto-install all plugins listed in `lua/config/vimpack.lua`
2. Treesitter will auto-install language parsers
3. LSP servers will start when their executables are available on `$PATH`

Run `:checkhealth` to verify everything is working.

## Keybindings

**Leader key: `Space`**

### General

| Key | Description |
|-----|-------------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<C-w>` | Close buffer |
| `<leader>l` | Plugin status |
| `<leader>pu` | Update plugins |
| `<leader>ps` | Plugin status |
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
| `<leader>tc` | Toggle time format (12/24hr) |
| `<leader>td` | Toggle diagnostics |
| `<leader>ts` | Toggle spelling |
| `<leader>tw` | Toggle wrap |
| `<leader>tl` | Toggle line numbers |
| `<leader>tL` | Toggle relative numbers |
| `<leader>tT` | Toggle treesitter |
| `<leader>th` | Toggle inlay hints |

### Notifications (`<leader>n`)

| Key | Description |
|-----|-------------|
| `<leader>nl` | Show last message (noice) |
| `<leader>nh` | Notification history (snacks popup) |
| `<leader>nn` | All messages (noice split) |
| `<leader>nd` | Dismiss all notifications |

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
    vimpack.lua             # Vimpack plugin management and setup
  plugins/
    coding/
      blink-completion.lua  # Completions (blink.cmp)
      minipairs-autopairs.lua # Auto-close pairs
      treesitter-syntax.lua # Syntax highlighting
    editor/
      surround-edit.lua     # Surround text objects
    git/
      gitsigns-git.lua      # Git hunks and blame
    lsp/
      nvim-lspconfig-servers.lua # LSP configuration
    tools/
      opencode-ai.lua       # OpenCode AI integration
    ui/
      lualine-statusline.lua # Statusline with clock
      noice-notifications.lua # Cmdline, messages UI
      onedarkpro-theme.lua  # Theme
      snacks-utils.lua      # Utilities (picker, notifier, dashboard, etc.)
      whichkey-keys.lua     # Keybinding hints
```

## Validation

After installation, run these commands inside Neovim:

```vim
:checkhealth              " Run health checks
:checkhealth noice        " Check noice.nvim specifically
:PackStatus               " Show Vimpack plugin status
:PackUpdate               " Update Vimpack plugins
:LspInfo                  " Check LSP status
```

## Plugin Architecture

### Vimpack

Plugin sources live in `lua/config/vimpack.lua`.
Locked plugin revisions live in `nvim-pack-lock.json`.
Use `:PackStatus` to inspect installed plugins and `:PackUpdate` to update them.

### Noice.nvim Features

[noice.nvim](https://github.com/folke/noice.nvim) provides enhanced UI:

| Feature | Description |
|---------|-------------|
| `cmdline` | Fancy popup for `:` commands with syntax highlighting |
| `messages` | Better message display, replaces `:messages` |
| `lsp.progress` | LSP progress indicator |
| `lsp.hover` | Enhanced hover docs with borders |
| `lsp.signature` | Enhanced signature help |
| `search` | Search count as virtual text |

### Snacks.nvim Features

[snacks.nvim](https://github.com/folke/snacks.nvim) provides utilities:

| Feature | Replaces |
|---------|----------|
| `picker` | telescope.nvim |
| `notifier` | nvim-notify |
| `indent` | indent-blankline.nvim |
| `input` | dressing.nvim |
| `dashboard` | alpha-nvim / dashboard-nvim |
| `bufdelete` | bufdelete.nvim |
| `lazygit` | lazygit.nvim |
| `terminal` | toggleterm.nvim |
| `gitbrowse` | git-browse.nvim |
| `words` | vim-illuminate |
| `statuscolumn` | statuscol.nvim |

### Time Format Toggle

The statusline clock and notification timestamps support toggling between 12-hour and 24-hour format:

- Press `<leader>tc` to toggle time format
- Default is 12-hour format (e.g., "02:30 PM")
- Toggle syncs across: Lualine clock, Noice messages, Snacks notifications

## License

MIT
