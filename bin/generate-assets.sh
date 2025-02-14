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

# *=======================================================*
# *................Variables à configurer.................*
# *=======================================================*

# Load shared code
. $(dirname $0)/shared.rc || die $?

MAXW=200                # Largeur maximale des images
MAXH=$MAXW              # Hauteur maximale des images
VIEW_OPTION=" -wait -V" ## To view the generated result
VIEW_OPTION=""

ASYOPTION="-noprc "

## Le répertoire où se trouve les ressources html (.xsl, .css, favicon...)
## Relatif à ROOT_PROJECT_DIR.
RESSOURCES="asset/" # Doit se terminer par un '/'

## HTML export dir
HTML_EXPORT_DIR="${BUILD_DIR}/html/" # Doit se terminer par un '/'

# L'adresse du site (utile pour de rares liens dans les html statiques)
URIS='http://www.piprime.fr/' # statique
# *=======================================================*
# *................Fin de la configuration................*
# *=======================================================*

## Le chemin relatif du repertoire ROOT_PROJECT_DIR par
## rapport au repertoire courant (il se termine par un '/').
REL=$(pwd | sed "s!${ROOT_PROJECT_DIR}*!/!" | sed "s![^/]*!..!g")"/"

## Le chemin relatif du repertoire racine par
## rapport au repertoire d'export html (il se termine par un '/').
REL_OUT_DIR="$(pwd | sed "s!${HTML_EXPORT_DIR}!!")/"

EXTIMAG_BCK="$EXTIMAG"

RES=${REL}${RESSOURCES}

init_build_option() {
  GENCODE=true
  ANIM=false
  ASYOPTION="-noprc"
  DEFAULT_OUT_FILE=
  EXTIMAG="$EXTIMAG_BCK"
  EXTASY="$EXTIMAG_BCK" #format de sortie de asy par defaut
}

init_build_option

convert_() {
  $CONVERT_CMD -density 350 -quality 100 -depth 8 -strip "${1}" -resample 96 "${2}" &>/dev/null
}

## Extrait du pdf $1 la page 3/4 du doc et la convertit en $2
extract_pdf_page() {
  I=$(pdfinfo ${1} | grep "Pages" | sed "s/Pages: *//g")
  I=$((3 * I / 4))

  echo "Extraction de la page $I du pdf $1"
  page="${TMP_PROJECT_DIR}page.pdf"
  pdftk A="$1" cat A$I output "$page" || die $?

  echo "Generation du ${EXTIMAG} de presentation $2"
  convert_ "$page" "$2" || die $?
  DEFAULT_OUT_FILE="$page"
}

