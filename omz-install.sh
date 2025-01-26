#!/bin/bash

install_package() {
    local pkg=$1
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "$pkg is not installed. Please install it manually, then re-run this script."
    else
        echo "$pkg is already installed."
    fi
}
echo "Checking required packages..."
install_package zsh
install_package curl
install_package git

# Installing Oh-My-Zsh
ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH_DIR" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh-My-Zsh is already installed."
fi

# Define plugin installation directory
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# Plugins to install
declare -A plugins=(
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-z"]="https://github.com/agkozak/zsh-z"
    ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    ["fzf"]="https://github.com/junegunn/fzf.git"
)

# Install plugins
echo "Installing plugins..."
for plugin in "${!plugins[@]}"; do
    PLUGIN_DIR="$ZSH_CUSTOM/$plugin"
    if [ -d "$PLUGIN_DIR" ]; then
        echo "Plugin '$plugin' already installed."
    else
        echo "Installing plugin '$plugin'..."
        if [ "$plugin" == "fzf" ]; then
            git clone --depth 1 "${plugins[$plugin]}" ~/.fzf
            ~/.fzf/install --key-bindings --completion --no-update-rc
        else
            git clone "${plugins[$plugin]}" "$PLUGIN_DIR"
        fi
    fi
done

choose_theme() {
    local themes_dir="$HOME/.oh-my-zsh/themes"
    if [ -d "$themes_dir" ]; then
        echo "Available themes:"
        ls "$themes_dir" | sed 's/\.zsh-theme$//'
        read -r -p "Enter the theme name (without .zsh-theme): " theme_choice
        if [ -n "$theme_choice" ]; then
            if grep -q '^ZSH_THEME=' "$ZSHRC"; then
                sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$theme_choice\"/" "$ZSHRC"
            else
                echo "ZSH_THEME=\"$theme_choice\"" >> "$ZSHRC"
            fi
        else
            echo "No theme selected. Using default."
        fi
    else
        echo "No themes directory found. Skipping theme selection."
    fi
}

# Update ~/.zshrc without duplicates
echo "Configuring ~/.zshrc..."
ZSHRC="$HOME/.zshrc"
choose_theme

{
    # Update theme
    if grep -q '^ZSH_THEME=' "$ZSHRC"; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="gnzh"/' "$ZSHRC"
    else
        echo 'ZSH_THEME="gnzh"' >>"$ZSHRC"
    fi

    # Update plugins
    if grep -q '^plugins=' "$ZSHRC"; then
        sed -i 's/^plugins=.*/plugins=(fzf git sudo history-substring-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete zsh-z)/' "$ZSHRC"
    else
        echo 'plugins=(fzf git sudo history-substring-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete zsh-z)' >>"$ZSHRC"
    fi

    # Add custom aliases
    grep -q "alias ll='ls -lA'" "$ZSHRC" || echo "alias ll='ls -lA'" >>"$ZSHRC"
    grep -q "alias gs='git status'" "$ZSHRC" || echo "alias gs='git status'" >>"$ZSHRC"
    grep -q "alias gd='git diff'" "$ZSHRC" || echo "alias gd='git diff'" >>"$ZSHRC"
    grep -q "alias ga='git add'" "$ZSHRC" || echo "alias ga='git add'" >>"$ZSHRC"
    grep -q "alias gc='git commit'" "$ZSHRC" || echo "alias gc='git commit'" >>"$ZSHRC"
    grep -q "alias gp='git push'" "$ZSHRC" || echo "alias gp='git push'" >>"$ZSHRC"
    grep -q "alias c=clear" "$ZSHRC" || echo "alias c=clear" >>"$ZSHRC"
} >>"$ZSHRC"

# Apply changes
echo "Applying configuration..."
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Switching default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "Zsh is already the default shell."
fi

uninstall_all() {
    echo "Uninstalling Oh My Zsh and reverting to default shell..."
    # Revert to default shell (/bin/bash)
    chsh -s /bin/bash
    # Remove Oh My Zsh directory
    rm -rf "$ZSH_DIR"
    # (Optional) Backup and remove .zshrc
    if [ -f "$ZSHRC" ]; then
        mv "$ZSHRC" "$ZSHRC.bak"
        echo "Backed up $ZSHRC to $ZSHRC.bak"
    fi
    echo "Uninstall complete. Please open a new terminal or log out and back in."
}

read -r -p "Do you want to uninstall everything (Oh My Zsh, plugins) and revert shell to bash? [y/N]: " uninstall_choice
if [[ "$uninstall_choice" =~ ^[Yy]$ ]]; then
    uninstall_all
    exit 0
fi

echo "ZSH installation and configuration complete. Restart your shell or run 'source ~/.zshrc' to apply changes."
