# ZSH Fast Install

This script installs and configures Oh My Zsh along with useful plugins:

- **Oh My Zsh** — A popular framework for managing Zsh.
- **zsh-syntax-highlighting** — Highlights commands for better readability.
- **zsh-autosuggestions** — Suggests commands based on history.
- **zsh-z** — Quickly jumps to directories you’ve visited.
- **fast-syntax-highlighting** — Speeds up syntax highlighting.
- **zsh-autocomplete** — Offers real-time auto-completion.
- **fzf** — Adds fast, fuzzy file searching to your shell.
- **evalcache** — Caches command evaluations to improve shell performance.

## Installation Steps

1. Run `omz-install.sh`.
2. If the script warns a package is missing, install it manually and re-run.
3. Restart your shell or run `source ~/.zshrc` to apply changes.

## Choosing a Theme

After plugins are installed, the script will list available themes from `~/.oh-my-zsh/themes`. Enter a theme name (without the “.zsh-theme” extension) or press Enter to keep the default theme.

## Uninstallation Steps

1. Run `omz-install.sh` again.
2. When prompted, confirm you want to uninstall.
3. This removes Oh My Zsh, restores `/bin/bash` as your default shell, and optionally backs up your `.zshrc`.

Enjoy your customized Zsh environment!
