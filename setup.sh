echo "=== installing brew ==="
if [[ "$(which brew)" =~ "not found" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "=== installing oh-my-zsh ==="
if [[ "$(which omz)" =~ "not found" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo
brew update

# install cli tools
echo
echo "=== installing cli tools ==="
function install_cli() {
  echo "installing $1"
  if [[ "$(which $1)" =~ "not found" ]]; then
    if [[ -z "$2" ]]; then
      pkg=$1
    else
      pkg=$2
    fi
    brew install $pkg
  fi
}
install_cli wget
install_cli fzf
install_cli rg
install_cli fd
install_cli jq
install_cli tmux
install_cli tpm
install_cli nvim neovim
install_cli asdf
install_cli duti
install_cli mas

echo
echo "=== installing gui apps ==="
function install_app() {
  echo "installing $2"
  if [[ -e "/Applications/$1.app" ]]; then
    :
  else
    brew install --cask $2
  fi
}

install_app "iTerm" iterm2
install_app "1Password" 1password
install_app "Rectangle" rectangle
install_app "Brave Browser" brave-browser
install_app "Google Chrome" google-chrome
install_app "Visual Studio Code" visual-studio-code
install_app "Microsoft Teams" microsoft-teams
install_app "Google Drive" google-drive

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
  echo "127.0.0.1	localhost,www.camp.local.citypassdev.com,de.camp.local.citypassdev.com,es.camp.local.citypassdev.com,fr.camp.local.citypassdev.com,it.camp.local.citypassdev.com,ja.camp.local.citypassdev.com,pt.camp.local.citypassdev.com,zh.camp.local.citypassdev.com,dev.mycitypassdev.com" | sudo tee -a /etc/hosts
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
install_app "Slack" slack
install_app "GIMP" gimp
mas install 497799835 # xcode

# install_app "Android Studio" android-studio
