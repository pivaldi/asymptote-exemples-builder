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
. "$(dirname "$0")/shared.rc" || die $?

EXTIMAG_BCK="$EXTIMAG"

init_build_option() {
  ANIM=false
  LOOP=true
  ASYOPTION='-noprc -tex "pdflatex"'
  DEFAULT_OUT_FILE=
  EXTIMAG="$EXTIMAG_BCK"
  EXTASY="$EXTIMAG" # defaut output format of asy cmd
  # VIEW_OPTION=" -wait -V" ## To view the generated result
  VIEW_OPTION=
  OUT_FORMAT=
  LOOP=
}

init_build_option

convert_() {
  $CONVERT_CMD -density 350 -quality 100 -depth 8 "${1}" -resample 96 "${2}"
}

## Extrait du pdf $1 la page 3/4 du doc et la convertit en $2
extract_pdf_page() {
  I=$(pdfinfo "${1}" | grep "Pages" | sed "s/Pages: *//g")
  I=$((3 * I / 4))

  echo "Extracting page $I from pdf $1"
  page="${TMP_PROJECT_DIR}page.pdf"
  pdftk A="$1" cat A$I output "$page" || die $?

  echo "Generating of ${EXTIMAG} from $page for presentation $2"
  convert_ "$page" "$2" || die $?
  DEFAULT_OUT_FILE="$page"
}

## $1 is the file without extension to animate and $2 is the directory
## destination of the animation.
createAnimation() {
  echo "Generation du ${EXTIMAG} de presentation de l'animation."

  DEST_DIR="$2"

  cd "$DEST_DIR" || exit 1

  if ls _"${1}"*.pdf >/dev/null 2>&1; then # Présence de fichier(s) auxiliaire(s)
    echo "Auxiliary PDF files detected"

    if [ -e "_${1}.pdf" ]; then
      echo "A single auxiliary file detected… It must already be animated !"
      mv -f "_${1}.pdf" "${1}.pdf"

      extract_pdf_page "${1}.pdf" "${DEST_DIR}${1}.${EXTIMAG}"
    else
      echo "Auxiliary files are not animated."
      FIGSpdf=""
      NB=0

      for I in $(find -maxdepth 1 -name "_$1*[0-9].pdf" -print | sed -E "s/.\/_$1\+([0-9]+)\.pdf/\1/" | sort -n); do
        FIGSpdf="${FIGSpdf} _${1}+${I}.pdf"
        NB=$((NB + 1))
      done

      echo "Assembly of auxiliary PDFs."
      # shellcheck disable=SC2086
      pdftk $FIGSpdf cat output "$1.pdf" || die $?

      I=$((3 * NB / 4))
      echo "Generating ${EXTIMAG} presentation from the page ${I} of the the pdf file…"
      DEFAULT_OUT_FILE="_${1}+${I}.pdf"
      convert_ "$DEFAULT_OUT_FILE" "${1}.${EXTIMAG}" || die $?
    fi

    find . -maxdepth 1 '(' -name "_${1}[0-9]*.eps" -o -name ')' "_${1}[0-9]*.pdf" -exec rm {} ';'
  else
    if [ -e "${1}.pdf" ] && [ "${1}.asy" -nt "${1}.gif" ]; then
      echo "The base pdf file exists and should be animated."

      extract_pdf_page "${1}.pdf" "${1}.${EXTIMAG}"
    fi
  fi

  [ -e "${1}.pdf" ] && [ "${1}.asy" -nt "${1}.gif" ] && { #Animation vectoriel
    printf "Rediscover of %s.pdf…\n" "${1}"

    find -maxdepth 1 -name "pg*.pdf" -exec rm {} \;
    pdftk "${1}.pdf" burst && echo " DONE !" || die $?

    printf "Generating animation %s.gif…\n" "${1}"

    $CONVERT_CMD -delay 10 -loop 0 pg*.pdf "${1}.gif" || die $? && echo " DONE !"
    rm pg*.pdf ## cleaning after burst
  }

  [ "${1}.gif" -nt "${1}.${EXTIMAG}" ] && {
    echo "Adding copyright to ${1}.gif"
    addCopyright "${1}.gif" || die $?

    echo "Generating ${EXTIMAG} presentation from ${1}.gif"
    NB=$($CONVERT_CMD "${1}.gif" -format "%N" info:)
    N=$((NB / 3))
    $CONVERT_CMD "${1}.gif[$N]" "${1}.${EXTIMAG}" || die $?

    echo "Generating mp4 video from ${1}.gif"
    ffmpeg -y -i "${1}.gif" -movflags faststart -pix_fmt yuv420p -crf 0 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${1}.mp4" || exit 1
  }
}

