#!/bin/bash
#
# Create terminal for Software Carpentry lesson
# with the log of the commands at the top.

LOG_FILE=/tmp/log-file

# Create the session to be used
# * don't attach yet (-d)
# * name it 'swc' (-s swc)
# * launch Bash since this hack only works with it
tmux new-session -d -s swc bash

# Split the window vertically (-v)
tmux split-window -v

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
# Hack to write the log after every command
tmux send-keys -t 1 "export PROMPT_COMMAND=\"history 1 >> ${LOG_FILE}\"" enter
for i in $(seq 5)
do
    tmux send-keys -t 1 "clear" enter
done
# Resize the log window to show the last five commands
# Need to use the number of lines desired + 1
tmux resize-pane -t 0 -y 6
# Remove old file and create a empty one
rm -f ${LOG_FILE}
touch ${LOG_FILE}
# Starting read the log
tmux send-keys -t 0 "tail -n 3 -f ${LOG_FILE}" enter

tmux attach-session
