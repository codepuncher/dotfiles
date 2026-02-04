# dotfiles

Personal dotfiles for Ubuntu, Arch, and macOS systems with comprehensive shell configuration, terminal setup, and development tools.

## ✨ Features

### Shell Configuration
- **ZSH** with modern plugin management via [Zinit](https://github.com/zdharma-continuum/zinit)
- **Spaceship Prompt** - beautiful, minimal, and powerful prompt
- **Smart Completions** - enhanced shell completions with [zsh-completions](https://github.com/zsh-users/zsh-completions)
- **Syntax Highlighting** - real-time command syntax highlighting via [fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
- **Auto-suggestions** - fish-like autosuggestions with [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- **History Substring Search** - intelligent history search with [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- **Oh My Zsh Plugins** - npm and composer plugin integration
- **Custom Aliases** - extensive Git, Docker, npm, and system aliases
- **Custom Functions** - utility functions for package management and development workflows
- **Environment Variables** - secure `.env` support via `.shell_env.example`
- **Extensible** - load custom aliases from `~/.aliases` directory

### Terminal Emulators
- **Alacritty** - GPU-accelerated terminal with TokyoNight theme and JetBrains Mono font
- **Ghostty** - modern terminal emulator configuration
- **iTerm2** - shell integration for macOS

### Tmux
- **Configuration** - optimized tmux setup with custom keybindings
- **Plugin Manager** - automatic [TPM](https://github.com/tmux-plugins/tpm) installation
- **Custom Layouts** - pre-configured workspace layouts
- **Automatic Renaming** - smart window naming with custom script

### Neovim
- **Modern Config** - Neovim configuration (v0.8+)
- **Stylua** - Lua code formatter configuration included

### Git
- **Configuration** - optimized Git settings
- **Delta Integration** - better diff viewing with [git-delta](https://github.com/dandavison/delta)
- **Aliases** - comprehensive Git workflow shortcuts

### Development Tools
- **NVM** - Node Version Manager for Node.js
- **Go** - Go language support and tools
- **Rust** - Rustup and Cargo package management
- **Composer** - PHP dependency manager
- **Valet Linux** - Laravel Valet for Linux development environment
- **GitHub CLI** - GitHub command-line tool integration
- **GitHub Copilot CLI** - AI-powered command-line assistance
- **Trellis CLI** - virtualenv integration for WordPress development

### Media & System
- **Spotifyd** - lightweight Spotify daemon configuration
- **Font Configuration** - custom fontconfig settings
- **Ngrok** - secure tunneling configuration

### Custom Utilities (bin/)
- `alacritty-bg-toggle` - Toggle Alacritty background
- `countdown-days` - Countdown timer utility
- `fix-valet-dns` - Fix Laravel Valet DNS issues
- `logs` - Enhanced log viewing
- `mix-output-to-input` - Audio routing helper
- `mpris-currently-playing` - Display current media playback
- `tmux_automatic_rename_format` - Tmux window renaming
- `update_proton_ge` - Update Proton GE for gaming

## 📋 Requirements

### Essential
- **ZSH** (required)
  - macOS: `brew install zsh && chsh -s $(which zsh)`
  - Ubuntu: `sudo apt install zsh && chsh -s $(which zsh)`
  - Arch: `sudo pacman -S zsh && chsh -s $(which zsh)`
- **Git** (required)
  - macOS: `brew install git`
  - Ubuntu: `sudo apt install git`
  - Arch: `sudo pacman -S git`

### Optional
- **Neovim** v0.8+ (for nvim configuration)
  - macOS: `brew install neovim` or `brew install --HEAD luajit neovim`
  - Ubuntu: `sudo apt install neovim`
  - Arch: `sudo pacman -S neovim`
- **Tmux** (for terminal multiplexing)
- **Alacritty** or **Ghostty** (for terminal emulator config)

## 🚀 Installation

### Quick Start
```bash
# Clone the repository
git clone git@github.com:codepuncher/dotfiles.git ~/.dotfiles

# Run the setup script
~/.dotfiles/setup.sh
```

### Setup Process
The setup script will prompt you to:

1. **Install Packages** (optional) - Install system packages and dependencies
   - Arch/Manjaro: Installs dev tools, terminals, media apps, and more
   - WSL: Installs WSL-specific packages
   - Sets up system services on Arch

2. **Install Tools** (optional) - Install development tools
   - Zinit (ZSH plugin manager)
   - TPM (Tmux Plugin Manager)
   - NVM and Node.js packages (language servers, formatters, linters)
   - Composer (PHP dependency manager + Valet Linux)

3. **Symlink Dotfiles** (recommended) - Creates symlinks for:
   - Shell configs (`.zshrc`, `.bashrc`, `.profile`)
   - Shell variables and aliases
   - Tmux configuration
   - Neovim configuration
   - Git configuration
   - Terminal emulator configs (Alacritty, Ghostty)
   - Media configs (Spotifyd)
   - Font configuration
   - Web tools (Ngrok)

   **Note:** Existing files are automatically backed up to `~/.dotfiles/backups/`

4. **Initialize Directories** - Creates standard workspace structure:
   - `~/Code/misc`
   - `~/Code/go`
   - `~/Code/wordpress`
   - `~/Tools`

5. **Shell Change** - Automatically switches your shell to ZSH if needed

After completion, the script will launch ZSH with your new configuration.

## 🔧 Configuration

### Environment Variables
Copy `.shell_env.example` to `~/.env` and add your secrets:
```bash
cp ~/.dotfiles/.shell_env.example ~/.env
```

### Custom Aliases
Add your own aliases by creating files in `~/.aliases/`:
```bash
mkdir -p ~/.aliases
echo "alias myalias='my command'" > ~/.aliases/custom
```

### Tmux Plugins
After first tmux launch, install plugins with: `prefix + I` (default: `Ctrl+b` then `Shift+i`)

## 📦 What Gets Installed

### Arch/Manjaro Packages
- **General**: Redshift, Ulauncher, Variety, Bitwarden, Plank, Spotify, Pandoc, LaTeX
- **Social**: Discord, Caprine, WhatsApp
- **Work**: Microsoft Edge, ClickUp, Zoom
- **Dev**: Alacritty, Ghostty, Tmux, GitHub CLI, Go, Rust

### WSL Packages
- **Database**: MariaDB Server
- **PHP**: Multi-version PHP support (8.1 and 8.2) with common extensions
  - bcmath, bz2, cli, common, curl, fpm, gd, gmp, intl, mbstring, mysql, opcache, readline, soap, tidy, xdebug, xml, xsl, zip
- **Tools**: wslu (WSL utilities for interoperability)

### Package Managers & Tools
- **Node.js** (via NVM)
- **Language Servers**: GitHub Copilot, Devsense PHP LS, Intelephense, Ansible, TailwindCSS, Vue, Bash
- **Go packages** (development tools)
- **Composer packages** (PHP tools + Valet Linux)
- **Pip packages** (Python tools)
- **Cargo packages** (Rust tools)

## 🗂️ Repository Structure
```
~/.dotfiles/
├── ansible/          # Automation playbooks
├── backups/          # Backed up configs
├── bin/              # Custom utility scripts
├── fontconfig/       # Font configuration
├── git/              # Git configuration
├── media/            # Media player configs (Spotifyd)
├── nvim/             # Neovim configuration
├── shell/            # Shell configs, aliases, functions
├── templates/        # Configuration templates
├── terminals/        # Terminal emulator configs
├── tmux/             # Tmux configuration
├── web/              # Web tool configs (Ngrok)
└── setup.sh          # Main setup script
```

## 🔄 Updating

To reinstall/update dotfiles:
```bash
cd ~/.dotfiles && git pull && ./setup.sh
```

Or use the built-in function:
```bash
reinstall_dotfiles
```

## 🤝 Platform Support

- ✅ **Arch Linux** / Manjaro (full support with package installation)
- ✅ **Ubuntu** / Debian (full support)
- ✅ **WSL** (Windows Subsystem for Linux)
- ✅ **macOS** (shell and tool configs, package installation not automated)

## 📝 License

Personal dotfiles - use at your own discretion.
