#!/bin/bash
#
# Create terminal for Software Carpentry lesson
# with the log of the commands at the top.

# Where we'll store the executed history.  Defaults to /tmp/log-file,
# but you can override from the calling process.  For example:
#
#   LOG_FILE=/tmp/my-log ./swc-shell-split-window.sh
LOG_FILE="${LOG_FILE:-/tmp/log-file}"

# The number of lines of history to show.  Defaults to 5, but you can
# override from the calling process.
HISTORY_LINES="${HISTORY_LINES:-5}"

# Session name.  Defaults to 'swc', but you can override from the
# calling process.
SESSION="${SESSION:-swc}"

# If $LOG_FILE exists, truncate it, otherwise create it.
# Either way, this leaves us with an empty $LOG_FILE for tailing.
> "${LOG_FILE}"

# Create the session to be used
# * don't attach yet (-d)
# * name it $SESSION (-s "${SESSION}")
# * start reading the log
tmux new-session -d -s "${SESSION}" "tail -f '${LOG_FILE}'"

# Get the unique (and permanent) ID for the new window
WINDOW=$(tmux list-windows -F '#{window_id}' -t "${SESSION}")

# Get the unique (and permanent) ID for the log pane
LOG_PANE=$(tmux list-panes -F '#{pane_id}' -t "${WINDOW}")

# Split the log-pane (-t "${LOG_PANE}") vertically (-v)
# * make the new pane the current pane (no -d)
# * load history from the empty $LOG_FILE (HISTFILE='${LOG_FILE}')
# * append new history to $HISTFILE after each command
#   (PROMPT_COMMAND='history -a')
# * launch Bash since POSIX doesn't specify shell history or HISTFILE
#   (bash)
tmux split-window -v -t "${LOG_PANE}" \
	"HISTFILE='${LOG_FILE}' PROMPT_COMMAND='history -a' bash"

# Get the unique (and permanent) ID for the shell pane
SHELL_PANE=$(tmux list-panes -F '#{pane_id}' -t "${WINDOW}" |
	grep -v "^${LOG_PANE}\$")

tmux send-keys -t "${SHELL_PANE}" "cd" enter

# Unset all aliases to keep your environment from diverging from the
# learner's environment.
tmux send-keys -t "${SHELL_PANE}" "unalias -a" enter

# Set nice prompt displaying
# with cyan
# the command number and
# the '$'.
tmux send-keys -t "${SHELL_PANE}" "export PS1=\"\[\033[1;36m\]\! $\[\033[0m\] \"" enter

# Clear the history so it starts over at number 1.
# The script shouldn't run any more non-shell commands in the shell
# pane after this.
tmux send-keys -t "${SHELL_PANE}" "history -c" enter

# Send Bash the clear-screen command (see clear-screen in bash(1))
tmux send-keys -t "${SHELL_PANE}" "C-l"

# Need add an additional line because Bash writes a trailing newline
# to the log file after each command, tail reads through that trailing
# newline and flushes everything it read to its pane.
LOG_PANE_HEIGHT=$((${HISTORY_LINES} + 1))

# Resize the log window to show the desired number of lines
tmux resize-pane -t "${LOG_PANE}" -y "${LOG_PANE_HEIGHT}"

tmux attach-session -t "${SESSION}"
