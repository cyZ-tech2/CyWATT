#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TAMPON 126 // Taille à voir 


int main(){
FILE* fichier = NULL;
char longueur[MAX_TAMPON];

fichier = fopen("c-wire_v00.dat", "r");
if (fichier == NULL){
    printf("Erreur fopen");
    exit(1);
}


if(fgets(longueur, MAX_TAMPON, fichier) == NULL){
    printf("Erreur fgets");
    fclose(fichier);
    exit(2);
}

while(fgets(longueur, MAX_TAMPON, fichier) != NULL){
    int powerPlant, hvB, hvA, lv, capacity, load;   // à revoir 
    char company[50], individual[50];


  int result = sscanf(longueur, "%d;%d;%d;%d;%[^;];%[^;];%d;%d", &powerPlant, &hvB, &hvA, &lv, company, individual, &capacity, &load);

        if (result >= 6) {
            
            company[49] = '\0';
            individual[49] = '\0';

         
            traiterDonnees(powerPlant, hvB, hvA, lv, capacity, load);
        } else {
            printf("Erreur traitement de données");
        }
    }
    fclose(fichier);
    exit(3);
}

void afficheDonnees(int powerPlant, int hvB, int hvA, int lv, int capacity, int load){
    printf("")
}

void traiterDonnees(int powerPlant, int hvB, int hvA, int lv, int capacity, int load) {
    if (capacity > 1000000000) {
        printf("PowerPlant: %d, Capacity: %d, Load: %d\n", powerPlant, capacity, load);
    }
}