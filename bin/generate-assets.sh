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

EXTIMAG="png" #format des images sorties par defaut.
EXTASY="eps"  #format de sortie de asy par defaut
# sauf si le code contient le mot "opacity" (=> pdf))
MAXW=200      # Largeur maximale des images
MAXH=$MAXW    # Hauteur maximale des images
AFFCODE=true  # par defaut chaque image est suivie du code qui la genere. (option -nocode pour changer)

ASYOPTION="-noprc "

# Load shared code
. $(dirname $0)/shared.rc || exit 1


## Le répertoire où se trouve les ressources html (.xsl, .css, favicon...)
## Relatif à ROOT_PROJECT_DIR.
RESSOURCES="asset/" # Doit se terminer par un '/'

## HTML export dir
HTML_EXPORT_DIR="${BUILD_DIR}/html/"  # Doit se terminer par un '/'

# L'adresse du site (utile pour de rares liens dans les html statiques)
URIS='http://www.piprime.fr/' # statique
# *=======================================================*
# *................Fin de la configuration................*
# *=======================================================*

## Le chemin relatif du repertoire ROOT_PROJECT_DIR par
## rapport au repertoire courant (il se termine par un '/').
REL=`pwd | sed "s!${ROOT_PROJECT_DIR}*!/!" | sed "s![^/]*!..!g"`"/"

## Le chemin relatif du repertoire racine par
## rapport au repertoire d'export html (il se termine par un '/').
REL_OUT_DIR="`pwd | sed "s!${HTML_EXPORT_DIR}!!"`/"

RES=${REL}${RESSOURCES}

init_build_option() {
  GENCODE=true
  ANIM=false
  ASYOPTION="-noprc"
}

init_build_option

convert_()
{
  $CONVERT_CMD -density 350 -quality 100 -depth 8 -strip "${1}" -resample 96 "${2}" &> /dev/null
}

createAnimation()
{
  echo "Generation du png de presentation de l'animation."

  if ls _${1}*.pdf 2>/dev/null ;then # Présence de fichier(s) auxiliaire(s)
     echo "Fichiers auxiliaires pdf détectés."
     if [ -e  "_${1}.pdf" ]; then
       echo "Le fichier auxiliaire est déja animé."
       mv -f "_${1}.pdf" "${1}.pdf"
       I=$(pdfinfo -meta ${1}.pdf | grep "Pages" |sed "s/Pages: *//g")
       I=$(( 3*I/4 ))
       pdftk A="${1}.pdf" cat A$I output "${1}_first.pdf"
       convert_ "${1}_first.pdf" "${1}.png" && rm "${1}_first.pdf"
     else
       echo "Il faut assembler les pdf auxiliaires"
       FIGSpdf=""
       NB=0
       for I in `find -maxdepth 1 -name "_$1*[0-9].pdf" -print \
                | sed "s/.\/_$1\([0-9]*\).pdf/\1/g" |sort -n`; do
         FIGSpdf="${FIGSpdf} _${1}${I}.pdf"
         NB=$(( NB+1 ))
       done
       echo "Assemblage des pdf."
       pdftk $FIGSpdf cat output $1.pdf
       echo "Generation du png de presentation a partir de la page ${I} du pdf."
       I=$(( 3*NB/4 ))
       convert_ "_${1}${I}.pdf" "${1}.png"
     fi
     find -maxdepth 1 -name "_${1}[0-9]*.eps" -o -name "_${1}[0-9]*.pdf" -exec rm {} \;
     [ -e "${1}.gif" ] && rm "${1}.gif"
     else
       if [ -e "${1}.pdf" ]; then
         echo "Le fichier pdf de base existe et est anime"
         I=$(pdfinfo -meta ${1}.pdf | grep "Pages" |sed "s/Pages: *//g")
         I=$(( 3*I/4 ))
         echo "Extraction de la page ${I} du pdf."
         pdftk A="${1}.pdf" cat A$I output "${1}_first.pdf"
         echo "Generation du png de presentation."
         convert_ "${1}_first.pdf" "${1}.png" && rm "${1}_first.pdf"
       fi
  fi

     if [ -e "${1}.pdf" ]; then #Animation vectoriel
       printf "Redecoupage de ${1}.pdf"
       find -maxdepth 1 -name "pg*.pdf" -exec rm {} \;
       pdftk "${1}.pdf" burst && echo " ... FAIT."
       echo ""
       echo "Generation du l'animation ${1}.gif"
       $CONVERT_CMD -delay 10 -loop 0 pg*.pdf "${1}.gif" &> /dev/null && echo "FAIT."
       rm pg*.pdf
     else # Seul le gif existe
       echo "Generation du png de presentation a partir de ${1}.gif"
       $CONVERT_CMD "$1.gif" tmp.png
       NB=0
       for I in `find -maxdepth 1 -name "tmp-*[0-9].png"\
 | sed "s/.\/tmp-\([0-9]*\).png/\1/g" |sort -n`; do
         NB=$(( NB+1 ))
       done
       NB=$(( 3*NB/4 ))
       mv "tmp-${NB}.png" "${1}.png"
       rm tmp-*.*
     fi

     cat>"$1.gif.html"<<EOF
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

}

