#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. "$SCRIPT_DIR/shared.rc" || exit 1
PARENT_DIR=$(cd -- "${SCRIPT_DIR}/.." &>/dev/null && pwd)

cd "$PARENT_DIR" || exit 1
git submodule update --init || exit 1
sync-src-dir-to-tmp-dir
