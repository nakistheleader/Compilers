%option noyywrap
%x error

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYSTYPE char*

#include "klemeno_y.h"

extern int line; //Line counter
extern int correctWords; //Correct words counter
extern int incorrectWords; //Incorrect Words counter

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
{LEFT_PAR}         { return LEFT_PAR; }
{RIGHT_PAR}        { return RIGHT_PAR; }
{OPERATOR}         { correctWords++; return OPERATOR; }
{ISON}             { correctWords++; return ISON; }
{VELOS}            { correctWords++; return VELOS; }
{INTCONST}         { correctWords++; return INTCONST; }
{FLOAT}			   { correctWords++; return FLOAT;}
{VARIABLE}	       { correctWords++; return VARIABLE; }
{COMMENTS}         { }
{DEFFACTS}         { correctWords++; return DEFFACTS; }
{DEFRULE}          { correctWords++; return DEFRULE; }
{TEST}             { correctWords++; return TEST; }
{PRINTOUT}         { correctWords++; return PRINTOUT; }
{READ}             { correctWords++; return READ; }
{BIND}             { correctWords++; return BIND; }
{FACT_RULE_NAME}   { correctWords++; return FACT_RULE_NAME; }
{STRING}		   { correctWords++; return STRING;}
{ERROR}            { printf("\nΛάθος στην γραμμή: %d\n", line); BEGIN(error); incorrectWords++;}
{NEWLINE}          { line++; }

<error>[ \t\n]  { BEGIN(0); }
<error>.        {}
%%

