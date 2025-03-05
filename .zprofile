eval "$(/opt/homebrew/bin/brew shellenv)"

###########################
# PATHS
###########################
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export ANDROID_SDK="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/emulator"



###########################
# OPTIONS & GLOBALS
###########################
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export _JAVA_OPTIONS="-Xmx2g"



###########################
# ALIASES
###########################
alias vi='nvim'
alias plugins='cd ~/.config/nvim && nvim .'
alias profile='vi ~/.profile'
alias src-profile='source ~/.profile'

alias gits='git status'
alias gitl='git log'
alias gitb='git branch'
alias gitr='git reset HEAD . && git checkout . && git clean -fd .'
alias gitw="git for-each-ref --sort=-committerdate refs/heads/ --count 20 --format='[%(color:green)%(committerdate:relative)%(color:reset)] %(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(color:red)%(objectname:short)%(color:reset)) %(contents:subject) - %(authorname)'"

alias ssh-dev='ssh miles@camp.citypassdev.com'
alias ssh-prod='ssh citypass@app.citypass.com'
alias ssh-ocular='ssh -t root@ocular.citypass.com "cd /var/log/servers; bash"'
alias ssh-staging='ssh staging@camp.citypassdev.com'
alias ssh-dan='ssh dan@camp.citypassdev.com'
alias ssh-alicia='ssh alicia@camp.citypassdev.com'

alias restartCamera='sudo killall VDCAssistant'
alias code=code-insiders



###########################
# INIT
###########################
for key in {id_rsa,id_ed25519}; do
  if [[ -s ~/.ssh/$key ]]; then
    if [[ -z "$(ssh-add -l | grep -i $key)" ]]; then
      ssh-add --apple-use-keychain ~/.ssh/$key
    fi
  fi
done



###########################
# UTILITIES
###########################
function sshcamp() {
  ssh $1@camp.citypassdev.com
}

function gitbd() {
  git push origin --delete $1
  git branch -D $1
}

function gitbu() {
  branch=$(git branch --show-current)
  git branch --set-upstream-to=origin/$branch $branch
}

function firewall() {
  firewall_urls="https://visit.citypass.com/firewall https://camp.citypassdev.com/fire/wall https://visit.endpoint.com/firewall"

  curl -I -u miles:lmbr-20-yrd https://visit.citypass.com/firewall | grep -Eo "HTTP/(2|1.1) 200"
  curl -I -u miles:birnorArdig https://camp.citypassdev.com/firewall | grep -Eo "HTTP/(2|1.1) 200"
}

function deploybranch() {
  if [[ -z "$2" || -z "$1" ]]; then 
    echo "must provide branch and camp"
    return
  fi
  echo "deploying $1 to $2"
  ssh-dev "source ~/.bash_profile && cd $2 && git reset HEAD . && git checkout . && git clean -fd && git fetch && git checkout $1 && git pull && re --ic && re --httpd"
}

function ipgeolookup() {
  cat $1 | while read ip_address; do curl -s https://freegeoip.app/json/$ip_address | jq '[.ip, .country_name]'; done
}

function gitslog() {
  git shortlog -sne --no-merges --since="$1" -- $2
}

function gitloga() {
  git log --stat --no-merges --since="$1" --author="$2" -- $3
}

function gitshortlogsummary() {
  for dir in "*.tst" "catalogs/**/*.pm interchange/**/*.pm"; do
  #for dir in bin build build/js-build/checkout build/js-build/**/*.test.js catalogs config content feeds generator hoover htdocs httpd includes interchange migrations notes ops tests tests/e2e tests/visual tests/smoke website wildfire "*.test.js *.test.ts *.test.tsx __tests__ *.t *Test.php"; do
    echo
    echo
    echo
    echo "--- SUMMARIZING $dir ---"
    echo
    echo "Commits:"
    git shortlog -sne --no-merges --since="$1" --before="$2" -- $dir

    for author in chris@citypass.com miles@citypass.com john@citypass.com; do
      echo
      echo "Commit stats for $author:"
      git log --shortstat --no-merges --author="$author" --since="$1" --before="$2" -- $dir | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' - || echo "No changes"
   done
   echo
  done

  echo "Repo Summary"
  git shortlog -sne --no-merges --since="$1" --before="$2"

  
  for author in chris@citypass.com miles@citypass.com john@citypass.com christy@citypass andrew@citypass; do
    echo
    echo "Commit stats for $author:"
    git log --shortstat --no-merges --author="$author" --since="$1" --before="$2" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' - || echo "No changes"
  done
  echo
}
