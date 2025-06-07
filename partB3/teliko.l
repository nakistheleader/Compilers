%option noyywrap
%x error

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYSTYPE char*

#include "teliko_y.h"

extern int line; //Line counter
extern int correctWords; //Correct words counter
extern int wrongWords; //Incorrect Words counter
extern int warnings;
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
ISON_WARN       ==
DEFFACTS_WARN   "defacts"|"deffact"|"defact"
DEFRULE_WARN    "derule"|"defrul"|"derulo"
TEST_WARN       "tst"|"ttest"|"testt"
PRINTOUT_WARN   "printoutt"|"printout"|"prntout"
READ_WARN       "readd"|"red"|"resd"
BIND_WARN       "bindd"|"bbind"|"bnd"
VELOS_WARN      "-->"|">"|"- >"



%%

{DELIMITER}        { }
{LEFT_PAR}         { return LEFT_PAR; }
{RIGHT_PAR}        { return RIGHT_PAR; }
{OPERATOR}         { correctWords++; return OPERATOR; }
{ISON}             { correctWords++; return ISON; }
{ISON_WARN}        { printf("Warning: Έβαλες 2 ίσον.\n"); warnings++; return ISON;}
{VELOS}            { correctWords++; return VELOS; }
{VELOS_WARN}       { printf("Warning: Έγραψες λάθος το βέλος.\n"); warnings++; return VELOS;}
{INTCONST}         { correctWords++; return INTCONST; }
{FLOAT}			   { correctWords++; return FLOAT;}
{VARIABLE}	       { correctWords++; return VARIABLE; }
{COMMENTS}         { }
{DEFFACTS}         { correctWords++; return DEFFACTS; }
{DEFFACTS_WARN}    { printf("Warning: Έγραψες λάθος την συνάρτηση deffacts.\n"); warnings++; return DEFFACTS;}
{DEFRULE}          { correctWords++; return DEFRULE; }
{DEFRULE_WARN}     { printf("Warning: Έγραψες λάθος την συνάρτηση defrule.\n"); warnings++; return DEFRULE; }
{TEST}             { correctWords++; return TEST; }
{TEST_WARN}        { printf("Warning: Έγραψες λάθος την συνάρτηση test.\n"); warnings++; return TEST; }
{PRINTOUT}         { correctWords++; return PRINTOUT; }
{PRINTOUT_WARN}    { printf("Warning: Έγραψες λάθος την συνάρτηση printout.\n"); warnings++; return PRINTOUT; }
{READ}             { correctWords++; return READ; }
{READ_WARN}        { printf("Warning: Έγραψες λάθος την συνάρτηση read.\n"); warnings++; return READ; }
{BIND}             { correctWords++; return BIND; }
{BIND_WARN}        { printf("Warning: Έγραψες λάθος την συνάρτηση bind.\n"); warnings++; return BIND; }
{FACT_RULE_NAME}   { correctWords++; return FACT_RULE_NAME; }
{STRING}		   { correctWords++; return STRING;}
{ERROR}            { printf("\nΛάθος στην γραμμή: %d\n", line); BEGIN(error); wrongWords++;}
{NEWLINE}          { line++; }

<error>[ \t\n]+ { BEGIN(0); }
<error>.        {}

%%
