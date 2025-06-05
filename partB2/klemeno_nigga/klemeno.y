%{
  //Declaration of varianbles, functions and methods used
  #include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYDEBUG 1 
	#define YYSTYPE char*
	int line = 1;
	int correctWords = 0;
	int incorrectWords = 0;
	int incorrectExprs = 0;
	int correctExprs = 0; //Counts correct statements
	extern char *yytext;
	int yylex();
	int yyerror(const char *s); //changed the function to accept char pointer to avoid warnings during compiling 
	int resetIncorrectExprs (int i);
	
%}

/* token definition */
%token INTCONST VARIABLE OPERATOR ISON DEFRULE DEFFACTS TEST PRINTOUT READ BIND FACT_RULE_NAME LEFT_PAR RIGHT_PAR VELOS


%start program

%%


//Declaration of the rules and syntax

program:
    program expr              { printf("\nMathimatic Expression."); }
	|program deffacts         { printf("\nDeffacts Definition."); correctExprs++; }
	|program defrule          { printf("\nDefrule Definition."); correctExprs++; }
	|program test             { printf("\nTest Function."); correctExprs++; }
	|program printout         { printf("\nPrint Function."); correctExprs++; }
	|program read             { printf("\nRead Function."); correctExprs++; }
	|program bind             { printf("\nBind Function."); correctExprs++; }
	|program error	          { printf("\nSyntax error");  incorrectExprs++;}
	|
	;

expr:
	INTCONST	  { correctExprs++; }
	|VARIABLE	{ correctExprs++; }
	|LEFT_PAR OPERATOR expr mathrecursion RIGHT_PAR   { correctExprs++; }
	;

mathrecursion: 
	expr
	|mathrecursion expr
	;

defrule: LEFT_PAR DEFRULE FACT_RULE_NAME defruleRecursion VELOS action RIGHT_PAR{ correctExprs++; }
;

deffacts: LEFT_PAR DEFFACTS FACT_RULE_NAME fact RIGHT_PAR { correctExprs++; }
;

test: LEFT_PAR TEST equal RIGHT_PAR { correctExprs++; }
;

printout: LEFT_PAR PRINTOUT printoutRecursion RIGHT_PAR { correctExprs++; }
;

read: LEFT_PAR READ VARIABLE RIGHT_PAR { correctExprs++; }
;

bind: LEFT_PAR BIND VARIABLE expr RIGHT_PAR { correctExprs++; }
;

equal: LEFT_PAR ISON expr expr RIGHT_PAR
	|ISON LEFT_PAR ISON expr expr RIGHT_PAR
	;

recursion: expr
	|recursion expr
	|FACT_RULE_NAME
	|recursion FACT_RULE_NAME
	;

fact: LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	|fact LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	;

defruleRecursion: LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	|defruleRecursion LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	|test
	|defruleRecursion test
	;

action: printout
	|action printout
	|test
	|action test
	|bind 
	|action bind
	|read
	|action read
	;

printoutRecursion: LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	|printoutRecursion LEFT_PAR FACT_RULE_NAME recursion RIGHT_PAR
	|LEFT_PAR expr recursion RIGHT_PAR
	|printoutRecursion LEFT_PAR expr recursion RIGHT_PAR
	|expr
	|printoutRecursion expr
	;
%%

//The function yyerror is responsible for finding the syntax errors. 
//If there is a syntax error this function prints an error message
int yyerror(char  const*s) {
  printf("\nLine: %d FAILURE %s\n",line-1,s);
}

extern int yy_flex_debug; 

//main function
int main(int argc,char **argv){

	//flex debugging
	//yy_flex_debug = 1;
	//yydebug = 1;


	int parse = yyparse();

	//checking if there were any syntax errors
	if (incorrectExprs == 0 && incorrectWords == 0 && parse == 0){
		
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n");
		
	}else{

		printf("\nINPUT FILE: PARSING FAILED.\n");

	}

	//printing information about the correct words, exprations and inorrect words and expation if they excist
	printf("Number of correct words detected : %d\n",correctWords);
	printf("Number of correct expretions detected : %d\n",correctExprs);

	printf("Number of incorect words detected : %d\n",incorrectWords);
	incorrectExprs = resetIncorrectExprs(incorrectExprs); 
	printf("Number of incorect expretions detected : %d\n",incorrectExprs-1);
	
	return 0;
}

//If the parser recognizes a syntax error it counts the expresion which is wrong as one incorrect expration but it counts
//the previous line as well wrong. So to count correctly the wrong Expration we had to print the number of incorrect exprations 
//minus one. But with this method the count starts at -1 so to display everything correctly we have to reset the counter variable
//to zero. 
int resetIncorrectExprs (int i){
	if (i <= 0)
		return 1;
}
