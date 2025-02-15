#!/bin/bash

# Copyright (C) 2006
# Author: Philippe IVALDI
#
# This program is free software ; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation ; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY ; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program ; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Load shared code
. $(dirname $0)/shared.rc || exit 1

# The topic to handle
_TOPICS="$1"

[ "$_TOPICS" = "" ] && _TOPICS=$TOPICS

for topic in $_TOPICS; do
    echo "==> Handling topic '$topic'..."

    SRC_DIR="$(get-src-dir $topic)"
    ASSET_DIR="${ASSET_ASY_DIR}${topic}/"
    TARGET_XML_OUT_DIR="${XML_OUT_DIR}${topic}/"
    TARGET_HTML_OUT_DIR="${HTML_OUT_DIR}${topic}/"
    TMP_DIR="${TMP_PROJECT_DIR}${topic}/"

    cd "$TARGET_XML_OUT_DIR" || exit 1
    printf "\tProcessing %s/index.xml\n" "$(pwd)"
    xsltproc --xincludestyle "${ROOT_PROJECT_DIR}asset/xsl/asycode2html.xsl" index.xml >"${TARGET_HTML_OUT_DIR}index.html" || exit 1
done
