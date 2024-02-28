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

# Quelques expressions rationnelles utilisees pour modifier le html genere.
IMPORTc="\(<span class=\"builtin\">import<\/span>\) *Lsystem"
IMPORTd="\(<span class=\"builtin\">import<\/span>\) *carteApoints"
IMPORTe="\(<span class=\"builtin\">import<\/span>\) *spring"

# Le fichier Lsystem.asy est parfois necessaire pour compiler des exemples.
# On remplace Lsystem; par une lien pour le telecharger.
COMC="s!${IMPORTc}!\1 <a href=\"https://github.com/pivaldi/asymptote-packages\">Lsystem</a>!g"
COMD="s!${IMPORTd}!\1 <a href=\https://github.com/pivaldi/asymptote-packages\">carteApoints</a>!g"

for topic in $_TOPICS; do
  echo "==> Handling topic '$topic'..."

  SRC_DIR="$(get-src-dir $topic)"
  TARGET_ASSET_ASY_DIR="${ASSET_ASY_DIR}${topic}/"
  TARGET_XML_OUT_DIR="${XML_OUT_DIR}${topic}/"
  TMP_DIR="${TMP_PROJECT_DIR}${topic}/"

  # La categorie (le term_id) de plus bas niveau est sur la derniere ligne
  CATNUM=$(tail -n 1 "${SRC_DIR}category.txt" | sed 's/-.*//g')
  CATEGORY=$(tail -n 1 "${SRC_DIR}category.txt" | sed -E 's/^[0-9]+-//g')

  # -----------------------------
  # * L'index de tous les codes *
  cat>${TARGET_XML_OUT_DIR}index.xml<<EOF
<?xml version="1.0" ?>
<asy-code title="$(cat ${SRC_DIR}title.txt)" date="`LANG=US date`">
<presentation>$(cat ${SRC_DIR}presentation.html)</presentation>
EOF

  # ---------------
  # * Les figures *
  cat>${TARGET_XML_OUT_DIR}figures.xml<<EOF
<?xml version="1.0" ?>
<asy-figures title="Pic - $(cat ${SRC_DIR}title.txt)" date="`LANG=US date`" resource="${RES}">
<presentation>$(cat ${SRC_DIR}presentation.html)</presentation>
EOF

  numfig=1001

  for fic in $(get_asy_files $SRC_DIR) ; do
    echo "  => Found asy file $fic"

    ficssext=${fic%.*}
    ficssext=$(basename $ficssext)
    htmlizedFile="${TMP_DIR}${ficssext}.asy.html"
    fullssext="${SRC_DIR}${ficssext}"

    # le tag ADDPDF permet de mettre un lien vers le fichier .pdf
    COMB="s%ADDPDF%<a href=\"###DIRNAME###${ficssext}.pdf\">${TARGET_ASSET_ASY_DIR}${ficssext}.pdf<\/a>%g"

    # *=========================================*
    # *..Creating .html files from .asy files...*
    # *=========================================*
    if [ "${fic}" -nt "${htmlizedFile}" ]; then
      echo "Htmlizing ${fic}"
      # emacsclient -q -e '(htmlize-file "'${fic}'" "'$htmlizedFile'")' > /dev/null
      $PYGMENTYZE_CMD -f html -o "$htmlizedFile" "${fic}"
      echo "  => $htmlizedFile"

      # Modifying the html
      sed -i -e "$COMB;$COMC;$COMD" "$htmlizedFile" || exit 1
    fi

    #################################################

    ## Creating unique key for code anchor
    [ ! -e "${fullssext}.id" ] && md5sum "$fic" | \
        cut -f1 -d" " > "${fullssext}.id"

    ## The post id (useful for CMS).
    POSTID=$(cat "${fullssext}.id")

    width="none"
    height="none"
    asy_version=

    [ -e ${fullssext}.ver ] && {
      asy_version=$(sed 's/ \[.*\]//g' ${fullssext}.ver)
    } || {
      asy_version=$($ASY_CMD --version 2>&1 | sed 1q | sed 's/ \[.*\]//')
    }

    # ---------------------
    # * code de la figure *
    cat>${TARGET_XML_OUT_DIR}${ficssext}.xml<<EOF
<?xml version="1.0" ?>
<asy-code title="$(cat ${SRC_DIR}title.txt)" date="`LANG=US date`">
<presentation>$(cat ${SRC_DIR}presentation.html)</presentation>
<code number="${numfig#1}" filename="${ficssext}" \
asyversion="$asy_version" `cat "${fullssext}.format"` \
catname="${CATEGORY}" catnum="${CATNUM}" id="$(cat ${fullssext}.id)" \
smallImg="$([ -e ${fullssext}r.${EXTIMAG} ] && echo true || echo false)" \
width="${width}" height="${height}">
EOF

    cat>>${TARGET_XML_OUT_DIR}index.xml<<EOF
<code number="${numfig#1}" filename="${ficssext}" postid="${POSTID}" \
asyversion="$asy_version" `cat "${fullssext}.format"` \
smallImg="$([ -e ${fullssext}r.${EXTIMAG} ] && echo true || echo false)" \
width="${width}" height="${height}" id="$(cat ${fullssext}.id)">
EOF


    # Add eventual text present in figxxx.md
    [ -e "${fullssext}.md" ] && {
      ## md version here
      echo "<text-md>" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"
      cat "${fullssext}.md" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"
      echo "</text-md>" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> ${TARGET_XML_OUT_DIR}index.xml

      ## html converted version here
      echo "<text-html>" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"
      markdown "${fullssext}.md" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"
      echo "</text-html>" | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> ${TARGET_XML_OUT_DIR}index.xml
    }

    echo  '<pre>' | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"

    inner-tag "$htmlizedFile" 'pre'  | tee -a "${TARGET_XML_OUT_DIR}${ficssext}.xml" >> "${TARGET_XML_OUT_DIR}index.xml"

    cat>>${TARGET_XML_OUT_DIR}index.xml<<EOF
</pre>
</code>
EOF

    cat>>${TARGET_XML_OUT_DIR}${ficssext}.xml<<EOF
</pre>
</code>
</asy-code>
EOF

    cat>>${TARGET_XML_OUT_DIR}figures.xml<<EOF
<figure number="${numfig#1}" filename="${ficssext}" \
asyversion="$asy_version" `cat "${fullssext}.format"`/>
EOF

    numfig=$[$numfig+1]
  done

  cat>>${TARGET_XML_OUT_DIR}index.xml<<EOF
</asy-code>
EOF

  cat>>${TARGET_XML_OUT_DIR}figures.xml<<EOF
</asy-figures>
EOF

done
