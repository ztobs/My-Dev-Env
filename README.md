## My Development Environment Setup

The following are configured:

- zsh
  - Oh My Zsh
    - p10k theme
- Tmux
  - TPM (Tmux Plugin Manager)
  - vim-tmux-navigator
  - tmux-tokyo-night theme
  - tmux-resurrect & tmux-continuum
- NeoVim
  - **LSP & Completion:** Mason, nvim-lspconfig, nvim-cmp
  - **Debugging:** nvim-dap, nvim-dap-ui, mason-nvim-dap
  - **Formatting & Linting:** conform.nvim, nvim-lint
  - **Syntax:** nvim-treesitter, nvim-ts-autotag, nvim-treesitter-textobjects
  - **File Navigation:** telescope.nvim, nvim-tree, flash.nvim
  - **Git Integration:** lazygit, neogit, gitsigns, trouble.nvim
  - **UI/UX:** lualine, bufferline, alpha (dashboard), which-key, dressing.nvim
  - **Editing:** vim-surround, nvim-autopairs, substitute, yanky, undotree
  - **Session:** auto-session, vim-maximizer
  - **Extras:** todo-comments, indent-blankline, AI integration, docker support
  - **Theme:** tokyo-night colorscheme
  - **Vue Support:** Volar (vue_ls) + vtsls for Vue 3 + TypeScript

## Install Prerequisites

```bash
sudo apt update
sudo apt install zsh curl git -y
```

## Instal Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Set Zsh as Default Shell (if not done automatically)

```bash
chsh -s $(which zsh)
```

## Install Nerd Font (Meslo)

```bash
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

getnf -i Meslo
```

##### GNOME Terminal (Default Ubuntu Terminal)

1. Open Preferences → Profile → Text
2. Check "Custom font"
3. Select **"MesloLGS NF"** from the dropdown

##### Update VSCode Terminal Font (Optional)

Open settings.json and add this line:

```
"terminal.integrated.fontFamily": "MesloLGS NF"
```

## Install Zsh Plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Open the ”~/.zshrc” file in your desired editor and modify the plugins line to what you see below.

```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
```

```bash
source ~/.zshrc
```

## Install PowerLevel10K Theme for Oh My Zsh

Run this to install PowerLevel10K:

