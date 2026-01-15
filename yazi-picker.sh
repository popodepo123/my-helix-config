#!/usr/bin/env bash

# The first argument ($1) will be the Helix command (e.g., 'open', 'vsplit', 'hsplit')
# The second argument ($2) will now be the directory of the current buffer, passed from Helix.
# Determine the starting directory for Yazi
# If a valid directory is provided as $2, use it. Otherwise, default to the current working directory.

DIR_TO_CHECK=$(dirname "$2")
if [[ -n "$DIR_TO_CHECK" && -d "$DIR_TO_CHECK" ]]; then
    START_DIR="$DIR_TO_CHECK"
else
    # Fallback to the current working directory if $2 was empty or invalid
    START_DIR="."
fi
# Run yazi, starting in the determined directory ($START_DIR)
# The --chooser-file=/dev/stdout flag tells yazi to output selected paths to stdout.
paths=$(yazi "$START_DIR" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

# Check if any paths were selected in yazi
if [[ -n "$paths" ]]; then
	# If paths were selected, toggle floating panes (likely to open one)
	zellij action toggle-floating-panes
	# Send the Escape key to the pane (e.g., to exit insert mode in a text editor)
	zellij action write 27 # send <Escape> key
	# Write the Helix command (from $1) followed by the selected paths to the pane
	zellij action write-chars ":$1 $paths"
	# Send the Enter key to execute the written command
	zellij action write 13 # send <Enter> key
else
	# If no paths were selected, just toggle floating panes (likely to close one)
	zellij action toggle-floating-panes
fi

