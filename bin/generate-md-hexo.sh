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

## Rsync the asy build dir to the md build dir in order to obtain a monolitic/independent
## md directory structure.
rsync -au "${BUILD_ASY_DIR}" "${BUILD_MD_HEXO_DIR}" || exit 1

XSL_DIR="${ROOT_PROJECT_DIR}asset/xsl/md/hexo/"

function cleanMDFile() {
    sed -i 's/geometry_dev/geometry/g;s/{/\&lbrace;/g;s/}/\&rbrace;/g;s/h4>/h5>/g;s/h3>/h4>/g;s/h2>/h3>/g;s/h1>/h2>/g;' "$1" || exit 1
}

for topic in $_TOPICS; do
    # for topic in animations; do
    echo "==> Handling topic '$topic'..."

    SRC_DIR=$(get-src-dir "$topic")
    TARGET_BUILD_XML_DIR="${BUILD_XML_DIR}${topic}/"

    cd "$TARGET_BUILD_XML_DIR" || exit 1
    printf "\tProcessing %s/index.xml\n" "$(pwd)"
    md_file="${BUILD_MD_HEXO_DIR}${topic}/index.md"

    xsltproc --xincludestyle "${XSL_DIR}topics.xsl" \
        index.xml >"$md_file" || exit 1

    cleanMDFile "$md_file"
done

# XML_INDEX_PATH="${BUILD_XML_DIR}index.xml"
# echo "==> Handling $XML_INDEX_PATH to generate top level index.md"
# xsltproc --xincludestyle "${XSL_DIR}index.xsl" \
#     "$XML_INDEX_PATH" >"${BUILD_MD_HEXO_DIR}index.md" || exit 1

# while IFS= read -r CAT; do
#     label=$(
#         echo "$CAT" | awk -F '|' '{print $3}' |
#             awk -F '|' '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}2'
#     )
#     id=$(echo "$CAT" | awk -F '|' '{print $2}')

#     CAT_FILE_NAME="category-${id}.md"
#     echo "==> Handling $XML_INDEX_PATH to generate category file $CAT_FILE_NAME"
#     xsltproc --stringparam label "$label" --stringparam id "$id" \
#         --xincludestyle "${XSL_DIR}category.xsl" \
#         "$XML_INDEX_PATH" >"${BUILD_MD_HEXO_DIR}${CAT_FILE_NAME}" || exit 1

# done <"${SOURCE_DIR}categories.txt"

# while IFS= read -r TAG; do
#     label=$(
#         echo "$TAG" | awk -F '|' '{print $3}' |
#             awk -F '|' '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}2'
#     )
#     id=$(echo "$TAG" | awk -F '|' '{print $2}')

#     TAG_FILE_NAME="tag-${id}.md"
#     echo "==> Handling $XML_INDEX_PATH to generate tag file $TAG_FILE_NAME"
#     xsltproc --stringparam label "$label" --stringparam id "$id" \
#         --xincludestyle "${XSL_DIR}tag.xsl" \
#         "$XML_INDEX_PATH" >"${BUILD_MD_HEXO_DIR}${TAG_FILE_NAME}" || exit 1

# done <"${SOURCE_DIR}tags.txt"
