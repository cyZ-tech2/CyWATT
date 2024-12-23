#!/bin/bash

# Retourne un message d'aide
aide(){
 	echo "Aide : "
	echo "Commande : ./c-wire.sh [ARGUMENT] [OPTION]" //à voir
	echo "ARGUMENT :"
	echo "ARG[1] : Fichier d'entrée"
	echo "ARG[2] : Type de station (hvb, hva ou lv)"
	echo "ARG[3] : Type de consommateur (comp, indiv ou all)"
	echo "ARG[4] : (Optionnel) : l'ID de la centrale électrique"
	echo "OPTION :"
	echo "-h pour accéder à l'aide de cette commande"
	return 0
}

# On récupère la date du début du programme
debut=$(date +%s)

# Retourne le temps écoulé depuis le début du programme
duree(){
	fin=$(date +%s) #récupère la date de fin
	duree=$(( $fin - $debut )) #on calcule la durée du programme
	echo "$duree secondes"
	return 0
}

	# Vérification arguments

for i in $*; do # vérifie si l'argument -h est présent
	if [ "$i" = "-h" ] ; then
		aide
		duree
		exit 0
	fi
done

if ([[ "$1" != *.csv ]] && [[ "$1" != *.dat ]]) || [ ! -f "$1" ] ; then # verif fichier de donnees
	echo "fichier d'entrée invalide"
	aide
	duree
	exit 1

elif [ "$2" != "hvb" ] && [ "$2" != "hva" ] && [ "$2" != "lv" ] ; then   # verif type de station
	echo "type de station invalide"
	aide
	duree
	exit 1

elif [ "$3" != "comp" ] && [ "$3" != "indiv" ] && [ "$3" != "all" ] ; then # verif type de consommateur
	echo "type de consommateur invalide"
	aide
	duree
	exit 1

elif [[ "$*" = *hv?' 'all* ]] || [[ "$*" = *hv?' 'indiv* ]] ; then # verif option authorisée
	echo "option non autorisée"
	aide
	duree
	exit 1
fi

if [ ! -d tmp ] ; then # verif dossier tmp
	mkdir tmp
else
	rm -rf tmp/*
fi

if [ ! -d tests ] ; then # verif dossier tests
	mkdir tests
else
	rm -rf tests/*
fi

if [ ! -d graphs ] ; then # verif dossier graphs
	mkdir graphs
else
	rm -rf graphs/*
fi


echo "Bienvenue sur "
echo "      ::::::::  :::   ::: :::       :::     ::: ::::::::::: ::::::::::: ";
echo "    :+:    :+: :+:   :+: :+:       :+:   :+: :+:   :+:         :+:      ";
echo "   +:+         +:+ +:+  +:+       +:+  +:+   +:+  +:+         +:+       ";
echo "  +#+          +#++:   +#+  +:+  +#+ +#++:++#++: +#+         +#+        ";
echo " +#+           +#+    +#+ +#+#+ +#+ +#+     +#+ +#+         +#+         ";
echo "#+#    #+#    #+#     #+#+# #+#+#  #+#     #+# #+#         #+#          ";
echo "########     ###      ###   ###   ###     ### ###         ###           ";
echo ""

echo "Nous filtrons vos données..."

# On filtre les données à l'aide de grep en spécifiant le format correspondant au type de station et au type de conso voulu
# Ensuite on garde uniquement les champs utiles au traitement des données (id station, capacité et consommation)
# Enfin on met les données filtrées dans un fichier temporaire
case $2 in
	hvb) if [ $# = 4 ] ; then # On vérifie si une centrale particulière est demandée
		grep "^$4;[^-;]*;-;-;-;-" "$1" | cut -d ';' -f 2,7 > "tmp/filtreStation.csv" 
		grep "^$4;[^-;]*;-;-;[^-;]*;-" "$1" | cut -d ';' -f 2,8  > "tmp/filtreConso.csv" 
	else
		grep "^[^-;]*;[^-;]*;-;-;-;-" "$1" | cut -d ';' -f 2,7 > "tmp/filtreStation.csv" 
		grep "^[^-;]*;[^-;]*;-;-;[^-;]*;-" "$1" | cut -d ';' -f 2,8  > "tmp/filtreConso.csv" 
	fi
	;;
	hva) if [ $# = 4 ] ; then
		grep "^$4;[^-;]*;[^-;]*;-;-;-" "$1" | cut -d ';' -f 3,7 > "tmp/filtreStation.csv" 
		grep "^$4;-;[^-;]*;-;[^-;]*;-" "$1" | cut -d ';' -f 3,8 > "tmp/filtreConso.csv" 
	else
		grep "^[^-;]*;[^-;]*;[^-;]*;-;-;-" "$1" | cut -d ';' -f 3,7 > "tmp/filtreStation.csv" 
		grep "^[^-;]*;-;[^-;]*;-;[^-;]*;-" "$1" | cut -d ';' -f 3,8 > "tmp/filtreConso.csv" 
	fi
	;;
	lv) if [ $# = 4 ] ; then
		grep "^$4;-;[^-;]*;[^-;]*;-;-" "$1" | cut -d ';' -f 4,7 > "tmp/filtreStation.csv" 
		case $3 in
			all) grep "^$4;-;-;[^-;]*;" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
			comp) grep "^$4;-;-;[^-;]*;[^-;]*;-" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
			indiv) grep "^$4;-;-;[^-;]*;-;[^-;]*;" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
		esac	
	else
		grep "^[^-;]*;-;[^-;]*;[^-;]*;-;-" "$1" | cut -d ';' -f 4,7 > "tmp/filtreStation.csv" 
		case $3 in
			all) grep "^[^-;]*;-;-;[^-;]*;" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
			comp) grep "^[^-;]*;-;-;[^-;]*;[^-;]*;-" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
			indiv) grep "^[^-;]*;-;-;[^-;]*;-;[^-;]*;" "$1" | cut -d ';' -f 4,8 > "tmp/filtreConso.csv" 
			;;
		esac
	fi
	;;
esac

echo "Filtrage terminé !"

echo "Nous trions vos données..."

# On trie les données pour s'assurer qu'elles soient bien triées par ordre de station
sort -t';' -k1n < "tmp/filtreStation.csv" 1<> "tmp/filtreStation.csv"
sort -t';' -k1n < "tmp/filtreConso.csv" 1<> "tmp/filtreConso.csv" 

echo "Tri terminé !"

echo "Nous traitons vos données"

# On lance le programme de traitement

if [ ! -x 'codeC/exec' ] ; then #verif executable C
	make -C codeC
fi

if [ $# = 4 ] ; then
	./codeC/exec tests/$2_$3_$4.csv $2 $3 $4
else
	./codeC/exec tests/$2_$3.csv $2 $3
fi

echo "Traitement terminé !"

# On créé le fichier minmax et le graph dans le cas du traitement lv all
if [ "$2" = "lv" ] && [ "$3" = "all" ] && [ $# = 3 ]; then
	sort -t ':' -k3n < "tmp/minmaxTmp.csv" 1<> "tmp/minmaxTmp.csv"
	echo "Station lv:Capacité:Consommation (all)" > "tests/lv_all_minmax.csv"
	(head -n 10 && tail -n 10) < "tmp/minmaxTmp.csv" | sort -t':' -k4n | cut -d ':' -f 1-3 >> "tests/lv_all_minmax.csv"
	gnuplot fichier.gnu
fi

echo "Le programme à duré :" &duree