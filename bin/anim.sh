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
# *................Variables � configurer.................*
# *=======================================================*

EXTIMAG="png" #format des images sorties
EXTASY="pdf"  #format de sortie de asy
              # sauf si le code contient le mot "opacity"

# ASY_CMD=/usr/local/asymptote/bin/asy
# ASYOPTION="-render=8 -noprc -maxtile=\(900,900\) -glOptions=-iconic "
# ASYOPTION=" -render=0 -maxviewport=1000 -noprc "
ASYOPTION="-render=8 -noprc -glOptions=-iconic "
## R�pertoire racine (utilis� pour r�cup�rer les chemins relatifs)
## Doit se terminer par un '/'.
RACINE="/home/pi/www/local/asymptote/"

## Le r�pertoire o� se trouve les ressources html (.xsl, .css, favicon...)
## Relatif � RACINE.
RESSOURCES="../ressources/" # Doit se terminer par un '/'

tuxftp="/home/pi/www/tuxftp/animations/" # le r�pertoire pour les animations (.gif et .swf lourds)

# *=======================================================*
# *................Fin de la configuration................*
# *=======================================================*

## Le chemin relatif du r�pertoire racine par
## rapport au r�pertoire courant (il se termine par un '/').
REL=`pwd | sed "s�$RACINE��" | sed "s�[^/]*�..�g"`"/"

RES=${REL}${RESSOURCES}

while true
do
    case $1 in
        -gif)
	    EXTIMAG="gif"
            ;;
        -png)
	    EXTIMAG="png"
            ;;
        -pdf)# Force l'utilisation du pdf
            EXTASY="pdf"
            ;;
        *)
            break
            ;;
    esac
    shift
done


# R�cup�re le texte qui se trouve entre les balises <body> et </body>
function bodyinner()
{
    cat $1 | awk -v FS="^Z" "/<body>/,/<\/body>/" | sed "s/<\/*body>//g"
}

function pdf2png()
{
    echo "G�n�ration du png de pr�sentation depuis ${1}.pdf."
    convert -density 200 -resample 96 -quality 75 -depth 8 -strip "${1}.pdf" "${2}.png"
}

