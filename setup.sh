# helpers
function has_no() {
  if [[ "$(which $1)" =~ "not found" ]]; then
    return 1
  else
    return 0
  fi
}

function brew_install() {
  echo "installing $1"
  if [[ "$(which $1)" =~ "not found" ]]; then
    pkg=$2
    if [[ -z "$pkg" ]]; then
      pkg=$1
    fi
    brew install $pkg
  fi
}

function brew_install_gui() {
  echo "installing $2"
  if [[ -e "/Applications/$1.app" ]]; then
    :
  else
    brew install --cask $2
  fi
}

echo "=== installing brew ==="
if $(has_no brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "=== installing oh-my-zsh ==="
if $(has_no omz); then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "=== updating brew ==="
brew update

echo
echo "=== installing cli tools ==="
brew_install wget
brew_install fzf
brew_install rg
brew_install fd
brew_install jq
brew_install tmux
brew_install tpm
brew_install nvim neovim
brew_install asdf
brew_install duti
brew_install mas

echo
echo "=== installing gui apps ==="
brew_install_gui "iTerm" iterm2
brew_install_gui "1Password" 1password
brew_install_gui "Rectangle" rectangle
brew_install_gui "Brave Browser" brave-browser
brew_install_gui "Google Chrome" google-chrome
brew_install_gui "Visual Studio Code" visual-studio-code
brew_install_gui "Microsoft Teams" microsoft-teams
brew_install_gui "Google Drive" google-drive

echo
echo "=== installing nodejs ==="
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf install nodejs 18.18.2
asdf reshim nodejs

if [[ "$(which yarn)" =~ "not found" ]]; then
  npm install -g yarn pm2
fi

echo
echo "=== installing ssh key ==="
if [[ -e "$HOME/.ssh/id_ed25519" ]]; then
  :
else
  ssh-keygen -t ed25519 -C "miles.dickson@gmail.com"
fi

echo
echo "=== symlinking dotfiles ==="
DOTFILES_DIR=$(pwd)

for file in $(ls -A "$DOTFILES_DIR" | grep "^\.[^.]" | grep -v ".git$"); do
  if [[ -f "$HOME/$file" || -L "$HOME/$file" ]]; then
    # echo "backing up existing $file to $file.bak"
    #mv "$HOME/$file" "$HOME/$file.bak"
    echo "WARN: already exists $file"
  fi
  ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
  echo "symlinked $file -> $DOTFILES_DIR/$file"
done

source $HOME/.zprofile
tmux source $HOME/.tmux.conf

echo
echo "=== setting app defaults ==="
duti -s com.brave.Browser http all
duti -s com.microsoft.VSCode public.plain-text all
duti -s com.microsoft.VSCode public.source-code all
duti -s com.microsoft.VSCode public.shell-script all

echo
echo "=== updating hosts file ==="
if [[ -z "$(grep citypassdev /etc/hosts)" ]]; then
  echo "127.0.0.1	localhost,www.local.camp.citypassdev.com,de.local.camp.citypassdev.com,es.local.camp.citypassdev.com,fr.local.camp.citypassdev.com,it.local.camp.citypassdev.com,ja.local.camp.citypassdev.com,pt.local.camp.citypassdev.com,zh.local.camp.citypassdev.com,dev.mycitypassdev.com" | sudo tee -a /etc/hosts
fi

echo
echo "=== installing xcode command line tools ==="
if ! xcode-select -p &>/dev/null; then
  xcode-select --install

  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

echo
echo "=== installing additional apps (long) ==="
brew_install_gui "Slack" slack
brew_install_gui "GIMP" gimp
mas install 497799835 # xcode

# brew_install_gui "Android Studio" android-studio
