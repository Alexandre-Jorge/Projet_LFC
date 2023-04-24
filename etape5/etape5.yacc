%{
	#include <stdio.h>
	#include "header.h"
	void yyerror(char* s);

	extern matrix table1;
    extern char * table2;
%}
%token DEBCAL FINCAL DEBEVT FINEVT IDEBEVTU IFINEVTU DATEVTU
%token ITITRE ILIEU IDESCR DEBAL FINAL TRIGGER POSAL TEXTE
%token RRULE FREQ COUNT BYDAY UNTIL WKST VALFREQ PV NOMBRE LISTJ
%token DEBEVTR FINEVTR DEBEVTJ FINEVTJ DATEVTJ DATEVTR
%start fichier
%%

fichier : DEBCAL liste_evenements FINCAL ;
liste_evenements : evenement liste_evenements | ;
evenement : DEBEVT infos_evenement FINEVT ;
infos_evenement : infos_evenement_unique | infos_evenement_repetitif | infos_evenement_journalier ;
infos_evenement_unique : IDEBEVTU DATEVTU IFINEVTU DATEVTU suite_infos_evenement {table1[$1][1] = -11; table1[$3][1] = -12;};
suite_infos_evenement : les_textes liste_alarmes ;
les_textes : IDESCR TEXTE ILIEU TEXTE ITITRE TEXTE {table1[$1][1] = -13; table1[$3][1] = -14; table1[$5][1] = -15;};
infos_evenement_repetitif : DEBEVTR DATEVTR FINEVTR DATEVTR repetition suite_infos_evenement {table1[$1][1] = -11; table1[$3][1] = -12;};
infos_evenement_journalier : DEBEVTJ DATEVTJ FINEVTJ DATEVTJ suite_infos_evenement {table1[$1][1] = -11; table1[$3][1] = -12;};
liste_alarmes : alarme liste_alarmes | ;
alarme : DEBAL TRIGGER POSAL FINAL ;
repetition : RRULE FREQ VALFREQ PV WKST PV COUNT NOMBRE PV BYDAY LISTJ
	| RRULE FREQ VALFREQ PV UNTIL DATEVTU
	| RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU
	| RRULE FREQ VALFREQ PV UNTIL DATEVTU PV BYDAY LISTJ
	| RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU PV BYDAY LISTJ ;
%%


void yyerror(char* s)
{
	fprintf(stdout,"\n Erreur -> %s \n",s);
}
int main()
{
	table1 = (matrix)malloc(1000*sizeof(int*));
	for(int i=0; i<1000; i++) table1[i] = (int*)malloc(10*sizeof(int));
	table2 = (char*)malloc(10000*sizeof(char));
	yyparse();
	displayTab();
	printf("\nFin des analyses lexicale et syntaxique\n");
	printf("%s\n", table2+89);
	for (int i = 0; i < 1000; i++) {
        free(table1[i]);
    }
    free(table1);
	free(table2);
	return 0;
}