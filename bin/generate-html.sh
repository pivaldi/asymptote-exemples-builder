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
. "$(dirname "$0")/shared.rc" || exit 1

# The OPTIONAL topic to handle.
# If missing, all the topics will be traited.
_TOPICS="$1"

[ "$_TOPICS" = "" ] && _TOPICS=$TOPICS

## Rsync the source of statics html files to the htlm build dir
rsync -au "${ASSET_DIR}html/" "${BUILD_HTML_DIR}" || exit 1
## Rsync the asy build dir to the html build dir in order to obtain a monolitic/independent
## html directory structure.
rsync -au "${BUILD_ASY_DIR}" "${BUILD_HTML_DIR}" || exit 1

for topic in $_TOPICS; do
    # for topic in animations; do
    echo "==> Handling topic '$topic'..."

    SRC_DIR=$(get-src-dir "$topic")
    ASSET_DIR="${BUILD_ASY_DIR}${topic}/"
    TARGET_BUILD_XML_DIR="${BUILD_XML_DIR}${topic}/"
    TARGET_BUILD_HTML_DIR="${BUILD_HTML_DIR}${topic}/"
    # TMP_DIR="${TMP_PROJECT_DIR}${topic}/"

    cd "$TARGET_BUILD_XML_DIR" || exit 1
    printf "\tProcessing %s/index.xml\n" "$(pwd)"
    xsltproc --xincludestyle "${ROOT_PROJECT_DIR}asset/xsl/html/topics.xsl" \
        index.xml >"${TARGET_BUILD_HTML_DIR}index.html" || exit 1
done

XML_INDEX_PATH="${BUILD_XML_DIR}index.xml"
echo "==> Handling $XML_INDEX_PATH to generate top level index.html"
xsltproc --xincludestyle "${ROOT_PROJECT_DIR}asset/xsl/html/index.xsl" \
    "$XML_INDEX_PATH" >"${BUILD_HTML_DIR}index.html" || exit 1