sync-src-dir-to-tmp-dir || die $?

for topic in $TOPICS; do
  # for topic in animations; do
  echo "==> Handling topic '$topic'..."

  SRC_DIR=$(get-src-dir "$topic")

  for fic in $(get_asy_files "$SRC_DIR"); do
    cd "$SRC_DIR" || die $?

    srcfic=$(basename "$fic")
    srcficssext=${srcfic%.*}
    destfic="${SRC_DIR}$srcfic"
    destficssext=${destfic%.*}

    init_build_option
    BUILD_RC="${SRC_DIR}build.rc"

    # shellcheck source=../src/animations/build.rc
    [ -e "$BUILD_RC" ] && . "$BUILD_RC"

    FIG_RC="${SRC_DIR}${srcficssext}.rc"
    [ -e "$FIG_RC" ] && {
      # shellcheck source=../src/solids/fig0120.rc
      . "$FIG_RC"
    }

    EXTASYTMP="$EXTASY"
    EXTIMAGTMP="$EXTIMAG"

    [ -z "$OUT_FORMAT" ] || EXTASYTMP="$OUT_FORMAT"

    if $ANIM; then
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION $VIEW_OPTION ${srcficssext}"
      EXTASYTMP=gif
      EXTIMAGTMP=${EXTIMAG}
      [ -z "$LOOP" ] && LOOP=true
    else
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION -f ${EXTASYTMP} $VIEW_OPTION ${srcficssext}"
    fi

    DEST_IMG="${destficssext}.${EXTIMAGTMP}"

    if [ "${srcficssext}.asy" -nt "$DEST_IMG" ]; then
      echo "Compiling $(pwd)/${srcfic}"
      echo "Default output format is ${EXTASYTMP}"
      _do_or_die "$COMM"

      # emacsclient "/home/pi/code/pi/asymptote/asymptote-exemples-builder/src/$topic/${srcficssext}.asy"

      if $ANIM; then # We are in a animation directory
        createAnimation "${srcficssext}" "$SRC_DIR"
      else
        [ "$EXTIMAGTMP" != "$EXTASYTMP" ] && {
          echo "Converting ${srcficssext}.${EXTASYTMP} to ${EXTIMAG}."
          convert_ "${destficssext}.${EXTASYTMP}" "$DEST_IMG" || die $?
        }
      fi

      ## We ask to asy to export to EXTIMAG but some code set the output to an other format ;
      ## so we must handle all possible formats.
      [ -e "$DEST_IMG" ] || { ## Animated pdf
        if [ -e "${destficssext}-0.${EXTASYTMP}" ]; then
          mv -f "${destficssext}-0.${EXTASYTMP}" "$DEST_IMG" || die $?
          rm "${destficssext}-"*".${EXTASYTMP}"
          DEFAULT_OUT_FILE="${destficssext}.pdf[0]"
        else ## Force export in pdf or png in the code.
          FOUND=false
          for ext in pdf png; do
            [ -e "${destficssext}.${ext}" ] && {
              echo "converting ${destficssext}.${ext} to $DEST_IMG"
              convert_ "${destficssext}.${ext}" "$DEST_IMG" || die $?
              FOUND=true
            }

            $FOUND && continue
          done

          $FOUND ## if false go to next ||
        fi
      } || {
        echo "Image not generated : $DEST_IMG"
        die 1
      }

      echo "Adding copyright to ${srcficssext}.${EXTIMAG}"
      addCopyright "${srcficssext}.${EXTIMAG}" || die $?

      MD5_SUM=$(md5sum "${srcficssext}.asy" | cut -d ' ' -f 1)

      HAS_PDF='false'
      [ -e "${destficssext}.pdf" ] && HAS_PDF="true"
      IS_ANIM='false'
      [ -e "${destficssext}.gif" ] && IS_ANIM="true"

      width=$(identify -format '%w' "${srcficssext}.${EXTIMAG}")
      height=$(identify -format '%h' "${srcficssext}.${EXTIMAG}")

      DIM_W="width=\"$width\""
      DIM_H="height=\"$height\""
      LOOPING="loop=\"${LOOP}\""
      MD5="md5=\"${MD5_SUM}\""
      IMG_EXT="img_ext=\"${EXTIMAG}\""
      TOPIC="topic=\"${topic}\""
      FILENAME="filename=\"${srcficssext}\""
      PDF="has_pdf=\"${HAS_PDF}\""
      ANIM="is_anim=\"${IS_ANIM}\""
      ASY_VER="asy_version=\"$($ASY_CMD --version 2>&1 | sed 1q | awk -F ' ' '{print $3}')\""
      echo "$FILENAME $MD5 $IMG_EXT $DIM_H $DIM_W $TOPIC $PDF $ANIM $LOOPING $ASY_VER" >"${srcficssext}.buildinfo"

      ## Creating symlink to all needed media
      [ ! -e "${MD5_SUM}.${EXTIMAG}" ] && ln -s "${srcficssext}.${EXTIMAG}" "${MD5_SUM}.${EXTIMAG}"
      "${IS_ANIM}" && {
        [ ! -e "${MD5_SUM}.gif" ] && ln -s "${srcficssext}.gif" "${MD5_SUM}.gif"
        [ ! -e "${MD5_SUM}.mp4" ] && ln -s "${srcficssext}.mp4" "${MD5_SUM}.mp4"
      }
      [ ! -e "${MD5_SUM}.pdf" ] && "${HAS_PDF}" && ln -s "${srcficssext}.pdf" "${MD5_SUM}.pdf"
    fi
  done
