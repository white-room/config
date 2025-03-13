#!/bin/zsh

create_session() {
  session_name=$1
  layout=$2
  dir=$3
  first_command=$4

  tmux new-session -d -s "$session_name" -n main

  # Run an initial command in the first pane
  tmux send-keys -t "$session_name:main.0" "cd $dir" C-m
  if [[ -n "$first_command" ]]; then
    tmux send-keys -t "$session_name:main.0" "$first_command" C-m
  fi

  # Split into panes
  if [[ $layout == "editor" ]]; then
    tmux split-window -c $dir -h -t "$session_name:main"
    tmux split-window -c $dir -v -t "$session_name:main.1"
    tmux select-layout -t "$session_name:main" main-vertical
    tmux select-pane -t "$session_name:main.0"
    echo editor
  elif [[ $layout == "single" ]]; then
    # do nothing
    echo singling
  fi
}

create_session config editor ~/.config "nvim ."
create_session citypass editor ~/workspaces/citypass "nvim ."
create_session MyCityPASS editor ~/workspaces/MyCityPASS "nvim ."
create_session camps single ~
create_session git single ~ "gh dash"

tmux attach-session -t citypass
