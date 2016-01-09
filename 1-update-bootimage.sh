#! /bin/bash

###################################
# Préparation boot.img pour Open C
# Copyright (C) 2016 micgeri (https://github.com/micgeri)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
###################################


### Variables ###
BASE_DIR=`dirname $(readlink -f $0)`
MKBOOT_DIR=$BASE_DIR/mkbootimg_tools-bootimg-openc-ok
TMP_DIR=$BASE_DIR/tmp
TESTW_FILE=$BASE_DIR/testwrite
OUT_FILE=$BASE_DIR/boot_timekeep.img

if [[ $1 == "-h" ||  $1 == "--help" ]]; then
        echo "Ce script permet de modifier l'image boot du ZTE Open C, afin d'exécuter le service timekeep au démarrage" &&
        echo &&
        echo "Utilisation : ${BASH_SOURCE[0]}" &&
        echo "Le fichier boot.img doit être placé dans $BASE_DIR" &&
        exit 0
fi

(
	# Vérification des droits en écriture sur le dossier courant
	(touch $TESTW_FILE 2>/dev/null && rm $TESTW_FILE 2>/dev/null) || (echo "$0 : Merci de donner les droits en écriture au dossier de ce script" && exit)

	# Vérification de l'existence du fichier boot.img
	if [[ ! -f boot.img ]]; then
		echo "$0 : Merci de copier le fichier boot.img du pack root dans le dossier $BASE_DIR" && exit
	fi

	# Re-création de la structure
	rm -rf $TMP_DIR && mkdir $TMP_DIR &&

	# Récupération de l'utilitaire mkboot, si nécessaire
	if [[ ! -d $MKBOOT_DIR && ! -f $BASE_DIR/mkboot.zip ]]; then
		echo "$0 : Téléchargement et extraction des outils mkboot..." &&
		(wget -nv -O $BASE_DIR/mkboot.zip https://github.com/micgeri/mkbootimg_tools/archive/bootimg-openc-ok.zip && unzip $BASE_DIR/mkboot.zip -d $BASE_DIR >/dev/null) || (echo "$0 : Impossible de télécharger l'utilitaire mkboot" && exit 1)
	elif [[ ! -d $MKBOOT_DIR ]]; then
		echo "$0 : Extraction des outils mkboot..." &&
		unzip $BASE_DIR/mkboot.zip >/dev/null
	fi

	# Préparation de l'image de boot
	# Extraction
	echo "$0 : Extraction de l'image de boot original..." &&
	$MKBOOT_DIR/mkboot $BASE_DIR/boot.img $TMP_DIR/boot &&
	echo "$0 : Ajout des éléments pour la nouvelle image..." &&
	# Application du patch
	cd $TMP_DIR &&
	patch -p1 < $BASE_DIR/set-timekeep-disable-time_daemon.patch &&
	# Compilation de la nouvelle image
	echo "$0 : Création de la nouvelle image de boot..." &&
	$MKBOOT_DIR/mkboot $TMP_DIR/boot $OUT_FILE &&
	
	echo &&
	echo "L'opération a été effectué avec succès ! Merci d'exécuter le script 2-apply-bootimage.sh afin d'appliquer l'image modifiée sur l'Open C."
) ||
echo "$0 : Une erreur est survenue."