## $1 est le fichier sans extension à animer et $2 le répoertoire de destination
## de l'nimation
createAnimation() {
  echo "Generation du ${EXTIMAG} de presentation de l'animation."

  DEST_DIR="$2"

  cd "$DEST_DIR"

  if ls _${1}*.pdf >/dev/null 2>&1; then # Présence de fichier(s) auxiliaire(s)
    echo "Fichiers auxiliaires pdf détectés…"

    if [ -e "_${1}.pdf" ]; then
      echo "Un seul fichier auxiliaire détecté et il doit être déja animé."
      mv -f "_${1}.pdf" "${1}.pdf"

      extract_pdf_page "${1}.pdf" "${DEST_DIR}${1}.${EXTIMAG}"
    else
      echo "Les fichiers auxiliaires ne sont pas animés."
      FIGSpdf=""
      NB=0

      for I in $(find -maxdepth 1 -name "_$1*[0-9].pdf" -print | sed "s/.\/_$1\([0-9]*\).pdf/\1/g" | sort -n); do
        FIGSpdf="${FIGSpdf} _${1}${I}.pdf"
        NB=$((NB + 1))
      done

      echo "Assemblage des pdf auxiliaires."
      pdftk $FIGSpdf cat output "$1.pdf" || die $?

      I=$((3 * NB / 4))
      echo "Generation du ${EXTIMAG} de presentation à partir de la page ${I} du pdf."
      DEFAULT_OUT_FILE="_${1}${I}.pdf"
      convert_ "$DEFAULT_OUT_FILE" "${1}.${EXTIMAG}" || die $?
    fi

    find -maxdepth 1 -name "_${1}[0-9]*.eps" -o -name "_${1}[0-9]*.pdf" -exec rm {} ';'
    # [ -e "${1}.gif" ] && rm "${1}.gif"
  else
    if [ -e "${1}.pdf" ]; then
      echo "Le fichier pdf de base existe et doit être animé."

      extract_pdf_page "${1}.pdf" "${1}.${EXTIMAG}"
    fi
  fi

  if [ -e "${1}.pdf" ]; then #Animation vectoriel
    printf "Redecoupage de ${1}.pdf…"

    find -maxdepth 1 -name "pg*.pdf" -exec rm {} \;
    pdftk "${1}.pdf" burst && echo " FAIT !" || die $?

    printf "Generation du l'animation ${1}.gif…"

    $CONVERT_CMD -delay 10 -loop 0 pg*.pdf "${1}.gif" &>/dev/null || die $? && echo " FAIT !"
    rm pg*.pdf ## nettoyage après le burst
  else         # Seul le gif existe
    echo "Generation du ${EXTIMAG} de presentation à partir de ${1}.gif"

    $CONVERT_CMD "$1.gif" tmp.${EXTIMAG} || die $?

    [ -e tmp.${EXTIMAG} ] && { ## Le gif génère un seul fichier (cas webp par exemple).
      mv "tmp.${EXTIMAG}" "${1}.${EXTIMAG}"
    } || { ## Le gif génère plusieurs fichiers (cas png par exemple).
      NB=0
      for I in $(find -maxdepth 1 -name "tmp-*[0-9].${EXTIMAG}" | sed "s/.\/tmp-\([0-9]*\).${EXTIMAG}/\1/g" | sort -n); do
        NB=$((NB + 1))
      done

      NB=$((3 * NB / 4))
      mv "tmp-${NB}.${EXTIMAG}" "${1}.${EXTIMAG}"
      rm tmp-*.*
    }
  fi

  cat >"$1.gif.html" <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="shortcut icon" href="${RES}favicon.png" type="image/x-icon" />
<meta name="author" content="Philippe Ivaldi" />
<link href="${RES}style-asy.css" rel="stylesheet" type="text/css" />
<title>${1}.gif</title>
</head>
<body>
<center>
<img src="$1.gif" alt="$1.gif">
</center>
</body>
</html>
EOF

  cd -
}

sync-src-dir-to-tmp-dir || die $?