function createswf()
{
    origdir=`pwd`
    if ls _${1}*.pdf 2>/dev/null ;then # Pr�sence de fichier(s) auxiliaire(s)
        echo "Fichiers auxiliaires pdf d�tect�s."
        if [ -e  "_${1}.pdf" ]; then
            echo "Le fichier auxiliaire est d�j� anim�."
            mv "_${1}.pdf" "${1}.pdf"
               # "G�n�ration du png de pr�sentation."
            I=$(pdfinfo -meta ${1}.pdf | grep "Pages" |sed "s/Pages: *//g")
            I=$(( 3*I/4 ))
            pdftk A="${1}.pdf" cat A$I output "${1}_first.pdf"
            pdf2png "${1}_first" "$1" && rm "${1}_first.pdf"
        else # Il faut assembler les pdf auxiliaires
            FIGSpdf=""
            NB=0
            for I in `find -maxdepth 1 -name "_$1*[0-9].pdf"\
 | sed "s/.\/_$1\([0-9]*\).pdf/\1/g" |sort -n`; do
                FIGSpdf="${FIGSpdf} _${1}${I}.pdf"
                NB=$(( NB+1 ))
            done
            echo "Assemblage des pdf."
            pdftk $FIGSpdf cat output $1.pdf
            echo "G�n�ration du png de pr�sentation."
            I=$(( 3*NB/4 ))
            pdf2png "_${1}${I}" "${1}"
        fi
        find -maxdepth 1 -name "_${1}[0-9]*.eps" -o -name "_${1}[0-9]*.pdf" -exec rm {} \;
        [ -e "${1}.gif" ] && rm "${1}.gif"
    else
        if [ -e "${1}.pdf" ]; then # le fichier pdf de base existe et est anim�
            I=$(pdfinfo -meta ${1}.pdf | grep "Pages" |sed "s/Pages: *//g")
            I=$(( 3*I/4 ))
            pdftk A="${1}.pdf" cat A$I output "${1}_first.pdf"
            pdf2png "${1}_first" "$1" && rm "${1}_first.pdf"
        fi
    fi
    if [ -e "${1}.pdf" ]; then #Animation vectoriel
        printf "Red�coupage du pdf..."
        find -maxdepth 1 -name "pg*.pdf" -exec rm {} \;
        pdftk "$1.pdf" burst && echo "FAIT."
        printf "G�n�rarion du .gif..."
        convert -delay 10 -loop 0 pg*.pdf "${1}.gif" && echo "FAIT."
        rm pg*.pdf
        printf "G�n�ration du swf temporaire"
        pdf2swf "$1.pdf" -s zoom=96 -o temp.swf > pdf2swf.log && echo " ... FAIT"
#     out=`cat pdf2swf.log | egrep -m1 "[0-9]+x"`
#     width=$(echo $out | awk -F"[()x:]" '{print $2}')
#     height=$(echo $out | awk -F"[()x:]" '{print $3}')
#     echo "width=$width ; height=$height"
        mv temp.swf "${RES}"
        cd "${RES}"
        printf "G�n�ration du swf d�finitif"
        swfcombine -r 10 -dz temp.swf -o temptemp.swf && mv temptemp.swf temp.swf
        swfc -o "$1.swf" navigationswf.sc && echo " ... FAIT"
        rm temp.swf
        mv "$1.swf" "${origdir}/"
        cd "${origdir}/"

        cat>"$1.swf.html"<<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>${1}.swf</title>
</head>
<body>
<center>
EOF
        swfdump -E "$1.swf" >> "$1.swf.html"
        cat>>"$1.swf.html"<<EOF
</center>
</body>
</html>
EOF
    else #Seul le gif existe, le swf ne sera pas disponible
        echo "G�n�ration du png de pr�sentation � partir de ${1}.gif"
        convert "$1.gif" tmp.png
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


CREATECODE=false # Par d�faut il n'y a pas � recr�er code.xml et index.html

# Quelques expressions rationnelles utilis�es pour modifier le html g�n�r�.
#         IMPORTa="\(<span class=\"builtin\">import<\/span>\) *\([a-zA-Z0-9]*_pi\);"
#         IMPORTb="\(<span class=\"builtin\">import<\/span>\) *\([a-zA-Z0-9_]*_dev\);"
IMPORTc="\(<span class=\"builtin\">import<\/span>\) *Lsystem"

# Provisoirement, j'ai besoin de modifier 'import geo_dev' en 'import geometry_dev'
COMA="s�geo_dev;�<a href=\"modules/geometry_dev.asy\">geometry_dev</a>;�g"
# Le fichier Lsystem.asy est parfois n�cessaire pour compiler des exemples.
# On remplace Lsystem; par une lien pour le t�l�charger.
COMB="s�${IMPORTc}�\1 <a href=\"http://piprim.tuxfamily.org/asymptote/lsystem/Lsystem.asy\">Lsystem</a>�g"
COMD="/syracuse/d"


for fic in `ls fig*.asy  2>/dev/null |sort` ; do
    ficssext=${fic%.*}
    ficssext=`basename $ficssext`
# le tag ADDPDF permet de mettre un lien vers le fichier .pdf
    COMC="s/ADDPDF/<a href=\"${ficssext}.pdf\">${ficssext}.pdf<\/a>/g"
# *=======================================================*
# *..Cr�ation du fichier .html � partir du fichier .asy...*
# *=======================================================*
    if [ "${fic}" -nt "${fic}.html" ]; then
        CREATECODE=true ## Il faudra recr�er le .xml
        echo "Convertion en html de ${ficssext}.asy"
        emacsclient.emacs22 -e '(htmlize-file "'`pwd`'/'`basename ${fic}`'")'

        # Modification du html
        cat ${ficssext}.asy.html | sed -e "$COMA;$COMB;$COMC;$COMD" > "${ficssext}_tmp" && mv "${ficssext}_tmp" "${ficssext}.asy.html"

    fi

# *=======================================================*
# *..............Compilation des .asy r�cents.............*
# *=======================================================*
    echo "format_img=\"${EXTIMAG}\" format_out=\"${EXTASYTMP}\" \
        animation=\"false\"" > "${ficssext}.format"
    if [ "${ficssext}.asy" -nt "${ficssext}.gif" ]; then
	COMM="LC_NUMERIC=\"french\" $ASY_CMD $ASYOPTION ${ficssext}"
        echo ${COMM}
        eval "$COMM && $ASY_CMD --version &> \"${ficssext}.ver\""
    fi
    if [ "${fic}" -nt "${ficssext}.png" ] ; then
        createswf "${ficssext}"
    fi
done

# *=======================================================*
# *..................Cr�ation des index...................*
# *=======================================================*
[ ! -e code.xml ] && CREATECODE=true
if $CREATECODE; then

    echo "Cr�ation de CODE.XML dans `pwd`"

# ---------------
# * Les ent�tes *
    cat>code.xml<<EOF
<?xml version="1.0" ?>
<?xml-stylesheet type="text/xsl" href="${RES}anim2html.xsl" ?>
<asy-code title="Asy - `cat title`" date="`LANG=US date`" resource="${RES}">
<presentation>`cat presentation`</presentation>
EOF

    cat>figure.xml<<EOF
<?xml version="1.0" ?>
<?xml-stylesheet type="text/xsl" href="${RES}figureanim2html.xsl" ?>
<asy-figure title="Pic - `cat title`" date="`LANG=US date`" resource="${RES}">
<presentation>`cat presentation`</presentation>
EOF

# -----------
# * Le code *
    i=10001
    for fic in `ls fig*.asy  2>/dev/null | sort` ; do
        ficssext=${fic%.*}
        ficssext=`basename $ficssext`
        width="none"
        height="none"
        if grep -E -q "syracuse" ${ficssext}.asy ; then
            width="syracuse" # l'animation est pr�sente sur le site Syracuse
        else
            if [ -e "${ficssext}.swf" ]; then
                width=`swfdump --width "${ficssext}.swf" |awk -F"[ ]" '{print $2}'`
                width=$(( width+10 ))
                height=`swfdump --height "${ficssext}.swf" |awk -F"[ ]" '{print $2}'`
                height=$(( height+10 ))
            fi
        fi
        cat>>code.xml<<EOF
<code number="${i#1}" filename="${ficssext}" \
asyversion="`sed 's/ \[.*\]//g' ${ficssext}.ver`" `cat "${ficssext}.format"` \
width="${width}" height="${height}">
EOF
    # ajout du corps du code dans "code.xml"
        bodyinner $ficssext.asy.html >>code.xml
        cat>>code.xml<<EOF
</code>
EOF

# ---------------
# * Les figures *
        cat>>figure.xml<<EOF
<figure number="${i#1}" filename="${ficssext}" \
asyversion="`sed 's/ \[.*\]//g' ${ficssext}.ver`" `cat "${ficssext}.format"` \
width="${width}" height="${height}"/>
EOF

        i=$[$i+1]
    done

    cat>>code.xml<<EOF
</asy-code>
EOF

    cat>>figure.xml<<EOF
</asy-figure>
EOF

fi

# *=======================================================*
# *................Cr�ation de index.html.................*
# *=======================================================*
if [ "code.xml" -nt "index.html" ]; then
    echo "Cr�ation de INDEX.HTML dans `pwd`"
    xsltproc code.xml > index.html
    echo "Cr�ation de FIGURE-INDEX.HTML dans `pwd`"
    xsltproc figure.xml > figure-index.html
fi

echo "## Termin� ##"
