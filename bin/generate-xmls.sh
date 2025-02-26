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

# The topic to handle
_TOPICS="$1"

[ "$_TOPICS" = "" ] && _TOPICS=$TOPICS

# Some regexp used to modify the HTML generated.
IMPORTc="\(<span class=\"builtin\">import<\/span>\) *Lsystem"
IMPORTd="\(<span class=\"builtin\">import<\/span>\) *carteApoints"

# The lsystem.asy file is sometimes necessary to compile examples.
# Lsystem; is replaced by a link to download it.
COMC="s!${IMPORTc}!\1 <a href=\"https://github.com/pivaldi/asymptote-packages\">Lsystem</a>!g"
COMD="s!${IMPORTd}!\1 <a href=\https://github.com/pivaldi/asymptote-packages\">carteApoints</a>!g"

for topic in $_TOPICS; do
  echo "==> Handling topic '$topic'…"

  SRC_DIR=$(get-src-dir "$topic")
  ASSET_DIR="${ASSET_ASY_DIR}${topic}/"
  TARGET_XML_OUT_DIR="${XML_OUT_DIR}${topic}/"
  TMP_DIR="${TMP_PROJECT_DIR}${topic}/"

  # *====================================
  # *..Building xml part of categories..*
  # *====================================
  CATS="<categories>"
  catFile="${SRC_DIR}category.txt"
  [ -e "$catFile" ] && {
    while IFS= read -r CAT; do
      CATS="${CATS}\n<category>${CAT}</category>"
    done <"${catFile}"
  }

  CATS="${CATS}\n</categories>"
  # *==============================

  # -----------------------------
  # * L'index de tous les codes *
  cat >"${TARGET_XML_OUT_DIR}index.xml" <<EOF
<?xml version="1.0" ?>
<asy-code title="$(cat "${SRC_DIR}title.txt")" date="$(LANG=US date)">
<presentation>$(cat "${SRC_DIR}presentation.html")</presentation>
$(echo -e "$CATS")
EOF

  # ---------------
  # * Les figures *
  cat >"${TARGET_XML_OUT_DIR}figures.xml" <<EOF
<?xml version="1.0" ?>
<asy-figures title="Pic - $(cat "${SRC_DIR}title.txt")" date="$(LANG=US date)" resource="${RES}">
<presentation>$(cat "${SRC_DIR}presentation.html")</presentation>
$(echo -e "$CATS")
EOF

  numfig=1001

  for fic in $(get_asy_files "$SRC_DIR"); do
    printf "\t=> Processing asy file %s…\n" "${fic}"

    ficssext=${fic%.*}
    ficssext=$(basename "$ficssext")
    htmlizedFile="${TMP_DIR}${ficssext}.asy.html"
    fullssext="${SRC_DIR}${ficssext}"

    # le tag ADDPDF permet de mettre un lien vers le fichier .pdf
    COMB="s%ADDPDF%<a href=\"###DIRNAME###${ficssext}.pdf\">${ASSET_DIR}${ficssext}.pdf<\/a>%g"

    # *=========================================*
    # *..Creating .html files from .asy files...*
    # *=========================================*
    if [ "${fic}" -nt "${htmlizedFile}" ]; then
      printf "\t\t-Htmlizing %s…\n" "${fic}"
      # emacsclient -q -e '(htmlize-file "'${fic}'" "'$htmlizedFile'")' > /dev/null
      LANG="fr_FR.UTF-8" $PYGMENTYZE_CMD -f html -O "inencoding=utf-8,outencoding=utf-8,bg=light" -o "$htmlizedFile" "${fic}" || exit 1
      echo "  => $htmlizedFile"

      # Modifying the html
      sed -i -e "$COMB;$COMC;$COMD" "$htmlizedFile" || exit 1
    fi
    #################################################

    # *==============================
    # *..Building xml part of tags..*
    # *==============================
    TAGS="<tags>"
    tagFile="${fullssext}.tag"
    [ -e "$tagFile" ] && {
      while IFS= read -r TAG; do
        ltag=$(
          echo "$TAG" | awk -F '|' '{print $3}' |
            awk -F '|' '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}2' |
            tr ' /' '__'
        )

        idtag=$(echo "$TAG" | awk -F '|' '{print $2}')
        TAGS="${TAGS}\n<tag id=\"${idtag}\">${ltag}</tag>"
      done <"${tagFile}"
    }

    TAGS="${TAGS}\n</tags>"
    # *==============================

    ## Creating unique key for code anchor
    [ ! -e "${fullssext}.id" ] && {
      md5sum "$fic" | cut -f1 -d" " >"${fullssext}.id"
    }

    ## The post id (useful for CMS).
    POSTID=$(cat "${fullssext}.id")

    echo >"${ROOT_PROJECT_DIR}/buildinfo-missing.txt"
    [ -e "${fullssext}.buildinfo" ] || {
      echo "${fullssext}.buildinfo" >>"${ROOT_PROJECT_DIR}/buildinfo-missing.txt"
    }

    CODE_ATTRS="id=\"$(cat "${fullssext}.id")\" number=\"${numfig#1}\""
    CODE_ATTRS="${CODE_ATTRS} filename=\"${ficssext}\" $(cat "${fullssext}.buildinfo") postid=\"${POSTID}\""
    # ---------------------
    # * code de la figure *
    cat >"${TARGET_XML_OUT_DIR}${ficssext}.xml" <<EOF
<?xml version="1.0" ?>
<asy-code title="$(cat "${SRC_DIR}title.txt")" date="$(LANG=US date)">
<presentation>$(iconv -f utf8 <"${SRC_DIR}presentation.html")</presentation>
$(echo -e "$CATS")
EOF

    {
      echo "<code $CODE_ATTRS>"
      echo -e "$TAGS"
      echo "<text-md>"
      [ -e "${fullssext}.md" ] && cat "${fullssext}.md"
      echo "</text-md>"
      echo "<text-html>"
      [ -e "${fullssext}.md" ] && markdown "${fullssext}.md"
      echo "</text-html>"
      echo '<pre>'
      inner-tag "$htmlizedFile" 'pre'
      echo '</pre>'
      echo '</code>'
    } | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >>"${TARGET_XML_OUT_DIR}index.xml"

    cat >>"${TARGET_XML_OUT_DIR}${ficssext}.xml" <<EOF
</asy-code>
EOF

    cat >>"${TARGET_XML_OUT_DIR}figures.xml" <<EOF
<figure $CODE_ATTRS/>
EOF

    numfig=$((numfig + 1))
  done

  cat >>"${TARGET_XML_OUT_DIR}index.xml" <<EOF
</asy-code>
EOF

  cat >>"${TARGET_XML_OUT_DIR}figures.xml" <<EOF
</asy-figures>
EOF

done
