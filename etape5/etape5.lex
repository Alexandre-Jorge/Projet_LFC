%{
	#include <stdio.h>
    #include "y.tab.h"
    #include "header.h"

    #define EVT -1
    #define UNIQ -2
    #define REPET -3
    #define JOUR -4
    #define ALARM -5
    #define DAT -6
    #define TXT -7
    #define FRQC -8
    #define CPT -9
    #define LSTJ -10
    #define DEBUT -11
    #define FIN -12
    #define DESCR -13
    #define LIEU -14
    #define TITRE -15

    matrix table1;
    char * table2;

    int line = 0;
    int ind = 0;
    int totalLength = 0;

        
    void addEVT(int type)
    {
        table1[line][0] = EVT;
        table1[line][1] = type;
        ind = line;
        line++;
    }

    void addTable(int value ,char* text, int length)
    {
        int realLength = 0;
        table1[line][0] = value;
        table1[line][2] = ind;
        table1[line][3] = totalLength;
        for(int i = 0; i < length; i++){
            if(text[i] != '\r'){
                table2[totalLength] = text[i];
                totalLength++;
                realLength++;
            }
        }
        table1[line][4] = realLength;
        line++;
    }

    void displayTab()
    {
        for(int i = 0; i < line; i++){
            for(int j = 0; j < 5; j++){
                switch(table1[i][j]) {
                    case EVT :
                        printf("EVT\t");
                        break;
                    case UNIQ :
                        printf("UNIQ\t");
                        break;
                    case REPET :
                        printf("REPET\t");
                        break;
                    case JOUR :
                        printf("JOUR\t");
                        break;
                    case ALARM :
                        printf("ALARM\t");
                        break;
                    case DAT :
                        printf("DAT\t");
                        break;
                    case TXT :
                        printf("TXT\t");
                        break;
                    case FRQC :
                        printf("FRQC\t");
                        break;
                    case CPT :
                        printf("CPT\t");
                        break;
                    case LSTJ :
                        printf("LSTJ\t");
                        break;
                    case DEBUT :
                        printf("DEBUT\t");
                        break;
                    case FIN :
                        printf("FIN\t");
                        break;
                    case DESCR :    
                        printf("DESCR\t");
                        break;
                    case LIEU :
                        printf("LIEU\t");
                        break;
                    case TITRE :
                        printf("TITRE\t");
                        break;
                    default : 
                        printf("%d\t", table1[i][j]);
                }
            }
            printf("\n");
        }
        
        printf("\n%s\n", table2);
    }
    void toDate_heure(char * date_heure){
        char * aaaa = malloc(sizeof(char)*4);
        char * mm = malloc(sizeof(char)*2);
        char * jj = malloc(sizeof(char)*2);
        char * hh = malloc(sizeof(char)*2);
        char * mn = malloc(sizeof(char)*2);
        char * ss = malloc(sizeof(char)*2);
        for(int i = 0; i < 4; i++){
            aaaa[i] = date_heure[i];
        }
        for(int i = 0; i < 2; i++){
            mm[i] = date_heure[i+4];
            jj[i] = date_heure[i+6];
            hh[i] = date_heure[i+9];
            mn[i] = date_heure[i+11];
            ss[i] = date_heure[i+13];
        }
        strcpy(date_heure, aaaa);
        strcat(date_heure, "/");
        strcat(date_heure, mm);
        strcat(date_heure, "/");
        strcat(date_heure, jj);
        strcat(date_heure, " ");
        strcat(date_heure, hh);
        strcat(date_heure, ":");
        strcat(date_heure, mn);
        strcat(date_heure, ":");
        strcat(date_heure, ss);
    }
    void toDate(char * date_heure){
        char * aaaa = malloc(sizeof(char)*4);
        char * mm = malloc(sizeof(char)*2);
        char * jj = malloc(sizeof(char)*2);
        for(int i = 0; i < 4; i++){
            aaaa[i] = date_heure[i];
        }
        for(int i = 0; i < 2; i++){
            mm[i] = date_heure[i+4];
            jj[i] = date_heure[i+6];
        }
        strcpy(date_heure, aaaa);
        strcat(date_heure, "/");
        strcat(date_heure, mm);
        strcat(date_heure, "/");
        strcat(date_heure, jj);
    }

    void toFreq(char * freq){
        switch(freq[0]){
            case 'D':
                strcpy(freq, "jour");
                break;
            case 'W':
                strcpy(freq, "semaine");
                break;
            case 'M':
                strcpy(freq, "mois");
                break;
            case 'Y':
                strcpy(freq, "année");
                break;
        }
    }
    void toList_jours(char * list_jours){
        char * res = malloc(sizeof(char)*100);
        for(int i=0; i<strlen(list_jours); i+=3){
            switch(list_jours[i]){
                case 'S' :
                    if(list_jours[i+1] == 'U'){
                        strcat(res, "dimanche ");
                    }
                    else if(list_jours[i+1] == 'A'){
                        strcat(res, "samedi ");
                    }
                    break;
                case 'M' :
                    strcat(res, "lundi ");
                    break;
                case 'T' :
                    if(list_jours[i+1] == 'U'){
                        strcat(res, "mardi ");
                    }
                    else if(list_jours[i+1] == 'H'){
                        strcat(res, "jeudi ");
                    }
                    break;
                case 'W' :
                    strcat(res, "mercredi ");
                    break;
                case 'F' :
                    strcat(res, "vendredi ");
                    break;
            }
        }
        strcpy(list_jours, res);
    }

    void toHTML(){
        int nbEvtUniq = 0;
        int nbEvtRepet = 0;
        int nbEvtJour = 0;
        FILE *fichier = fopen("etape5.html", "w");
        fprintf(fichier, "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\" />\n<title>Etape 5</title>\n</head>\n<body>\n");
        for(int i=0;i<line;i++){
            if(table1[i][0] == EVT){
                int j = 1;
                int nbAlarmes = 0;
                int date_et_heure_limite_bool = 0;
                char * date_et_heure_debut = malloc(sizeof(char)*16);
                char * date_et_heure_fin = malloc(sizeof(char)*16);
                char * titre = malloc(sizeof(char)*240);
                char * lieu = malloc(sizeof(char)*240);
                char * description = malloc(sizeof(char)*240);
                char * frequence = malloc(sizeof(char)*10);
                char * liste_jours = malloc(sizeof(char)*100);
                char * nombre_de_fois = malloc(sizeof(char)*10);
                char * date_et_heure_limite = malloc(sizeof(char)*16);
                char ** alarmes = malloc(sizeof(char*)*10);
                for(int k = 0; k < 10; k++){
                    alarmes[k] = malloc(sizeof(char)*16);
                }
                while(table1[i+j][2] == i){
                    if(table1[i+j][0] == DAT){
                        if(table1[i+j][1] == DEBUT){
                            date_et_heure_debut[0] = '\0';
                            for(int k = 0; k < table1[i+j][4]; k++){
                                date_et_heure_debut[k] = table2[table1[i+j][3]+k];
                            }
                            date_et_heure_debut[table1[i+j][4]] = '\0';
                        }
                        else if(table1[i+j][1] == FIN){
                            date_et_heure_fin[0] = '\0';
                            for(int k = 0; k < table1[i+j][4]; k++){
                                date_et_heure_fin[k] = table2[table1[i+j][3]+k];
                            }
                            date_et_heure_fin[table1[i+j][4]] = '\0';
                        }
                        else if(table1[i+j][1] == 0){
                            date_et_heure_limite[0] = '\0';
                            date_et_heure_limite_bool = 1;
                            for(int k = 0; k < table1[i+j][4]; k++){
                                date_et_heure_limite[k] = table2[table1[i+j][3]+k];
                            }
                            date_et_heure_limite[table1[i+j][4]] = '\0';
                        }
                    }
                    else if(table1[i+j][0] == TXT){
                        if(table1[i+j][1] == TITRE){
                            titre[0] = '\0';
                            for(int k = 0; k < table1[i+j][4]; k++){
                                titre[k] = table2[table1[i+j][3]+k];
                            }
                            titre[table1[i+j][4]] = '\0';
                        }
                        else if(table1[i+j][1] == LIEU){
                            lieu[0] = '\0';
                            for(int k = 0; k < table1[i+j][4]; k++){
                                lieu[k] = table2[table1[i+j][3]+k];
                            }
                            lieu[table1[i+j][4]] = '\0';
                        }
                        else if(table1[i+j][1] == DESCR){
                            description[0] = '\0';
                            for(int k = 0; k < table1[i+j][4]; k++){
                                description[k] = table2[table1[i+j][3]+k];
                            }
                            description[table1[i+j][4]] = '\0';
                        }
                    }
                    else if(table1[i+j][0] == FRQC){
                        frequence[0] = '\0';
                        for(int k = 0; k < table1[i+j][4]; k++){
                            frequence[k] = table2[table1[i+j][3]+k];
                        }
                        frequence[table1[i+j][4]] = '\0';
                    }
                    else if(table1[i+j][0] == CPT){
                        nombre_de_fois[0] = '\0';
                        for(int k = 0; k < table1[i+j][4]; k++){
                            nombre_de_fois[k] = table2[table1[i+j][3]+k];
                        }
                        nombre_de_fois[table1[i+j][4]] = '\0';
                    }
                    else if(table1[i+j][0] == LSTJ){
                        liste_jours[0] = '\0';
                        for(int k = 0; k < table1[i+j][4]; k++){
                            liste_jours[k] = table2[table1[i+j][3]+k];
                        }
                        liste_jours[table1[i+j][4]] = '\0';
                    }
                    else if(table1[i+j][0] == ALARM){
                        alarmes[nbAlarmes][0] = '\0';
                        for(int k = 0; k < table1[i+j][4]; k++){
                            alarmes[nbAlarmes][k] = table2[table1[i+j][3]+k];
                        }
                        alarmes[nbAlarmes][table1[i+j][4]] = '\0';
                        nbAlarmes++;
                    }
                    j++;
                }
                switch(table1[i][1]){
                    case UNIQ :
                        nbEvtUniq++;
                        toDate_heure(date_et_heure_debut);
                        toDate_heure(date_et_heure_fin);
                        fprintf(fichier, "<div style=\"color: black;\">\n");
                        fprintf(fichier, "<h1>Du %s au %s</h1>\n", date_et_heure_debut, date_et_heure_fin);
                        break;
                    case REPET :
                        nbEvtRepet++;
                        toDate_heure(date_et_heure_debut);
                        toDate_heure(date_et_heure_fin);
                        fprintf(fichier, "<div style=\"color: green;\">\n");
                        fprintf(fichier, "<h1>Du %s au %s</h1>\n", date_et_heure_debut, date_et_heure_fin);
                        break;
                    case JOUR :
                        nbEvtJour++;
                        toDate(date_et_heure_debut);
                        fprintf(fichier, "<div style=\"color: red;\">\n");
                        fprintf(fichier, "<h1>Le %s, toute la journée</h1>\n", date_et_heure_debut);
                        break;
                }
                if(strlen(titre) > 0){
                    fprintf(fichier, "<h2>%s</h2>\n", titre);
                }
                else {
                    fprintf(fichier, "<h2>Sans titre</h2>\n");
                }
                if(strlen(lieu) > 0){
                    fprintf(fichier, "<p>%s</p>\n", lieu);
                }
                else {
                    fprintf(fichier, "<p>Pas de lieu</p>\n");
                }
                if(strlen(description) > 0){
                    fprintf(fichier, "<p>%s</p>\n", description);
                }
                else {
                    fprintf(fichier, "<p>Pas de description</p>\n");
                }
                if(table1[i][1] == REPET){
                    toFreq(frequence);
                    fprintf(fichier, "<p>Doit se répéter chaque %s, ", frequence);
                    if(date_et_heure_limite_bool){
                        toDate_heure(date_et_heure_limite);
                        fprintf(fichier, "jusqu'au %s</p>\n", date_et_heure_limite);
                    }
                    else {
                        toList_jours(liste_jours);
                        fprintf(fichier, "les %s, %s fois</p>\n", liste_jours, nombre_de_fois);
                    }
                }
                if(nbAlarmes > 0){
                    fprintf(fichier, "<p>Alarmes définies : %s", alarmes[0]+5);
                    for(int k = 1; k < nbAlarmes; k++){
                        fprintf(fichier, ", %s", alarmes[k]+5);
                    }
                    fprintf(fichier, "</p>\n");
                }
                fprintf(fichier, "</div>\n");
                fprintf(fichier, "<br/>\n");
                free(date_et_heure_debut);
                free(date_et_heure_fin);
                free(date_et_heure_limite);
                free(titre);
                free(lieu);
                free(description);
                free(frequence);
                free(nombre_de_fois);
                free(liste_jours);
                for(int k = 0; k < 10; k++){
                    free(alarmes[k]);
                }
                free(alarmes);
            }
        }
        fprintf(fichier, "<p>%d événements au total dont :</p>\n", nbEvtUniq+nbEvtRepet+nbEvtJour);
        fprintf(fichier, "<ul>\n");
        fprintf(fichier, "<li>%d événements uniques</li>\n", nbEvtUniq);
        fprintf(fichier, "<li>%d événements répétitifs</li>\n", nbEvtRepet);
        fprintf(fichier, "<li>%d événements à la journée</li>\n", nbEvtJour);
        fprintf(fichier, "</ul>\n");
        fprintf(fichier, "</body>\n");
        fprintf(fichier, "</html>\n");
        fclose(fichier);
    }
%}

