#!/usr/bin/env bash

# Called after a git push

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$THIS_DIR"
./build.sh && ./deploy.sh
