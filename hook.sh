#!/usr/bin/env bash
set -e

echo "------------------------------------------------"
echo #
echo "Blog web service hook script started"
echo #

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$THIS_DIR"

if ./build.sh; then
        ./deploy.sh
        cd "$THIS_DIR/.."
        ./cleanup_data.sh
else
        echo "ERROR: Building failed; not deploying."
        echo "------------------------------------------------"
        exit 1
fi

echo "Blog web service hook script finished"
echo "------------------------------------------------"
exit 0