%start LIGNEOK
%start DATEUOK
%start DATEROK
%start DATEJOK
%start NBOK
%start JOUROK
%start ALARMOK
%start TEXTOK

%%

BEGIN:VCALENDAR	                                                {printf("Début calendrier\n");return DEBCAL;}
END:VCALENDAR	                                                {printf("Fin calendrier\n");return FINCAL;}
BEGIN:VEVENT	                                                {printf("Début événement\n"); BEGIN LIGNEOK;return DEBEVT;}
END:VEVENT	                                                    {printf("Fin événement\n");return FINEVT;}
<LIGNEOK>DTSTART:	                                            {printf("intro heure début evt unique\n"); BEGIN DATEUOK;addEVT(UNIQ);yylval=line;return IDEBEVTU;}
<LIGNEOK>DTEND:		                                            {printf("intro heure fin evt unique\n"); BEGIN DATEUOK;yylval=line;return IFINEVTU;}
<LIGNEOK>SUMMARY:	                                            {printf("intro titre\n"); BEGIN TEXTOK;yylval=line;return ITITRE;}
<LIGNEOK>LOCATION:	                                            {printf("intro lieu\n"); BEGIN TEXTOK;yylval=line;return ILIEU;}
<LIGNEOK>DESCRIPTION:	                                        {printf("intro description\n"); BEGIN TEXTOK;yylval=line;return IDESCR;}
<LIGNEOK>BEGIN:VALARM	                                        {printf("Début alarme\n"); BEGIN ALARMOK;return DEBAL;}
<ALARMOK>END:VALARM	                                            {printf("Fin alarme\n"); BEGIN LIGNEOK;return FINAL;}
<ALARMOK>TRIGGER:	                                            {printf("intro position alarme\n");return TRIGGER;}
<LIGNEOK>RRULE:		                                            {printf("intro règle répétition\n");return RRULE;}
<LIGNEOK>FREQ=		                                            {printf("intro fréquence\n");return FREQ;}
<LIGNEOK>COUNT=		                                            {printf("intro compteur\n"); BEGIN NBOK;return COUNT;}
<LIGNEOK>BYDAY=		                                            {printf("intro liste jours\n"); BEGIN JOUROK;return BYDAY;}
<LIGNEOK>UNTIL=		                                            {printf("intro limite\n"); BEGIN DATEUOK;return UNTIL;}
<LIGNEOK>WKST=SU		                                        {printf("changement de semaine\n");return WKST;}
<LIGNEOK>DAILY|WEEKLY|MONTHLY|YEARLY	                        {printf("frequence : %s\n", yytext);addTable(FRQC, yytext, (int)strlen(yytext));return VALFREQ;}
<LIGNEOK>;		                                                {printf("séparateur options\n");return PV;}
<LIGNEOK>DTSTART;TZID=[a-zA-Z/]+:	                            {printf("intro heure début evt répétitif\n");BEGIN DATEROK;addEVT(REPET);yylval=line;return DEBEVTR;}
<LIGNEOK>DTEND;TZID=[a-zA-Z/]+:		                            {printf("intro heure fin evt répétitif\n");BEGIN DATEROK;yylval=line;return FINEVTR;}
<LIGNEOK>DTSTART;VALUE=DATE:	                                {printf("intro heure début evt journée\n");BEGIN DATEJOK;addEVT(JOUR);yylval=line;return DEBEVTJ;}
<LIGNEOK>DTEND;VALUE=DATE:		                                {printf("intro heure fin evt journée\n"); BEGIN DATEJOK;yylval=line;return FINEVTJ;}
<ALARMOK>"-P"[0-9]+DT[0-9]+H[0-9]+M[0-9]+S	                    {printf("position alarme : %s\n", yytext);addTable(ALARM, yytext, (int)strlen(yytext));return POSAL;}
<DATEJOK>[0-9]{8}	                                            {printf("date evt journée : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTJ;}
<NBOK>[0-9]+		                                            {printf("nombre entier : %s\n", yytext);BEGIN LIGNEOK;addTable(CPT, yytext, (int)strlen(yytext));return NOMBRE;}
<DATEROK>[0-9]{8}T[0-9]{6}		                                {printf("date et heure evt répétitif : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTR;}
<DATEUOK>[0-9]{8}T[0-9]{6}Z		                                {printf("date et heure evt unique : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTU;}
<JOUROK>(SU|MO|TU|WE|TH|FR|SA)(,(SU|MO|TU|WE|TH|FR|SA)){0,6}	{printf("liste jours : %s\n", yytext);BEGIN LIGNEOK;addTable(LSTJ, yytext, (int)strlen(yytext));return LISTJ;}
<TEXTOK>[^:\n]*$	                                            {printf("Lieu, description ou titre : %s\n",yytext); BEGIN LIGNEOK;addTable(TXT, yytext, (int)strlen(yytext));return TEXTE;}
.|\n ;

%%