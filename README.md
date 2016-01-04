# zte-openc-add-timekeep-at-boot
Scripts permettant d'ajouter timekeep et de désactiver time_daemon (service Qualcomm) au démarrage du ZTE Open C.  
*Testés sur Debian Wheezy (7.X)*  

Liste des scripts :
- update-bootimage-and-apply-it.sh  

Prérequis:
- ZTE Open C déjà rooté.
- fichier boot.img de l'Open C : Il est récupérable au sein du pack root de ZTE, et/ou dans le dossier zte-openc-switch-bluedroid/update-bootimage/out/ si vous avez exécuté ce dernier.
- Linux installé
- ADB installé, voir ce lien : https://developer.mozilla.org/fr/Firefox_OS/Prerequis_pour_construire_Firefox_OS#Pour_Linux_.3A_configurer_la_r.C3.A8gle_udev_li.C3.A9e_au_t.C3.A9l.C3.A9phone
- **Fichier /system/bin/timekeep présent sur le téléphone**

**Procédure**  
1. Copier le boot.img du pack root ZTE dans le dossier du script.  
2. Donner les droits d'exécution au script update-bootimage-and-apply-it.sh.  
3. Connecter l'Open C à l'ordinateur exécutant le script.  
4. Exécuter update-bootimage-and-apply-it.sh.  


Les fichiers du service timekeep sont disponibles sur https://github.com/mozilla-b2g/timekeep

-------------------------------------------------------

REMARQUE :

La décompilation et la recompilation du fichier boot.img sont effectués à l'aide d'outils tiers : mkbootimg_tools. Un fork de ces outils a été effectué afin de garder la compatibilité avec le boot.img de l'Open C.  
Ces outils sont disponibles dans leurs dernières versions à cette adresse : https://github.com/xiaolu/mkbootimg_tools  


AUTRE REMARQUE :

Ce script a été écrit pour le boot.img d'origine (tel que fournit par ZTE), et pour celui modifié par zte-openc-switch-bluedroid. Il est donc possible qu'il ne fonctionne pas si l'image a été modifié. Dans ce cas, il faudra effectuer les manipulations manuellement.