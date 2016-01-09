#! /bin/bash

###################################
# Application boot.img préparé
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
OUT_FILE=$BASE_DIR/boot_timekeep.img

if [[ $1 == "-h" ||  $1 == "--help" ]]; then
        echo "Ce script permet d'appliquer l'image boot modifié sur l'Open C" &&
        echo &&
        echo "Utilisation : ${BASH_SOURCE[0]}" &&
        exit 0
fi

(
	# Vérification de la présence de l'image modifiée
	if [[ ! -f $OUT_FILE ]]; then
		echo "$0 : Merci d'exécuter le script 1-update-bootimage.sh afin de générer l'image modifiée" && exit 1
	fi
	
	# Vérification de la présence du téléphone
	adb shell getprop >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
			echo "$0 : Merci de connecter l'Open C à cet ordinateur" && exit 1
	fi
	
	# Envoi de l'image boot sur la mémoire interne du téléphone et application de celle-ci
	echo "$0 : Envoi des fichiers sur le téléphone..." &&
	adb push $OUT_FILE /storage/sdcard/btk.img >/dev/null &&
	echo "$0 : Application de la nouvelle image..."
	adb shell dd if=/storage/sdcard/btk.img of=/dev/block/mmcblk0p7 >/dev/null &&
	echo "$0 : Nettoyage..."
	adb shell rm /storage/sdcard/btk.img &&
	
	echo &&
	echo "L'opération a été effectué avec succès ! Il faut redémarrer votre téléphone pour exécuter le service une première fois."
) ||
echo "$0 : Une erreur est survenue."