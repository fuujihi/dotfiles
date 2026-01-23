# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository containing a comprehensive development environment configuration focused on Neovim, Fish shell, and Tmux. The setup emphasizes modern tooling with OneDark theme consistency across all applications.

## Key Configuration Components

### Neovim Configuration (.config/nvim)
- **Plugin Manager**: Uses lazy.nvim (migrated from packer.nvim)
- **Structure**: Modular Lua configuration split into base, maps, highlight, and plugins
- **Key Bindings**:
  - `;f` (file search), `;g` (text search), `\\` (buffer search) via Telescope
  - `;t` (file tree toggle), `;;` (terminal toggle)
  - `te/tw` (tab create/close), `sw/sv` (window split), `sh/sk/sj/sl` (window navigation)
- **LSP**: Managed via mason.nvim with lspsaga for enhanced UI
- **Theme**: OneDark with priority loading
- **Special Features**: GitHub Copilot integration, automatic input method switching (vim-im-select)

### Fish Shell Configuration (.config/fish)
- **Theme**: bobthefish with onedark color scheme
- **Key Functions**: `g` (repo search with ghq+fzf), `gd`/`gswitch` (git branch switching), JIRA integration functions
- **Environment**: Configured for Go, Python, Perl, Google Cloud, Android development
- **Plugins**: z (directory jumping), fzf.fish (fuzzy finding)

### Tmux Configuration (.tmux.conf)
- **Prefix Key**: Changed to Ctrl-q (from default Ctrl-b)
- **Session Management**: Auto-save/restore via tmux-resurrect and tmux-continuum (1-minute intervals)
- **Theme**: Custom OneDark theme (fuujihi/tmux-onedark-theme#hinata branch)
- **Features**: Mouse support, 256 colors, custom pane navigation

### Other Tools
- **Git**: Uses git-split-diffs for pager, configured for LFS and ghq
- **Peco**: Fuzzy finder with Ctrl+j/k navigation
- **iTerm2**: Full configuration stored in plist format

## Common Development Commands

### Neovim Plugin Management
```bash
# Plugins are managed automatically via lazy.nvim
# Configuration changes in lua/plugins/init.lua will trigger updates on next nvim start
```

### Tmux Session Management
```bash
# Start/attach to session
tmux

# Kill all sessions (alias: tk)
tmux kill-server

# Reload configuration (within tmux: Prefix + r)
tmux source ~/.tmux.conf
```

### Git Workflow (with custom aliases)
```bash
# Status check (alias: gs)
git status

# Branch management (alias: gb)
git branch

# Quick commit (alias: gc)
git commit -m "message"

# Repository navigation with ghq
g  # Opens fzf interface for repository selection
```

## Architecture Patterns

### Performance Optimization
- Lazy loading strategy for Neovim plugins to minimize startup time
- Lua module caching enabled in init.lua
- Syntax highlighting limited to first 200 columns for performance

### Theme Consistency
- OneDark theme implementation across Neovim, Fish, Tmux, and terminal
- Custom color schemes maintained for each tool while preserving visual unity

### Development Workflow Integration
- ghq for centralized repository management under ~/go/src and ~/git/
- FZF integration across shell, Neovim (Telescope), and file navigation
- JIRA API integration for ticket management
- GitHub Copilot for AI assistance

### Configuration Management
- XDG Base Directory compliance (.config/ structure)
- Modular Neovim configuration with clear separation of concerns
- Version-controlled plugin lockfiles excluded from git (.gitignore includes lazy-lock.json)

## Important Notes

### Neovim Plugin System
- Uses lazy.nvim with specific loading strategies for each plugin
- Plugin configurations are in lua/plugins/init.lua with detailed lazy-loading specs
- Mason.nvim manages LSP servers, DAP adapters, and linters automatically

### Environment Dependencies
- Requires modern terminal with true color support
- Go environment expected for ghq and various development tools
- Python via asdf version management
- Node.js for various LSP servers and tools

### Custom Modifications
- Uses forked tmux-onedark-theme on "hinata" branch for customizations
- vim-im-select plugin for automatic input method switching (macOS specific)
- Custom Fish functions for workflow optimization

### Backup and Migration
- Old configurations preserved in .config/nvim.old/ (packer-based setup)
- Configuration changes should maintain lazy.nvim structure
- Tmux sessions automatically restored on system restart via continuum plugin