done

rsync -au \
  --exclude='*+*.pdf' \
  --exclude='*converted-to.pdf' \
  --include='*.gif' \
  --include='*.mp4' \
  --include='*.pdf' \
  --include='*.buildinfo' \
  --include="*.$EXTIMAG" \
  --include='*.svg' \
  --include='*/' \
  --exclude='*' \
  --delete "$TMP_PROJECT_DIR" "$BUILD_ASY_DIR" || exit 1

echo "DONE !"

# # *=======================================================*
# # *................Creation de index.html.................*
# # *=======================================================*
# if [ "code.xml" -nt "index.html" ] && $GENCODE; then
#     echo "Creation de INDEX.HTML dans `pwd`"
#     xsltproc code.xml | sed "s!###URI###!${URIS}!g" > index.html
#     sed -i "s/###DIRNAME###//g" index.html
# fi

# if [ "figure.xml" -nt "figure-index.html" ] || [ "figure.xml" -nt "index.html" ]; then
#     if $GENCODE; then
#         echo "Creation de FIGURE-INDEX.HTML dans `pwd`"
#         xsltproc figure.xml --stringparam gencode true > figure-index.html
#     else
#         echo "Creation de INDEX.HTML dans `pwd`"
#         xsltproc figure.xml --stringparam gencode false | \
#             sed "s!###URI###!${URIS}!g" > index.html
#     fi
# fi

# echo "## The End ##"
