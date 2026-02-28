#!/usr/bin/env bash

# rollback.sh for blog service
# Reverts the index.html and posts symlinks to the second latest version in the data directory.

echo "------------------------------------------------"
echo #
echo "Rolling back blog web service script started"
echo #

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA_DIR="$THIS_DIR/data"
HTML_DIR="$THIS_DIR/html"

if [ ! -d "$DATA_DIR" ]; then
    echo "ERROR: No data directory found for blog service."
    echo "------------------------------------------------"
    exit 1
fi

# Get the second latest entry (the one before the current one)
PREVIOUS_VERSION=$(ls -1 "$DATA_DIR" | sort -r | sed -n '2p')

if [ -z "$PREVIOUS_VERSION" ]; then
    echo "ERROR: No previous version found to roll back to for blog service."
    echo "------------------------------------------------"
    exit 1
fi

echo "Rolling back blog service to version: $PREVIOUS_VERSION..."

# Update index symlink
cd "$HTML_DIR"
ln -s -f "../data/$PREVIOUS_VERSION/index.html" "index.html"

# Update posts symlink
rm -f "posts"
ln -s -f "../data/$PREVIOUS_VERSION/posts" "posts"

echo "Rollback for blog service complete."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "------------------------------------------------"
echo #
echo "Rolling back blog web service script finished"
echo #
exit 0
