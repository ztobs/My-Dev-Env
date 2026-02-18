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

## Install Tmux Plugins

After cloning this repo, install tmux plugins:

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
