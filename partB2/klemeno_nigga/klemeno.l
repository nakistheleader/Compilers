%option noyywrap

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYSTYPE char*

#include "klemeno_y.h"

extern int line; //Line counter
extern int correctWords; //Correct words counter
extern int incorrectWords; //Incorrect Words counter
void prn(char *s);

%}

DELIMITER       [ \t]+
LEFT_PAR        "("
RIGHT_PAR       ")"
OPERATOR        \+|-|\*|\/
EQUALS          =
INTCONST        0|[+-]?[1-9]+[0-9]*
VARIABLE	       \?[A-Za-z0-9]+ 
COMMENTS        ;.*
FLOAT           [+-]?[0-9]+(([eE][+-]?[0-9]+)|\.[0-9]+[eE][+-]?[0-9]+|\.[0-9]+)
DEFFACTS        "deffacts"
DEFRULE         "defrule"
TEST            "test"
PRINT           "printout"
READ            "read"
BIND            "bind"
STATE           [a-zA-Z][0-9a-zA-Z_-]*
ARROW           "->"
ERROR           .
NEWLINE         \n

%%

{DELIMITER}     { }
{LEFT_PAR}         { prn("Left parenthesis"); return LEFT_PAR; }
{RIGHT_PAR}        { prn("Right parenthesis");  return RIGHT_PAR; }
{OPERATOR}         { return OPERATOR; }
{EQUALS}           { return EQUALS; }
{ARROW}            { prn("ARROW"); return ARROW; }
{INTCONST}         { prn("INTCONST");  correctWords++; return INTCONST; }
{VARIABLE}	       { prn("VARIABLE");  correctWords++; return VARIABLE; }
{COMMENTS}         { prn("COMMENTS"); }
{DEFFACTS}         { prn("DEFFACTS");  correctWords++; return DEFFACTS; }
{DEFRULE}          { prn("DEFRULE");  correctWords++; return DEFRULE; }
{TEST}             { prn("TEST");  correctWords++; return TEST; }
{PRINT}            { prn("PRINT");  correctWords++; return PRINTOUT; }
{READ}             { prn("READ");  correctWords++; return READ; }
{BIND}             { prn("BIND");  correctWords++; return BIND; }
{STATE}            { prn("STATE");  correctWords++; return STATE; }
{ERROR}            { printf("\nWrong word definition at line: %d", line); incorrectWords++;}
{NEWLINE}          { line++; printf("\n"); }

%%


void prn(char *s)
{
	printf("\n\t%s: %s ", s, yytext);
	return;
}


