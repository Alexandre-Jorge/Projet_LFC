%{
    #include <stdio.h>
    void yyerror(char *s);
%}
%token DEBCAL FINCAL DEBEVT FINEVT IDEBEVTU IFINEVTU ITITRE ILIEU IDESCR DEBAL FINAL TRIGGER RRULE FREQ COUNT BYDAY UNTIL WKST VALFREQ PV DEBEVTR FINEVTR DEBEVTJ FINEVTJ POSAL DATEVTJ NOMBRE DATEVTR DATEVTU LISTJ TEXTE
%start fichier
%%
fichier: DEBCAL liste_evenements FINCAL {printf("fichier OK\n");};
liste_evenements: evenement liste_evenements {printf("liste_evenements OK\n");}
                |{printf("liste_evenements OK\n");};
evenement: DEBEVT infos_evenement FINEVT {printf("evenement OK\n");};
infos_evenement: infos_evenement_unique {printf("infos_evenement OK\n");}
                | infos_evenement_repetitif {printf("infos_evenement OK\n");}
                | infos_evenement_journalier {printf("infos_evenement OK\n");};
infos_evenement_unique: IDEBEVTU DATEVTU IFINEVTU DATEVTU suite_infos_evenement {printf("infos_evenement_unique OK\n");};
suite_infos_evenement: les_textes liste_alarmes {printf("suite_infos_evenement OK\n");};
les_textes: IDESCR TEXTE ILIEU TEXTE ITITRE TEXTE {printf("les_textes OK\n");};
infos_evenement_repetitif: DEBEVTR DATEVTR FINEVTR DATEVTR repetition suite_infos_evenement {printf("infos_evenement_repetitif OK\n");};
infos_evenement_journalier: DEBEVTJ DATEVTJ FINEVTJ DATEVTJ suite_infos_evenement {printf("infos_evenement_journalier OK\n");};
liste_alarmes: alarme liste_alarmes {printf("liste_alarmes OK\n");}
              | {printf("liste_alarmes OK\n");};
alarme: DEBAL TRIGGER POSAL FINAL {printf("alarme OK\n");};
repetition : RRULE FREQ VALFREQ PV WKST PV COUNT NOMBRE PV BYDAY LISTJ {printf("repetition OK\n");}
            | RRULE FREQ VALFREQ PV UNTIL DATEVTU {printf("repetition OK\n");}
            | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU {printf("repetition OK\n");}
            | RRULE FREQ VALFREQ PV UNTIL DATEVTU PV BYDAY LISTJ {printf("repetition OK\n");}
            | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU PV BYDAY LISTJ {printf("repetition OK\n");};
%%
void yyerror(char *s) {
    fprintf(stderr, "ERREUR : %s\n",s);
}
int main() {
    yyparse();
    return 0;
}