for topic in $TOPICS; do
  echo "==> Handling topic '$topic'..."

  SRC_DIR="$(get-src-dir $topic)"
  TARGET_ASSET_ASY_DIR="${ASSET_ASY_DIR}${topic}/"
  TMP_DIR="${TMP_PROJECT_DIR}${topic}/"

  for fic in $(get_asy_files "$SRC_DIR") ; do
    cd "${TARGET_ASSET_ASY_DIR}"

    relfic=$(basename $fic)
    ficssext=${relfic%.*}

    [ "$fic" -nt "$relfic" ] && cp "$fic" "$relfic"

    init_build_option
    BUILD_RC="${SRC_DIR}build.rc"

    [ -e "$BUILD_RC" ] && . "$BUILD_RC"

    # *=======================================================*
    # *..............Compilation des .asy recents.............*
    # *=======================================================*
    if grep -E --quiet "(opacity)|(= *\"pdf\")" "${relfic}"
    then
      EXTASYTMP="pdf";
    else
      EXTASYTMP="$EXTASY";
    fi

    FIG_RC="${SRC_DIR}${ficssext}.rc"
    [ -e "$FIG_RC" ] && . "$FIG_RC"

    echo "format_img=\"${EXTIMAG}\" format_out=\"${EXTASYTMP}\" animation=\"${ANIM}\"" > "${ficssext}.format"

    if [ "${ficssext}.asy" -nt "${ficssext}.${EXTASYTMP}" ]; then
      if $ANIM; then
        COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION ${ficssext}"
      else
        COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION -f ${EXTASYTMP} ${ficssext}"
      fi

      echo "Compiling ${relfic}. Output format is ${EXTASYTMP}."
      eval "$COMM" && $ASY_CMD --version 2>&1 | sed 1q | sed 's/ \[.*\]//' > "${ficssext}.ver"
    fi

    if [ "${ficssext}.asy" -nt "${ficssext}.${EXTIMAG}" ]; then
      echo "Converting ${ficssext}.${EXTASYTMP}. Output format is ${EXTIMAG}."
      if $ANIM; then # We are in a animation directory
        createAnimation "${ficssext}"
      else
        convert_ "${ficssext}.${EXTASYTMP}" "${ficssext}.${EXTIMAG}"
      fi

      # Resizing picture if needed
      InfoImg=$(identify -format "%[fx:w] %[fx:h]" "${ficssext}.${EXTIMAG}") && {
        W=$(echo "$InfoImg" | cut -d' ' -f1)
        H=$(echo "$InfoImg" | cut -d' ' -f2)
        if [ $W -gt $MAXW ] || [ $H -gt $MAXH ]; then
          $CONVERT_CMD "${ficssext}.${EXTASYTMP}" -resize "${MAXW}x${MAXH}" "tmp.${EXTIMAG}" && \
            mv -f "tmp.${EXTIMAG}" "${ficssext}r.${EXTIMAG}" && echo "${ficssext}.${EXTIMAG} resized !"
        fi
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
