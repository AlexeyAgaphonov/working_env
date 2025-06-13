#!/bin/zsh

set -e 

echo "🚀 Starting macOS Development Environment Setup..."

if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed."
    echo "📋 To install Homebrew, run the following command:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi
echo "✅ Homebrew is available"

if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed."
    echo "📋 To install Git, run the following command:"
    echo "brew install git"
    exit 1
fi
echo "✅ Git is available"

echo "📁 Adjusting tmux"
mkdir -p ~/.config/tmux/plugins
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
mkdir -p ~/.config/tmux/plugins/tmux-plugins/
git clone https://github.com/tmux-plugins/tmux-cpu ~/.config/tmux/plugins/tmux-plugins/tmux-cpu
git clone https://github.com/tmux-plugins/tmux-battery ~/.config/tmux/plugins/tmux-plugins/tmux-battery
echo "✅ Finished adjusting tmux"



echo "🍺 Installing packages from Homebrew..."

packages=("fzf" "neovim" "tmux")
for package in "${packages[@]}"; do
    echo "📦 Installing $package..."
    brew install "$package"
    echo "✅ $package installed successfully"
done

packages_cask=("ghostty")
for package in "${packages_cask[@]}"; do
    echo "📦 Installing $package..."
    brew install --cask "$package"
    echo "✅ $package installed successfully"
done
echo "⚙️  Setting up Neovim configuration..."

if [ -d ~/.config/nvim ]; then
    echo "⚠️  ~/.config/nvim already exists. Creating backup..."
    mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
fi

echo "📥 Cloning nvim configuration..."
git clone git@github.com:AlexeyAgaphonov/my_nvim.git ~/.config/nvim

if [ $? -eq 0 ]; then
    echo "✅ Neovim configuration cloned successfully"
else
    echo "❌ Failed to clone nvim configuration. Please check:"
    echo "   - Your SSH key is set up with GitHub"
    echo "   - You have access to the repository"
    echo "   - Your internet connection is working"
    exit 1
fi

echo "🎉 Setup completed successfully!"
echo ""
echo "📋 What was installed/configured:"
echo "   • Ghostty terminal emulator"
echo "   • fzf (fuzzy finder)"
echo "   • Neovim with custom configuration"
echo "   • tmux terminal multiplexer"
echo "   • Directory structure: ~/.config/tmux/plugins"
echo ""
echo "🔄 You may want to restart your terminal or run 'source ~/.zshrc' to refresh your environment."

