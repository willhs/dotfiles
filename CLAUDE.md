# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository based on Holman's dotfiles architecture. It manages system configuration through a topic-centric structure where each directory represents a different area of configuration (git, zsh, ruby, etc.).

## Key Commands

### Initial Setup
- `script/bootstrap` - Symlinks all `*.symlink` files to `$HOME`, sets up git config
- `script/install` - Runs all `topic/install.sh` scripts for additional setup
- `bin/set-defaults` - Applies macOS system defaults via `macos/set-defaults.sh`

### Development
- All scripts in `bin/` are available globally in `$PATH`
- `git-*` utilities in `bin/` provide enhanced git workflows
- Homebrew packages defined in `Brewfile` at root level

## Architecture

### File Conventions
- `topic/*.zsh` - Auto-loaded into zsh environment
- `topic/path.zsh` - Loaded first to setup `$PATH` 
- `topic/completion.zsh` - Loaded last for autocomplete setup
- `topic/*.symlink` - Symlinked to `$HOME/.filename` (without .symlink extension)
- `topic/install.sh` - Executed during `script/install` runs

### Topic Areas
- `zsh/` - Shell configuration and zshrc
- `git/` - Git configuration and custom commands  
- `macos/` - macOS-specific settings and software updates
- `homebrew/` - Package management setup
- `bin/` - Custom scripts and utilities available in `$PATH`
- `system/` - System-level aliases and environment setup
- `nvim/` - Neovim configuration
- `i3/` - i3 window manager configuration

### Key Files
- `zsh/zshrc.symlink` - Main shell configuration entry point
- `Brewfile` - Homebrew packages and casks to install
- `macos/set-defaults.sh` - System preferences automation
- Environment variables stored in `~/.localrc` (not tracked in git)

### Loading Order
1. `*/path.zsh` files (PATH setup)
2. All other `*.zsh` files except completion
3. `*/completion.zsh` files (after autocomplete initialization)

## Important Notes
- `$DOTFILES` points to the dotfiles directory (`~/dotfiles` by default)
- `$PROJECTS` points to `~/projects` for project navigation
- Private environment variables should go in `~/.localrc`
- The bootstrap script handles interactive setup for git configuration
- macOS-specific installations handled through Homebrew and App Store updates