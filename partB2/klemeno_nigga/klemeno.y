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
	int resetIncorrectExprs (int i);
	
%}

/* token definition */
%token INTCONST VARIABLE OPERATOR ISON DEFRULE DEFFACTS TEST PRINTOUT READ BIND FACT_RULE_NAME LEFT_PAR RIGHT_PAR VELOS STRING FLOAT

%start program

%%


//Declaration of the rules and syntax

program:
	program deffacts          { printf("Βρέθηκε Ορισμός Γεγονότων Γραμμή %d\n",line); correctExprs++; }
	|program defrule          { printf("Βρέθηκε Ορισμός Κανόνα.\n"); correctExprs++; }
    |program mathoperation    { printf("Mathimatic Expression.\n"); correctExprs++; }
	|program comparison       { printf("Συγκρίσεις Expression.\n"); correctExprs++; }
	|program test             { printf("Test Function.\n"); correctExprs++; }
	|program bind             { printf("Bind Function.\n"); correctExprs++; }
	|program read             { printf("Read Function.\n"); correctExprs++; }
	|program error	          { printf("Syntax error\n");  incorrectExprs++;}
	|
	;

deffacts: 
	LEFT_PAR DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR { correctExprs++; }
	;

fact_list: 
	LEFT_PAR elements RIGHT_PAR              {printf("\tΓεγονός\n");}
	|fact_list LEFT_PAR  elements RIGHT_PAR  {printf("\tΓεγονός\n");}
	;


elements: 
	expr
	|elements expr
	|FACT_RULE_NAME            { printf("\tΌνομα Ορισμού/Στοιχείο Γεγονότος\n"); }
	|elements FACT_RULE_NAME
	|STRING
	|elements STRING
	;
	
defrule: 
	LEFT_PAR DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR{ correctExprs++; printf("\tΚανόνας\n"); }
	;

test: 
	LEFT_PAR TEST equal RIGHT_PAR { correctExprs++; printf("\tΈλεγχος\n"); }
	;

printout: 
	LEFT_PAR PRINTOUT fact_list RIGHT_PAR           { correctExprs++; printf("Edw exei mia printut\n"); }
	|printout LEFT_PAR PRINTOUT fact_list RIGHT_PAR { correctExprs++; printf("kai Edw exei mia printut\n"); }
	;

mathoperation:
	LEFT_PAR OPERATOR expr expr_list RIGHT_PAR   { correctExprs++; printf("\tΜαθηματική Έκφραση\n"); }
	;

expr:
	INTCONST	     { correctExprs++; printf("\tΑκέραιος\n"); }
	|VARIABLE	     { correctExprs++; printf("\tΜεταβλητή\n"); }
	|mathoperation
	;

expr_list: 
	expr
	|expr_list expr
	;

comparison:
	LEFT_PAR ISON expr expr RIGHT_PAR          { correctExprs++; printf("\tΣύγκριση\n"); }
	;


equal: 
	LEFT_PAR ISON expr expr RIGHT_PAR          { correctExprs++; printf("\tΣύγκριση\n"); }
	|equal LEFT_PAR ISON expr expr RIGHT_PAR   { correctExprs++; printf("\tΣύγκριση\n"); }
	;

read: LEFT_PAR READ RIGHT_PAR { correctExprs++; printf("\tΑνάγνωση\n"); }
;

bind: 
	LEFT_PAR BIND VARIABLE expr RIGHT_PAR  { correctExprs++; printf("\tΑνάθεση τιμής\n"); }
	|LEFT_PAR BIND VARIABLE read RIGHT_PAR { correctExprs++; printf("\tΑνάθεση τιμής\n"); }
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
	incorrectExprs = resetIncorrectExprs(incorrectExprs); 
	printf("Number of incorrect expressions detected : %d\n",incorrectExprs-1);
	
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
