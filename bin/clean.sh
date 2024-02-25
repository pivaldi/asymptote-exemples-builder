#!/bin/bash

# Copyright (C) 2006
# Author: Philippe IVALDI
# Last modified: samedi 30 juin 2007, 13:09:38 (UTC+0200)
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
dest="/home/pi/www/piprime/" # Destination du site LOCAL.
srcasy="/var/www/wordpress/files/asymptote/" # Rep de travail asymptote.
# srcasy="/home/pi/www/local/asymptote/graph3/" # Rep de travail asymptote.
destasy="${dest}asymptote/" # le répertpoire site local pour asymptote

ress_src="/var/www/wordpress/files/res" ##Le répertoire source des ressources HMTL
ress_dest="${dest}res"

## Tous les fichiers et répertoires présents dans COPYDEST
# seront mis à jour depuis COPYSRC.
# Ainsi toute modification dans COPYSRC des fichiers qui sont aussi presents dans
# COPYDEST sera appliquée dans COPYDEST.
COPYSRC="/home/pi/"
COPYDEST="/home/pi/www/piprime/home/pi/"

# destimg="/home/pi/www/multimania/asymptote/" # Les images peuvent être ailleurs!
# urlimg="http://membres.lycos.fr/gdclef/asymptote/"
urlimg=""
destimg=$destasy

# *=======================================================*
# *................Fin de la configuration................*
# *=======================================================*

TMPF="/tmp/filelist"
echo "Voici la liste des fichiers qui vont etre supprime." > "$TMPF"
echo "Utiliser les fleches pour naviguer." >> "$TMPF"
echo "Appuyer sur q pour continuer..." >> "$TMPF"
echo "_______________________________________________________" >> "$TMPF"

function checklist()
{
    bfic=`basename "$1"`

    # Avant de supprimer on fait un dernier test...
    [[ "$bfic" =~ fig[0-9]*\.asy$ ]] && [ -e "${srcasy}${bfic}" ] && {
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!! DANGER, il faut revoir ce script  !!!!!!!!!!!!"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "Tentative de suppression de $1 "
        exit 2
    }
    echo "$1" >> "$TMPF"
}

function cleanLatexToPNG()
{
    dirn=`dirname "$1"`
    cd "$dirn"
    fic=`basename "$1"`
    ficssext=${fic%.*}
    ficfig=`echo "$ficssext" | sed -e "s@latex2png-\(fig[0-9]*\)__.*@\1@g"`
    # echo "fichier muse: ../${ficfig}.muse"
    # !!! Pas de risque d'erreur ici donc pas de tests !!!
    [ "../${ficfig}.muse" -nt "$fic" ] && rm "${fic}"
}

echo "Suppression des latex2png*.png obsolètes..."
echo "!! Pas de demande de confirmation ici !!"
for fic in `find "$srcasy" -name "latex2png*.png" -print` ; do
    cleanLatexToPNG $fic
done


# ------------------------------------------
# * Supprime les traces d'anciens fig*.asy qui n'existent plus

for fic in `find "$srcasy" -name "fig[0-9]*" -print` ; do
    ficssext=${fic%.*}
    ext=${fic##*.}
    # Suppression systématique des log.
    if [ "$ext" == "log" ]; then
        checklist "$fic"
    else
        ficssext_=${ficssext%.*} # extension d'extension: cas des fig*.(asy/gif/swf).html
        ficssextr="${ficssext%r*}" # image réduite de la forme filer.png pour file.asy
        [ ! -e "${ficssext}.asy" ] && [ ! -e "${ficssextr}.asy" ] && [ ! -e "${ficssext_}.asy" ] && {
            checklist "$fic"
        }
    fi
done


# ---------------------------------------------------------
# * Supprime les fichiers de dest qui sont absents de src *
for rep in `find "$destasy" -mindepth 1 -type d -print` ; do
    curd=`echo "$rep" | sed  "s@${destasy}@@g"`
    echo "Cherche dans le répertoire $curd"
    [ "X$curd" != "Xodoc" ] && {
        for fic in `find "${destasy}${curd}" -maxdepth 1 -name "fig[0-9]*" -type f -print` ; do
            bfic=`basename "$fic"`
            [ ! -e "${srcasy}${curd}/${bfic}" ] && checklist $fic
        done
    }
done


# ---------------------------------------------------
# * Visionnage de la liste des fichiers à supprimer *
less "$TMPF"

printf "Voulez-vous supprimer ces fichiers de votre disque ? (N/oui): "
read SUPP

# Arrête si la réponse n'est pas o
[ "X$SUPP" != "Xoui" ] && {
    echo "Aucune suppression n'a été effectuée..."
    exit 1
}

# ------------------------------
# * Suppression des fichiers ! *
[ "X$SUPP" == "Xoui" ] && {
    for fic in `tail --lines=+5 "$TMPF"`; do
        [ -e "$fic" ] && rm "$fic" && echo "suppression de $fic"
        # [ -e "$fic" ] && echo "suppression de $fic"
    done
}