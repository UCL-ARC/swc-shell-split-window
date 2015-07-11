#!/bin/bash
#
# Create terminal for Software Carpentry lesson
# with the log of the commands at the top.

# Where we'll store the executed history.  Defaults to /tmp/log-file,
# but you can override from the calling process.  For example:
#
#   LOG_FILE=/tmp/my-log ./swc-shell-split-window.sh
LOG_FILE="${LOG_FILE:-/tmp/log-file}"

# If $LOG_FILE exists, truncate it, otherwise create it.
# Either way, this leaves us with an empty $LOG_FILE for tailing.
> "${LOG_FILE}"

# Create the session to be used
# * don't attach yet (-d)
# * name it 'swc' (-s swc)
# * start reading the log
tmux new-session -d -s swc "tail -f '${LOG_FILE}'"

# Split the window vertically (-v)
# * make the new pane the current pane (no -d)
# * load history from the empty $LOG_FILE (HISTFILE='${LOG_FILE}')
# * append new history to $HISTFILE after each command
#   (PROMPT_COMMAND='history -a')
# * launch Bash since POSIX doesn't specify shell history or HISTFILE
#   (bash)
tmux split-window -v "HISTFILE='${LOG_FILE}' PROMPT_COMMAND='history -a' bash"

tmux send-keys -t 1 "cd" enter
# Unset alias
tmux send-keys -t 1 "unalias grep" enter
tmux send-keys -t 1 "unalias ls" enter
tmux send-keys -t 1 "unalias sort" enter
# Set nice prompt displaying
# with cyan
# the command number and
# the '$'.
tmux send-keys -t 1 "export PS1=\"\[\033[1;36m\]\! $\[\033[0m\] \"" enter
for i in $(seq 5)
do
    tmux send-keys -t 1 "clear" enter
done
# Resize the log window to show the last five commands
# Need to use the number of lines desired + 1
tmux resize-pane -t 0 -y 6

tmux attach-session
