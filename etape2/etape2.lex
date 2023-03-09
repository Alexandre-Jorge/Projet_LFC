%{
#include <stdio.h>
%}

%%
"BEGIN:VCALENDAR" {printf("début calendrier\n"); }
"END:VCALENDAR" {printf("fin calendrier\n");}
"BEGIN:VEVENT:" {printf("début événement\n"); }
"END:VEVENT:" {printf("fin événement\n");}
"DTSTART:" {printf("intro heure début evt unique\n");}
"DTEND:" {printf("intro heure fin evt unique\n");}
"SUMMARY:" {printf("intro titre\n");}
"LOCATION:" {printf("intro lieu\n");}
"DESCRIPTION:" {printf("intro description\n");}
"BEGIN:VALARM" {printf("début alarme\n");}
"END:VALARM" {printf("fin alarme\n"); }
"TRIGGER:" {printf("intro position alarme\n");}
"RRULE:" { printf("intro règle répétition\n"); }
"FREQ=" {printf("intro fréquence\n");}
"COUNT=" {printf("intro compteur\n"); }
"BYDAY=" {printf("intro liste jours\n");}
"UNTIL=" {printf("intro limite\n");}
"DTSTART;VALUE=DATE:" {printf("intro heure début evt journée\n");}
"DTEND;VALUE=DATE:" {printf("intro heure fin evt journée\n");}
";" {printf("séparateur d'options\n");}
[0-9]{8}T[0-9]{6}Z {printf("date et heure evt unique\n");}
-P[0-9]+DT[0-9]+H[0-9]+M[0-9]+S {printf("position alarme\n");}
"DTSTART;TZID="[a-zA-Z/]+":" {printf("intro heure début evt répétitif\n");}
"DTEND;TZID="[a-zA-Z/]+":" {printf("intro heure fin evt répétitif\n");}
[0-9]{8}"T"[0-9]{6} {printf("date et heure evt répétitif\n");}
[0-9]{8} {printf("date evt journée\n");}
[0-9]+ {printf("nombre entier\n");}
("SU"|"MO"|"TU"|"WE"|"TH"|"FR"|"SA")(","("SU"|"MO"|"TU"|"WE"|"TH"|"FR"|"SA"))* {printf("liste jours\n");}

.|\n ;
%%

int yywrap(){
	
	return 1;
}