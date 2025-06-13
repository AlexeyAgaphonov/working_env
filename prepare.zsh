#!/bin/zsh

set -e 

echo "🚀 Starting macOS Development Environment Setup..."

if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed."
    echo "📋 To install Homebrew, run the following command:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed."
    echo "📋 To install Git, run the following command:"
    echo "brew install git"
    exit 1
fi

P_CONFIG="$HOME/.config"
P_PLUGINS="$P_CONFIG/tmux/plugins"
P_CAT="${P_PLUGINS}/catppuccin/tmux"
P_TMUX="${P_PLUGINS}/tmux-plugins"
P_CPU="${P_TMUX}/tmux-cpu"
P_BAT="${P_TMUX}/tmux-battery"

echo "📁 Adjusting tmux"
mkdir -p $P_PLUGINS
mkdir -p $P_CAT
[ ! -d $P_CAT/.git ] && git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $P_CAT
mkdir -p ~/.config/tmux/plugins/tmux-plugins/
[ ! -d $P_CPU/.git ] && git clone https://github.com/tmux-plugins/tmux-cpu $P_CPU
[ ! -d $P_BAT/.git ] && git clone https://github.com/tmux-plugins/tmux-battery $P_BAT
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)
cp .tmux.conf ~/.tmux.conf

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

P_NVIM="${P_CONFIG}/nvim"

if [ -d $P_NVIM ]; then
    echo "⚠️  ~/.config/nvim already exists. Creating backup..."
    mv $P_NVIM $P_NVIM.backup.$(date +%Y%m%d_%H%M%S)
fi


[ ! -d $P_NVIM/.git ] && git clone git@github.com:AlexeyAgaphonov/my_nvim.git $P_NVIM

if [ $? -eq 0 ]; then
    echo "✅ Neovim configuration cloned successfully"
else
    echo "❌ Failed to clone nvim configuration. Please check:"
    echo "   - Your SSH key is set up with GitHub"
    echo "   - You have access to the repository"
    echo "   - Your internet connection is working"
    exit 1
fi



P_ZSHRC="$HOME/.zshrc"
echo "🔄 Update .zshrc"
if grep -q "# __BEGIN_ZINIT__" $P_ZSHRC && grep -q "# __END_ZINIT__" $P_ZSHRC; then
    echo "🔄 Found existing zinit configuration, removing it..."
    # Use sed to remove everything between the markers (inclusive)
    sed -i '' '/# __BEGIN_ZINIT__/,/# __END_ZINIT__/d' ~/.zshrc
    echo "✅ Removed existing zinit configuration"
fi

ZINIT_CONFIG="zinit_settings.zsh"
cat "$ZINIT_CONFIG" >> "$P_ZSHRC"

