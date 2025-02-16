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
MAXW=200     # Largeur maximale des images
MAXH=$MAXW   # Hauteur maximale des images
AFFCODE=true # par defaut chaque image est suivie du code qui la genere. (option -nocode pour changer)

# ASY_CMD=/usr/local/svn/asymptote/asy
# ASYOPTION="-render=8 -maxviewport=1000 -noprc -glOptions=-iconic "
# ASY_CMD=/usr/local/asymptote/bin/asy
# ASYOPTION="-render=8 -noprc -maxtile=\(900,900\) "
ASYOPTION="-noprc "
# ASYOPTION=""

[ -z $ROOT_PROJECT_DIR ] && {
  echo 'ROOT_PROJECT_DIR environment variable is not set.'
  echo "Use the command line 'ROOT_PROJECT_DIR=/xxx/xxx $0'"
  exit 1
}

## https://stackoverflow.com/questions/1848415/remove-slash-from-the-end-of-a-variable
case $ROOT_PROJECT_DIR in *[!/]*/) ROOT_PROJECT_DIR=${ROOT_PROJECT_DIR%"${ROOT_PROJECT_DIR##*[!/]}"} ;; esac

ROOT_PROJECT_DIR="${ROOT_PROJECT_DIR}/"

## Le répertoire où se trouve les ressources html (.xsl, .css, favicon...)
## Relatif à ROOT_PROJECT_DIR.
RESSOURCES="asset/" # Doit se terminer par un '/'

## HTML export dir
HTML_EXPORT_DIR="${ROOT_PROJECT_DIR}/html/" # Doit se terminer par un '/'

# L'adresse du site (utile pour de rares liens dans les html statiques)
URIS='http://www.piprime.fr/'   # statique
URID="<?=get_bloginfo('url')?>" # dynamique
# *=======================================================*
# *................Fin de la configuration................*
# *=======================================================*

## Le chemin relatif du repertoire ROOT_PROJECT_DIR par
## rapport au repertoire courant (il se termine par un '/').
REL=$(pwd | sed "s!${ROOT_PROJECT_DIR}*!/!" | sed "s![^/]*!..!g")"/"

## Le chemin relatif du repertoire racine par
## rapport au repertoire d'export html (il se termine par un '/').
REL_OUT_DIR="$(pwd | sed "s!${HTML_EXPORT_DIR}!!")/"

RES=${REL}${RESSOURCES}

GENCODE=true
ODOC=false
ANIM=false

while true; do
  case $1 in
  -gif)
    EXTIMAG="gif"
    ;;
  -png)
    EXTIMAG="png"
    ;;
  -pdf) # Force l'utilisation du pdf
    EXTASY="pdf"
    ;;
  -odoc) # On est dans le répertoire des exemples officiels.
    ODOC=true
    nofind=$2
    ;;
  -anim) # On est dans le r�pertoire des animations.
    ANIM=true
    ;;
  -nocode)
    EXTASY="pdf"
    GENCODE=false # index.html est remplace par figure-index.html
    # et les figures pointent sur le pdf correspondant
    ;;
  *)
    break
    ;;
  esac
  shift
done

# Recupere le texte qui se trouve entre les balises <body> et </body>
function bodyinner() {
  cat $1 | awk -v FS="^Z" "/<body>/,/<\/body>/" | sed "s/<\/*body>//g"
}

function preinner() {
  cat $1 | awk -v FS="^Z" "/<pre>/,/<\/pre>/" | sed "s/<\/*pre>//g"
}

function get_asy_files() {
  if $ODOC; then
    find -type f -name '*\.asy' $nofind -print | sort
  else
    find ./ -maxdepth 1 -name 'fig*\.asy' -type f -print | sort
  fi
}

function convert_() {
  $CONVERT_CMD -density 350 -quality 100 -depth 8 -strip "${1}" -resample 96 "${2}" &>/dev/null
}