for topic in $TOPICS; do
  echo "==> Handling topic '$topic'..."

  SRC_DIR="$(get-src-dir $topic)"
  ASSET_DIR="${ASSET_ASY_DIR}${topic}/"

  for fic in $(get_asy_files "$SRC_DIR"); do
    # cd "$ASSET_DIR}"
    cd "$SRC_DIR" || die $?

    srcfic="$(basename $fic)"
    srcficssext=${srcfic%.*}
    destfic="${ASSET_DIR}$srcfic"
    destficssext=${destfic%.*}

    init_build_option
    BUILD_RC="${SRC_DIR}build.rc"

    [ -e "$BUILD_RC" ] && . "$BUILD_RC"
    # *=======================================================*
    # *..............Compilation des .asy recents.............*
    # *=======================================================*
    # if grep -E --quiet '(^[^/][^/].+opacity)|(^[^/][^/].+= *"pdf")' "${srcfic}"
    # then
    #   EXTASYTMP="pdf";
    # else
    #   EXTASYTMP="$EXTASY";
    # fi

    unset SKIP_BUILD
    FIG_RC="${SRC_DIR}${srcficssext}.rc"
    [ -e "$FIG_RC" ] && {
      echo "Loading $FIG_RC"
      . "$FIG_RC"
    }
    ## TODO: On the various directory some asy codes generate temporary files
    ## that are used to generate the final document. This does not work with the
    ## asy compile option -outname. Fixe this…
    [ -z "$SKIP_BUILD" ] || continue

    EXTASYTMP="$EXTASY"
    EXTIMAGTMP="$EXTIMAG"

    if $ANIM; then
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION $VIEW_OPTION -outname ${ASSET_DIR} ${srcficssext}"
      EXTASYTMP=pdf
      EXTIMAGTMP=${EXTIMAG}
    else
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION -f ${EXTASYTMP} $VIEW_OPTION -outname ${ASSET_DIR} ${srcficssext}"
    fi

    DEST_IMG="${destficssext}.${EXTIMAGTMP}"

    if [ "${srcficssext}.asy" -nt "$DEST_IMG" ]; then
      echo "Compiling ${srcfic} to ${ASSET_DIR}"
      echo "Output format is ${EXTASYTMP}"
      _do_or_die "$COMM" && $ASY_CMD --version 2>&1 | sed 1q | sed 's/ \[.*\]//' >"${ASSET_DIR}${srcficssext}.ver"

      # emacsclient "/home/pi/code/pi/asymptote/asymptote-exemples-builder/src/$topic/${srcficssext}.asy"

      echo "Converting ${srcficssext}.${EXTASYTMP} to ${EXTIMAG}."

      if $ANIM; then # We are in a animation directory
        createAnimation "${srcficssext}" "$ASSET_DIR"
      else
        [ "$EXTIMAGTMP" == "$EXTASYTMP" ] || {
          convert_ "${destficssext}.${EXTASYTMP}" "$DEST_IMG" || die $?
        } || {
          mv "${destficssext}.${EXTASYTMP}" "$DEST_IMG" || die $?
        }
      fi

      [ -e "$DEST_IMG" ] || {
        if [ -e "${destficssext}-0.${EXTASYTMP}" ]; then
          mv -f "${destficssext}-0.${EXTASYTMP}" "$DEST_IMG" || die $?
          DEFAULT_OUT_FILE="${destficssext}.pdf[0]"
        else
          convert_ "${destficssext}.png" "$DEST_IMG" || die $?
        fi
      } || {
        echo "Image not generated : $DEST_IMG"
        die 1
      }

      # echo "format_img=\"${EXTIMAGTMP}\" format_out=\"${EXTASYTMP}\" animation=\"${ANIM}\"" >"${destficssext}.format"

      [ "$EXTIMAGTMP" == 'svg' ] || {
        echo "Resizing ${EXTIMAG} picture if needed"

        InfoImg=$(identify -format "%[fx:w] %[fx:h]" "$DEST_IMG") && {
          W=$(echo "$InfoImg" | cut -d' ' -f1)
          H=$(echo "$InfoImg" | cut -d' ' -f2)
          if [ $W -gt $MAXW ] || [ $H -gt $MAXH ]; then
            OUT_FILE="${destficssext}.${EXTASYTMP}"

            ## Find the file that permit to generate the ${EXTIMAG}
            [ "$DEFAULT_OUT_FILE" = "" ] || OUT_FILE="$DEFAULT_OUT_FILE"
            [ -e "$OUT_FILE" ] || OUT_FILE="$DEST_IMG"

            echo "Resizing $OUT_FILE to ${MAXW}x${MAXH}"
            TMP_F="${ASSET_DIR}tmp.${EXTIMAG}"
            $CONVERT_CMD -resize "${MAXW}x${MAXH}" "$OUT_FILE" "$TMP_F" && {
              mv -f "$DEST_IMG" "${destficssext}-fs.${EXTIMAG}" || die $?
              mv -f "$TMP_F" "$DEST_IMG" || die $?
              echo "$DEST_IMG resized from $OUT_FILE !"
            } || die $?
          fi
        }
      }
    fi
  done
done

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
