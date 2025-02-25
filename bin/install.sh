#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PARENT_DIR=$(cd -- "${SCRIPT_DIR}/.." &>/dev/null && pwd)

cd "$PARENT_DIR" || exit 1
git submodule update --init || exit 1
"$SCRIPT_DIR/mkdirs.sh" || exit 1
