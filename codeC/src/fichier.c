#include "include/fichier.h"

FILE* modifFichier(FILE* fichier){
    if(fichier == NULL){
        exit(1);
    }
    FILE* fichier_v2 = fopen("c-wire_v00.dat", "w");
    if(fichier_v2 == NULL){
        fclose(fichier);
        exit(2);
    }
    char longueur[100];

    while(fgets(longueur, sizeof(longueur), fichier) != NULL){
    for (int i = 0; longueur[i] != '\0'; i++) {
            if (longueur[i] == '-' && strchr(";\n\0", longueur[i + 1]) && (i == 0 || longueur[i - 1] == ';')) {
                // Si '-' est isolé, remplacer par "-1"
                fputc('-', fichier_v2);
                fputc('1', fichier_v2);
            }else {
                fputc(longueur[i], fichier_v2);
            }
        }   
    }
    fclose(fichier);
    fclose(fichier_v2);

    
    fichier_v2 = fopen("c-wire_v00.dat", "r");
    if (fichier_v2 == NULL) {
        exit(3);
    }

    return fichier_v2;
}

void ajouterValeur(FILE* fichier, Arbre* racine, char* nom_station, int* h) {
    if (fichier == NULL || racine == NULL || nom_station == NULL) {
        exit(5);
    }

    FILE* fichier_v2 = modifFichier(fichier); // Modifier et préparer le fichier
    char longueur_v2[100];
    Donnees* tmp = creationTMP(); 

    while (fgets(longueur_v2, sizeof(longueur_v2), fichier_v2)) {
        
        if (sscanf(longueur_v2, "%lu;%lu;%lu;%lu;%lu;%lu;%lu;%lu",&tmp->centrale, &tmp->hvb, &tmp->hva, &tmp->lv, &tmp->entrp, &tmp->partc, &tmp->conso, &tmp->produc) == 8) {

          
            Type type = verifStation(tmp);

         
            switch (type) {
                case lv:
                    tmp->id = tmp->lv;
                    *racine = insertAVL(*racine, *tmp, *h); 
                    break;

                case hv_b:
                    tmp->id = tmp->hvb;
                    *racine = insertAVL(*racine, *tmp, *h); 
                    break;

                case hv_a:
                    tmp->id = tmp->hva;
                    *racine = insertAVL(*racine, *tmp, *h);
                    break;

               
                default:
                    printf("Station inconnu");
                    break;
            }
        } else {
            printf("Erreur de traitement pour la ligne : %s\n", longueur_v2);
        }
    }

    fclose(fichier_v2);
    free(tmp);
}