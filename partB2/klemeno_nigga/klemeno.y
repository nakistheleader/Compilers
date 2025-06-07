%{

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int line = 1;
	int correctWords = 0;
	int incorrectWords = 0;
	int incorrectExprs = 0;
	int correctExprs = 0; //Counts correct statements
	int yylex();
	int yyerror(const char *s); //changed the function to accept char pointer to avoid warnings during compiling 
	
%}

/* token definition */
%token INTCONST VARIABLE OPERATOR ISON DEFRULE DEFFACTS TEST PRINTOUT READ BIND FACT_RULE_NAME LEFT_PAR RIGHT_PAR VELOS STRING FLOAT NEWLINE

%start program

%%


//Declaration of the rules and syntax

program:
	program deffacts   { printf("Βρέθηκε Ορισμός Γεγονότων στη γραμμή %d\n",line); correctExprs++; }
	|program defrule   { printf("Βρέθηκε Ορισμός Κανόνα στη γραμμή %d\n",line); correctExprs++; }
	|program test      { printf("Βρέθηκε Test Function στη γραμμή %d\n",line); correctExprs++; }
	|program bind      { printf("Βρέθηκε Bind Function στη γραμμή %d\n",line); correctExprs++; }
	|program error     { printf("Syntax error\n"); yyerrok; incorrectExprs++; }
	|
	;

deffacts: 
	LEFT_PAR DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR { }
	;

fact_list: 
	LEFT_PAR elements RIGHT_PAR              { printf("\tΓεγονός\n"); }
	|fact_list LEFT_PAR  elements RIGHT_PAR  { printf("\tΓεγονός\n"); }
	;


elements: 
	expr
	|elements expr
	|FACT_RULE_NAME            
	|elements FACT_RULE_NAME
	|STRING
	|elements STRING
	;
	
defrule: 
	LEFT_PAR DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR{ printf("\tΚανόνας\n"); }
	;

test: 
	LEFT_PAR TEST equal RIGHT_PAR { printf("\tΈλεγχος\n"); }
	;

printout: 
	LEFT_PAR PRINTOUT fact_list RIGHT_PAR           { printf("\tΣυνάρτηση printout\n"); }
	|printout LEFT_PAR PRINTOUT fact_list RIGHT_PAR { printf("\tΣυνάρτηση printout\n"); }
	;

mathoperation:
	LEFT_PAR OPERATOR expr expr_list RIGHT_PAR   { printf("\tΜαθηματική Έκφραση\n"); }
	;

expr:
	INTCONST
	|VARIABLE
	|mathoperation
	;

expr_list: 
	expr
	|expr_list expr
	;

equal: 
	LEFT_PAR ISON expr expr RIGHT_PAR          { printf("\tΣύγκριση\n"); }
	|equal LEFT_PAR ISON expr expr RIGHT_PAR   { printf("\tΣύγκριση\n"); }
	;

read: LEFT_PAR READ RIGHT_PAR { printf("\tΑνάγνωση\n"); }
;

bind: 
	LEFT_PAR BIND VARIABLE expr RIGHT_PAR  { printf("\tΑνάθεση τιμής\n"); }
	|LEFT_PAR BIND VARIABLE read RIGHT_PAR { printf("\tΑνάθεση τιμής\n"); }
;

%%

//The function yyerror is responsible for finding the syntax errors. 
//If there is a syntax error this function prints an error message
int yyerror(char  const*s) {
  printf("\nLine: %d FAILURE %s\n",line-1,s);
}

int main(int argc,char **argv){

	int parse = yyparse();

	//checking if there were any syntax errors
	if (incorrectExprs == 0 && incorrectWords == 0 && parse == 0){
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n");	
	}
	else{
		printf("\nINPUT FILE: PARSING FAILED.\n");
	}

	//printing information about the correct words, expressions and incorrect words and expressions if they exist
	printf("Number of correct words detected : %d\n",correctWords);
	printf("Number of correct expressions detected : %d\n",correctExprs);

	printf("Number of incorrect words detected : %d\n",incorrectWords);
	printf("Number of incorrect expressions detected : %d\n",incorrectExprs);
	
	return 0;
}
