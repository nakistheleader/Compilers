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
ISON         	=
INTCONST        0|[+-]?[1-9]+[0-9]*
VARIABLE	    \?[A-Za-z0-9]+ 
COMMENTS        ;.*
FLOAT           [+-]?[0-9]+(([eE][+-]?[0-9]+)|\.[0-9]+[eE][+-]?[0-9]+|\.[0-9]+)
DEFFACTS        "deffacts"
DEFRULE         "defrule"
TEST            "test"
PRINTOUT        "printout t"
READ            "read"
BIND            "bind"
FACT_RULE_NAME  [a-zA-Z][0-9a-zA-Z_-]*
STRING          \"((\\\\)|(\\\")|(\\n)|[^\"\\\n\r])*\"
VELOS           "->"
NEWLINE         \n
ERROR           .

%%

{DELIMITER}        { }
{LEFT_PAR}         { /*prn("Left parenthesis");*/ return LEFT_PAR; }
{RIGHT_PAR}        { /*prn("Right parenthesis");*/  return RIGHT_PAR; }
{OPERATOR}         { return OPERATOR; }
{ISON}             { /*prn("ISON");*/return ISON; }
{VELOS}            { /*prn("VELOS");*/ return VELOS; }
{INTCONST}         { /*prn("INTCONST");*/  correctWords++; return INTCONST; }
{VARIABLE}	       { /*prn("VARIABLE");*/  correctWords++; return VARIABLE; }
{COMMENTS}         { /*prn("COMMENTS");*/ }
{DEFFACTS}         { /*prn("DEFFACTS");*/  correctWords++; return DEFFACTS; }
{DEFRULE}          { /*prn("DEFRULE");*/  correctWords++; return DEFRULE; }
{TEST}             { /*prn("TEST");*/  correctWords++; return TEST; }
{PRINTOUT}         { /*prn("PRINT");*/  correctWords++; return PRINTOUT; }
{READ}             { /*prn("READ");*/  correctWords++; return READ; }
{BIND}             { /*prn("BIND");*/  correctWords++; return BIND; }
{FACT_RULE_NAME}   { /*prn("FACT_RULE_NAME");*/  correctWords++; return FACT_RULE_NAME; }
{STRING}		   { return STRING;}
{ERROR}            { printf("\nWrong word definition at line: %d", line); incorrectWords++;}
{NEWLINE}          { line++; printf("\n"); }

%%


void prn(char *s)
{
	printf("\n\t%s: %s ", s, yytext);
	return;
}


