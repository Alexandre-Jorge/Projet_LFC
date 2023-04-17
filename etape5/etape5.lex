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
                    default : 
                        printf("%d\t", table1[i][j]);
                }
            }
            printf("\n");
        }
        
        printf("\n%s\n", table2);
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
<LIGNEOK>DTSTART:	                                            {printf("intro heure début evt unique\n"); BEGIN DATEUOK;addEVT(UNIQ);return IDEBEVTU;}
<LIGNEOK>DTEND:		                                            {printf("intro heure fin evt unique\n"); BEGIN DATEUOK;return IFINEVTU;}
<LIGNEOK>SUMMARY:	                                            {printf("intro titre\n"); BEGIN TEXTOK;return ITITRE;}
<LIGNEOK>LOCATION:	                                            {printf("intro lieu\n"); BEGIN TEXTOK;return ILIEU;}
<LIGNEOK>DESCRIPTION:	                                        {printf("intro description\n"); BEGIN TEXTOK;return IDESCR;}
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
<LIGNEOK>DTSTART;TZID=[a-zA-Z/]+:	                            {printf("intro heure début evt répétitif\n");BEGIN DATEROK;addEVT(REPET);return DEBEVTR;}
<LIGNEOK>DTEND;TZID=[a-zA-Z/]+:		                            {printf("intro heure fin evt répétitif\n");BEGIN DATEROK;return FINEVTR;}
<LIGNEOK>DTSTART;VALUE=DATE:	                                {printf("intro heure début evt journée\n");BEGIN DATEJOK;addEVT(JOUR);return DEBEVTJ;}
<LIGNEOK>DTEND;VALUE=DATE:		                                {printf("intro heure fin evt journée\n"); BEGIN DATEJOK;return FINEVTJ;}
<ALARMOK>"-P"[0-9]+DT[0-9]+H[0-9]+M[0-9]+S	                    {printf("position alarme : %s\n", yytext);addTable(ALARM, yytext, (int)strlen(yytext));return POSAL;}
<DATEJOK>[0-9]{8}	                                            {printf("date evt journée : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTJ;}
<NBOK>[0-9]+		                                            {printf("nombre entier : %s\n", yytext);BEGIN LIGNEOK;addTable(CPT, yytext, (int)strlen(yytext));return NOMBRE;}
<DATEROK>[0-9]{8}T[0-9]{6}		                                {printf("date et heure evt répétitif : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTR;}
<DATEUOK>[0-9]{8}T[0-9]{6}Z		                                {printf("date et heure evt unique : %s\n", yytext);BEGIN LIGNEOK;addTable(DAT, yytext, (int)strlen(yytext));return DATEVTU;}
<JOUROK>(SU|MO|TU|WE|TH|FR|SA)(,(SU|MO|TU|WE|TH|FR|SA)){0,6}	{printf("liste jours : %s\n", yytext);BEGIN LIGNEOK;addTable(LSTJ, yytext, (int)strlen(yytext));return LISTJ;}
<TEXTOK>[^:\n]*$	                                            {printf("Lieu, description ou titre : %s\n",yytext); BEGIN LIGNEOK;addTable(TXT, yytext, (int)strlen(yytext));return TEXTE;}
.|\n ;

%%