function createAnimation() {
  echo "Generation du png de presentation de l'animation."
  if ls _${1}*.pdf 2>/dev/null; then # Présence de fichier(s) auxiliaire(s)
    echo "Fichiers auxiliaires pdf détectés."
    if [ -e "_${1}.pdf" ]; then
      echo "Le fichier auxiliaire est déja animé."

      mv -f "_${1}.pdf" "${1}.pdf"
      I=$(pdfinfo -meta ${1}.pdf | grep "Pages" | sed "s/Pages: *//g")
      I=$((3 * I / 4))

      pdftk A="${1}.pdf" cat A$I output "${1}_first.pdf"
      convert_ "${1}_first.pdf" "${1}.png" && rm "${1}_first.pdf"
    else
      echo "Il faut assembler les pdf auxiliaires"
      FIGSpdf=""
      NB=0
      for I in $(find -maxdepth 1 -name "_$1*[0-9].pdf" -print | sed -E "s/.\/_$1\+([0-9]+)\.pdf/\1/" | sort -n); do
        FIGSpdf="${FIGSpdf} _${1}${I}.pdf"
        NB=$((NB + 1))
      done

      echo "Assemblage des pdf."
      pdftk $FIGSpdf cat output $1.pdf

      echo "Generation du png de presentation a partir de la page ${I} du pdf."
      I=$((3 * NB / 4))
      convert_ "_${1}${I}.pdf" "${1}.png"
    fi
    find -maxdepth 1 -name "_${1}[0-9]*.eps" -o -name "_${1}[0-9]*.pdf" -exec rm {} \;
    [ -e "${1}.gif" ] && rm "${1}.gif"
  else
    if [ -e "${1}.pdf" ]; then
      echo "Le fichier pdf de base existe et est doit être animé"

      I=$(pdfinfo -meta ${1}.pdf | grep "Pages" | sed "s/Pages: *//g")
      I=$((3 * I / 4))

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
    $CONVERT_CMD -delay 10 -loop 0 pg*.pdf "${1}.gif" &>/dev/null && echo "FAIT."
    rm pg*.pdf
  else # Seul le gif existe
    echo "Generation du png de presentation a partir de ${1}.gif"
    $CONVERT_CMD "$1.gif" tmp.png
    NB=0
    for I in $(find -maxdepth 1 -name "tmp-*[0-9].png" |
      sed "s/.\/tmp-\([0-9]*\).png/\1/g" | sort -n); do
      NB=$((NB + 1))
    done
    NB=$((3 * NB / 4))
    mv "tmp-${NB}.png" "${1}.png"
    rm tmp-*.*
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

}

CREATECODE=false # Par defaut il n'y a pas a recreer code.xml et index.html

# Quelques expressions rationnelles utilisees pour modifier le html genere.
IMPORTc="\(<span class=\"builtin\">import<\/span>\) *Lsystem"
IMPORTd="\(<span class=\"builtin\">import<\/span>\) *carteApoints"
IMPORTe="\(<span class=\"builtin\">import<\/span>\) *spring"

# Le fichier Lsystem.asy est parfois necessaire pour compiler des exemples.
# On remplace Lsystem; par une lien pour le telecharger.
COMC="s!${IMPORTc}!\1 <a href=\"https://github.com/pivaldi/asymptote-packages\">Lsystem</a>!g"
COMD="s!${IMPORTd}!\1 <a href=\https://github.com/pivaldi/asymptote-packages\">carteApoints</a>!g"
COMF="/syracuse/d"

