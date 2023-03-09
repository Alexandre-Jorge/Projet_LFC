%{
	#include <stdio.h>
	#include "y.tab.h"
%}
%start LIGNEOK
%start DATEUOK
%start DATEROK
%start DATEJOK
%start NBOK
%start JOUROK
%start ALARM
%start TEXTOK
%%
BEGIN:VCALENDAR	{
	//printf("Début calendrier\n");
	return DEBCAL;
}
END:VCALENDAR	{
	//printf("Fin calendrier\n");
	return FINCAL;
}
BEGIN:VEVENT	{
	//printf("Début événement\n"); 
	BEGIN LIGNEOK;
	return DEBEVT;
}
END:VEVENT	{
	//printf("Fin événement\n");
	return FINEVT;
}
<LIGNEOK>DTSTART:	{
	//printf("intro heure début evt unique\n"); 
	BEGIN DATEUOK;
	return IDEBEVTU;
}
<LIGNEOK>DTEND:		{
	//printf("intro heure fin evt unique\n"); 
	BEGIN DATEUOK;
	return IFINEVTU;
}
<LIGNEOK>SUMMARY:	{
	//printf("intro titre\n"); 
	BEGIN TEXTOK;
	return ITITRE;
}
<LIGNEOK>LOCATION:	{
	//printf("intro lieu\n"); 
	BEGIN TEXTOK;
	return ILIEU;
}
<LIGNEOK>DESCRIPTION:	{
	//printf("intro description\n"); 
	BEGIN TEXTOK;
	return IDESCR;
}
<LIGNEOK>BEGIN:VALARM	{
	//printf("Début alarme\n"); 
	BEGIN ALARM;
	return DEBAL;
}
<ALARM>END:VALARM	{
	//printf("Fin alarme\n"); 
	BEGIN LIGNEOK;
	return FINAL;
}
<ALARM>TRIGGER:	{
	//printf("intro position alarme\n");
	return TRIGGER;
}
<LIGNEOK>RRULE:		{
	//printf("intro règle répétition\n");
	return RRULE;
}
<LIGNEOK>FREQ=		{
	//printf("intro fréquence\n");
	return FREQ;
}
<LIGNEOK>COUNT=		{
	//printf("intro compteur\n"); 
	BEGIN NBOK;
	return COUNT;
}
<LIGNEOK>BYDAY=		{
	//printf("intro liste jours\n"); 
	BEGIN JOUROK;
	return BYDAY;
}
<LIGNEOK>UNTIL=		{
	//printf("intro limite\n"); 
	BEGIN DATEUOK;
	return UNTIL;
}
<LIGNEOK>WKST=SU		{
	//printf("changement de semaine\n");
	return WKST;
}
<LIGNEOK>DAILY|WEEKLY|MONTHLY|YEARLY	{
	//printf("frequence : %s\n", yytext);
	return VALFREQ;
}
<LIGNEOK>;		{
	//printf("séparateur options\n");
	return PV;
}
<LIGNEOK>DTSTART;TZID=[a-zA-Z/]+:	{
	//printf("intro heure début evt répétitif\n"); 
	BEGIN DATEROK;
	return DEBEVTR;
}
<LIGNEOK>DTEND;TZID=[a-zA-Z/]+:		{
	//printf("intro heure fin evt répétitif\n"); 
	BEGIN DATEROK;
	return FINEVTR;
}
<LIGNEOK>DTSTART;VALUE=DATE:	{
	//printf("intro heure début evt journée\n"); 
	BEGIN DATEJOK;
	return DEBEVTJ;
}
<LIGNEOK>DTEND;VALUE=DATE:		{
	//printf("intro heure fin evt journée\n"); 
	BEGIN DATEJOK;
	return FINEVTJ;
}
<ALARM>"-P"[0-9]+DT[0-9]+H[0-9]+M[0-9]+S	{
	//printf("position alarme : %s\n", yytext);
	return POSAL;
}
<DATEJOK>[0-9]{8}	{
	//printf("date evt journée : %s\n", yytext); 
	BEGIN LIGNEOK;
	return DATEVTJ;
}
<NBOK>[0-9]+		{
	//printf("nombre entier : %s\n", yytext); 
	BEGIN LIGNEOK;
	return NOMBRE;
}
<DATEROK>[0-9]{8}T[0-9]{6}		{
	//printf("date et heure evt répétitif : %s\n", yytext); 
	BEGIN LIGNEOK;
	return DATEVTR;
}
<DATEUOK>[0-9]{8}T[0-9]{6}Z		{
	//printf("date et heure evt unique : %s\n", yytext); 
	BEGIN LIGNEOK;
	return DATEVTU;
}
<JOUROK>(SU|MO|TU|WE|TH|FR|SA)(,(SU|MO|TU|WE|TH|FR|SA)){0,6}	{
	//printf("liste jours : %s\n", yytext); 
	BEGIN LIGNEOK;
	return LISTJ;
}
<TEXTOK>[^:\n]*$	{
	//printf("Lieu, description ou titre : %s\n",yytext); 
	BEGIN LIGNEOK;
	return TEXTE;
}
.|\n ;
%%

