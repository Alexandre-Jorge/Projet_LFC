EXEC=etape5
CC=gcc

all:$(EXEC)

lex.yy.c: $(EXEC).lex
	lex $(EXEC).lex

$(EXEC): y.tab.h lex.yy.c y.tab.c
	$(CC) -Wall lex.yy.c y.tab.c -lfl -o $(EXEC)

y.tab.c: $(EXEC).yacc
	yacc $(EXEC).yacc

y.tab.h: $(EXEC).yacc
	yacc -d $(EXEC).yacc


clean:
	rm lex.yy.c *.o $(EXEC) y.tab.c y.tab.h