for fic in $(get_asy_files); do
  ficssext=${fic%.*}
  ficssext=$(basename $ficssext)

  # le tag ADDPDF permet de mettre un lien vers le fichier .pdf
  COMB="s/ADDPDF/<a href=\"###DIRNAME###${ficssext}.pdf\">${ficssext}.pdf<\/a>/g"

  # *=======================================================*
  # *..Creation du fichier .html a partir du fichier .asy...*
  # *=======================================================*
  if [ "${fic}" -nt "${ficssext}.html" ]; then
    CREATECODE=true ## Il faudra recreer les .xml
    if $GENCODE; then
      echo "Conversion en html de ${ficssext}.asy"
      # pygmentize -f html "${fic}" -o
      emacsclient -q -e '(htmlize-file "'$(pwd)'/'$(basename ${fic})'")' >/dev/null
      # Modification du html
      cat "${ficssext}.asy.html" | sed -e "$COMA;$COMB;$COMC;$COMD;$COME;$COMF" > \
        "${ficssext}.html" && rm "${ficssext}.asy.html"
    fi
  fi

  # *=======================================================*
  # *..............Compilation des .asy recents.............*
  # *=======================================================*
  if grep -E --quiet "(opacity)|(= *\"pdf\")" "${ficssext}.asy"; then
    EXTASYTMP="pdf"
  else
    EXTASYTMP="$EXTASY"
  fi

  echo "format_img=\"${EXTIMAG}\" format_out=\"${EXTASYTMP}\" \
animation=\"${ANIM}\"" >"${ficssext}.format"

  if [ "${ficssext}.asy" -nt "${ficssext}.${EXTASYTMP}" ]; then
    [ -e "${ficssext}.opt" ] && eval $(cat "${ficssext}.opt")

    if $ANIM; then
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION ${ficssext}"
    else
      COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION -f ${EXTASYTMP} ${ficssext}"
    fi

    echo "Compiling ${ficssext}.asy. Output format is ${EXTASYTMP}."
    eval "$COMM" && $ASY_CMD --version 2>&1 | sed 1q >"${ficssext}.ver"
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
        $CONVERT_CMD "${ficssext}.${EXTASYTMP}" -resize "${MAXW}x${MAXH}" "tmp.${EXTIMAG}" &&
          mv -f "tmp.${EXTIMAG}" "${ficssext}r.${EXTIMAG}" && echo "${ficssext}.${EXTIMAG} resized !"
      fi
    }
  fi

done

# *=======================================================*
# *..................Creation des index...................*
# *=======================================================*
[ ! -e code.xml ] && ($GENCODE || [ ! -e figure.xml ]) && CREATECODE=true

# CREATECODE=true
#GENCODE=true

if $CREATECODE; then

  $GENCODE && echo "Creation de CODE.XML dans $(pwd)"

  # La categorie (le term_id) de plus bas niveau est sur la derniere ligne
  CATNUM=$(tail -n 1 category | sed 's/-.*//g')
  CATEGORY=$(tail -n 1 category | sed -E 's/^[0-9]+-//g')

  # -----------------------------
  # * L'index de tous les codes *
  $GENCODE && {
    cat >code.xml <<EOF
<?xml version="1.0" ?>
<?xml-stylesheet type="text/xsl" href="${RES}xsl/asycode2html.xsl" ?>
<asy-code title="Asy - $(cat title)" date="$(LANG=US date)" resource="${RES}">
<presentation>$(cat presentation)</presentation>
EOF
  }

  # ---------------
  # * Les figures *
  cat >figure.xml <<EOF