```bash
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

Now that it’s installed, open the ”~/.zshrc” file with your preferred editor and change the value of “ZSH_THEME” as shown below:

```
ZSH_THEME="powerlevel10k/powerlevel10k"
```

To reflect this change on your terminal, restart it or run this command:

```bash
source ~/.zshrc
```

## Configure PowerLevel10K

Restart iTerm2. You should now be seeing the PowerLevel10K configuration process. If you don’t, run the following:

```bash
p10k configure
```

Follow the instructions for the PowerLevel10K configuration to make your terminal look as desired.

## Install Tmux Plugin Manager (TPM) & Plugins

First, install TPM if not already installed:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then reload tmux config:

```bash
tmux source ~/.tmux.conf
```

Install plugins either via command line:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Or inside a tmux session: press `Ctrl+a` then `I` (capital i)

## PHP Development Tools

### For Debugging (Xdebug)

```bash
sudo apt install php-xdebug
```

Configure Xdebug in `/etc/php/<version>/fpm/conf.d/20-xdebug.ini`:

```ini
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
xdebug.client_host=localhost
```

### For Code Formatting

Install via Mason in nvim (recommended):

```vim
:MasonInstall phpcbf
```

Or install on host system:

```bash
sudo apt install php-codesniffer
```

## Shared Shell Configuration

Create `~/.myrc` for shared custom settings, aliases, and environment variables that will be sourced by both `.zshrc` and `.bashrc`:

```bash
touch ~/.myrc
```

Add your shared configurations to this file

---

## NeoVim Telescope Configuration

### File Pattern Filtering in Live Grep

When using Telescope's `live_grep` (`<leader>fs`), you can dynamically filter results by file pattern:

1. Open live grep: `<leader>fs`
2. Press `<Ctrl+g>` while in the picker
3. Enter a glob pattern (e.g., `*.php`, `**/*.vue`, `*.{js,ts}`)
4. The search will refresh and only show results from matching files

**Common Pattern Examples:**
- `*.php` - All PHP files in current directory
- `**/*.vue` - All Vue files recursively
- `*.{js,ts}` - All JavaScript and TypeScript files
- `src/**/*.lua` - All Lua files under src directory

**Configuration:** `~/.config/nvim/lua/donztobs/plugins/telescope.lua`

---

## NeoVim Obsidian Notes Configuration

### Quick Note-Taking with obsidian.nvim

Obsidian.nvim integrates markdown note-taking directly into Neovim, storing notes in `~/.obsidian/neovim/`.

**Keybindings:**
- `<leader>Nn` - Create a new note (supports paths like `folder/note`)
- `<leader>Ns` - Search content in all notes (live grep)
- `<leader>Nq` - Quick switch/find notes by filename
- `<leader>No` - Open notes directory picker
- `<leader>Nt` - Open today's daily note
- `<leader>Ny` - Open yesterday's daily note
- `<leader>Nb` - Show backlinks to current note
- `<leader>Nl` - Show all links in current note
- `<leader>Nf` - Follow link under cursor

**Creating Notes with Subdirectories:**
When creating a new note, you can include a path to organize notes into folders:
- `test` → Creates `~/.obsidian/neovim/TIMESTAMP-test.md`
- `work/meeting` → Creates `~/.obsidian/neovim/work/TIMESTAMP-meeting.md`
- `projects/ideas/new` → Creates `~/.obsidian/neovim/projects/ideas/TIMESTAMP-new.md`

**Markdown Features:**
- Wiki-style links: `[[Note Name]]`
- Checkboxes with icons (toggle with `<leader>ch`)
- Smart Enter key (follow links or toggle checkboxes)
- `gf` to follow wiki/markdown links
- Auto-completion with nvim-cmp integration

**Configuration:** `~/.config/nvim/lua/donztobs/plugins/obsidian.lua`

---

## NeoVim LSP Configuration

### Supported Languages & LSP Servers

| Language | LSP Server | Features |
|----------|-----------|----------|
| **Vue** | `vue_ls` (Volar) + `vtsls` | Go-to-definition, type checking, auto-completion in `.vue` files |
| **TypeScript/JavaScript** | `vtsls` | Full TypeScript support, works with Vue |
| **PHP** | `intelephense` | WordPress-aware PHP development with WordPress stubs |
| **HTML/CSS** | `html`, `cssls` | HTML and CSS support |
| **Tailwind CSS** | `tailwindcss` | Tailwind class completion |
| **Lua** | `lua_ls` | Neovim config development |
| **Python** | `pyright` | Python type checking |

### Vue.js Development Setup

**Configuration Date:** February 24, 2026

Vue LSP uses **Volar 3.0+ (Hybrid Mode)** which requires both:
- `vtsls` - TypeScript server with Vue plugin support
- `vue_ls` - Vue Language Server (Volar)

#### Key Configuration Files:
- `~/.config/nvim/lua/donztobs/plugins/lsp/mason.lua` - LSP server installation
- `~/.config/nvim/lua/donztobs/plugins/lsp/lsp.lua` - LSP server configuration  
- `~/.config/nvim/lua/donztobs/plugins/treesitter.lua` - Vue syntax highlighting
- `~/.config/nvim/lua/donztobs/plugins/formatting.lua` - Vue file formatting

#### What's Configured:

1. **vtsls with Vue TypeScript Plugin**
   - Handles TypeScript in Vue files
   - Global plugin configuration for `@vue/typescript-plugin`
   - Auto-attaches to `.vue`, `.ts`, `.js` files

2. **vue_ls (Volar)**
   - Vue-specific language features
   - Component intellisense
   - Template type checking
   - Forwards TypeScript requests to vtsls

3. **Vue Treesitter Parser**
   - Syntax highlighting for `<template>`, `<script>`, `<style>`
   - Code folding and indentation

4. **Prettier Formatting**
   - Auto-formats `.vue` files
   - Configured with 4-space tabs

### LSP Keybindings

Works for all LSP-enabled files (PHP, JS/TS, Vue):

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gR` | Show references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Formatting Keybindings

| Key | Action |
|-----|--------|
| `<leader>mp` | Format file/selection |
| `<leader>mt` | Toggle format on save |

**Note:** Format on save is OFF by default. Enable with `<leader>mt`.

### Verifying Vue LSP

When you open a `.vue` file:

1. Run `:LspInfo` in Neovim
2. You should see both:
   - `vtsls` (TypeScript server)
   - `vue_ls` (Vue language server)

3. Test features:
   - Hover over a component name - press `K`
   - Go to definition - press `gd` on a prop or function
   - Auto-complete - start typing and wait for suggestions

### Troubleshooting Vue LSP

#### Error: "Could not find vtsls or ts_ls"

**Solution:**
1. Completely close all Neovim instances
2. Reopen Neovim
3. Open a `.vue` file
4. Check `:LspInfo` - both servers should attach

#### Reinstalling LSP Servers

```vim
:Mason          " Open Mason
" Use 'i' to install, 'u' to update, 'X' to uninstall
```

Required packages:
- `vtsls`
- `vue-language-server`
- `prettier`

#### Check Health

```vim
:checkhealth mason
:checkhealth lsp
```

### Manual LSP Installation

If Mason doesn't auto-install:

```bash
# Install globally with npm (alternative)
npm install -g @vue/language-server vtsls typescript
```

Then restart Neovim.
