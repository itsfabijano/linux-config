#!/bin/bash

ZSH_PLUGINS=(
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is not installed. Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# --- APT package install ---
PKG_DIR="./packages"

# Loop over all files in the directory
for file in "$PKG_DIR"/*; do
    echo "Processing $file..."
    while IFS= read -r pkg; do
        # Skip empty lines and comments
        [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

        # Check if package is installed
        if dpkg -s "$pkg" &>/dev/null; then
            echo "  $pkg is already installed"
        else
            echo "  Installing $pkg..."
            sudo apt-get install -y "$pkg"
        fi
    done < "$file"
done

# --- Zsh plugins ---
ZSH_PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

echo "Checking Zsh plugins..."
for repo in "${ZSH_PLUGINS[@]}"; do
    plugin_name=$(basename "$repo" .git)
    target="$ZSH_PLUGIN_DIR/$plugin_name"

    if [[ -d "$target" ]]; then
        echo "  $plugin_name already installed"
    else
        echo "  Installing $plugin_name..."
        git clone "$repo" "$target"
    fi
done

git submodule update --init --recursive
git submodule update --remote --recursive

stow -R -v -t ~ -d ./home .