<?xml version="1.0" ?>
<?xml-stylesheet type="text/xsl" href="${RES}xsl/asyfigure2html.xsl" ?>
<asy-figure title="Pic - $(cat title)" date="$(LANG=US date)" resource="${RES}">
<presentation>$(cat presentation)</presentation>
EOF

  i=10001
  for fic in $(get_asy_files); do
    ficssext=${fic%.*}
    ficssext=$(basename $ficssext)

    ## Creation d'une clef unique pour le code
    [ ! -e "${ficssext}.id" ] && md5sum "${ficssext}.asy" |
      cut -f1 -d" " >"${ficssext}.id"
    ## Recuperation de l'id du post.
    POSTID=$(cat "${ficssext}.id")

    width="none"
    height="none"
    LINK=""
    if [ -e "${ficssext}.link" ]; then
      ## ce fichier comtient du texte sous cette forme:
      # TEXT="Du texte, du texte ###LINK### du texte, du texte"
      # URI="http://etc..."
      # URL="blabla bloblo"
      # cela cr�era le lien: Du texte, du texte <a href="http://etc...">blabla bloblo</a> du texte, du texte
      eval $(cat "${ficssext}.link")
      LINK=$(echo "${TEXT}" | sed "s!###LINK###!<a href=\"${URI}\">${URL}</a>!g")
    fi

    # ---------------------
    # * code de la figure *
    $GENCODE && {
      cat >"${ficssext}.xml" <<EOF
<?xml version="1.0" ?>
<?xml-stylesheet type="text/xsl" href="${RES}xsl/asycode2html.xsl" ?>
<asy-code title="Asy - $(cat title)" date="$(LANG=US date)" resource="${RES}"  dirname="${REL_OUT_DIR}">
<presentation>$(cat presentation)</presentation>
<code number="${i#1}" filename="${ficssext}" \
asyversion="$(sed 's/ \[.*\]//g' ${ficssext}.ver)" $(cat "${ficssext}.format") \
catname="${CATEGORY}" catnum="${CATNUM}" id="$(cat ${ficssext}.id)" \
smallImg="$([ -e ${ficssext}r.${EXTIMAG} ] && echo true || echo false)" \
width="${width}" height="${height}">
<link>$LINK</link>
EOF

      cat >>code.xml <<EOF
<code number="${i#1}" filename="${ficssext}" postid="${POSTID}" \
asyversion="$(sed 's/ \[.*\]//g' ${ficssext}.ver)" $(cat "${ficssext}.format") \
smallImg="$([ -e ${ficssext}r.${EXTIMAG} ] && echo true || echo false)" \
width="${width}" height="${height}" id="$(cat ${ficssext}.id)">
<link>$LINK</link>
EOF
    } || { # Il s'agit des cul-de-lampes... pour l'instant
      echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
      echo "!! Voir ce qu'on doit faire ici !!"
      echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
      error_here
      exit 1

      cat >"${ficssext}.php" <<EOF
<img src="<?=get_bloginfo('url')?>${REL_OUT_DIR}${ficssext}.png" alt="${ficssext}.png" /><br />
<a href='<?=get_bloginfo('url')?>${REL_OUT_DIR}${ficssext}.pdf'>The vectorial pdf file</a><br />
<a href='<?=get_bloginfo('url')?>${REL_OUT_DIR}${ficssext}.asy'>The Asymptote code</a>
EOF
    }
    # Cul-de-lampes vectorisé/Vectorized Tailpiece

    if $GENCODE; then
      # Ajout eventuel d'un texte
      [ -e "${ficssext}.md" ] && {
        echo "<texte>" | tee -a "${ficssext}.xml" >>code.xml
        bodyinner "${ficssext}.md" |
          sed "s!src=\"\./latex/latex2png!src=\"###DIRNAME###latex/latex2png!g" |
          sed "s!</*blockquote>!!g" |
          tee -a "${ficssext}.xml" >>code.xml
        echo "</texte>" | tee -a "${ficssext}.xml" >>code.xml
      }

      echo '<pre>' | tee -a "${ficssext}.xml" >>code.xml
      # ajout du corps du code dans "code.xml"
      $ODOC && { # Code provenant de la galerie officielle, il faut le dire !
        echo '/*<asyxml> <html>This code comes from <a href="http://asymptote.sourceforge.net/gallery/">The Official Asymptote Gallery</a></html> </asyxml>*/' | tee -a "${ficssext}.xml" >>code.xml
      }
      preinner "${ficssext}.html" | tee -a "${ficssext}.xml" >>code.xml
      cat >>code.xml <<EOF
</pre>
</code>
EOF

      cat >>"${ficssext}.xml" <<EOF
</pre>
</code>
</asy-code>
EOF
    fi

    cat >>figure.xml <<EOF
<figure number="${i#1}" filename="${ficssext}" \
asyversion="$(sed 's/ \[.*\]//g' ${ficssext}.ver)" $(cat "${ficssext}.format")/>
EOF

    i=$(($i + 1))
  done

  $GENCODE && {
    cat >>code.xml <<EOF
</asy-code>
EOF
  }

  cat >>figure.xml <<EOF
</asy-figure>
EOF

fi

# *=======================================================*
# *................Creation de index.html.................*
# *=======================================================*
if [ "code.xml" -nt "index.html" ] && $GENCODE; then
  echo "Creation de INDEX.HTML dans $(pwd)"
  xsltproc code.xml | sed "s!###URI###!${URIS}!g" >index.html
  sed -i "s/###DIRNAME###//g" index.html
fi

if [ "figure.xml" -nt "figure-index.html" ] || [ "figure.xml" -nt "index.html" ]; then
  if $GENCODE; then
    echo "Creation de FIGURE-INDEX.HTML dans $(pwd)"
    xsltproc figure.xml --stringparam gencode true >figure-index.html
  else
    echo "Creation de INDEX.HTML dans $(pwd)"
    xsltproc figure.xml --stringparam gencode false |
      sed "s!###URI###!${URIS}!g" >index.html
  fi
fi

echo "## The End ##"
