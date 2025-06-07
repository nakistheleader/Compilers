%{

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int line = 1;
	int correctWords = 0;
	int wrongWords = 0;
	int wrongExpressions = 0;
	int correctExpressions = 0;
	int warnings = 0;
	int yylex();
	int yyerror(const char *s);
	
%}

/* token definition */
%token INTCONST VARIABLE OPERATOR ISON DEFRULE DEFFACTS TEST PRINTOUT READ BIND FACT_RULE_NAME LEFT_PAR RIGHT_PAR VELOS STRING FLOAT 

%start program

%%

program:
	program deffacts   { printf("Βρέθηκε Ορισμός Γεγονότων στη γραμμή %d\n",line); correctExpressions++; }
	|program defrule   { printf("Βρέθηκε Ορισμός Κανόνα στη γραμμή %d\n",line); correctExpressions++; }
	|program test      { printf("Βρέθηκε Test Function στη γραμμή %d\n",line); correctExpressions++; }
	|program bind      { printf("Βρέθηκε Bind Function στη γραμμή %d\n",line); correctExpressions++; }
	|program error     { wrongExpressions++;  }
	|
	;

deffacts:
	LEFT_PAR DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR 
	|DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR           { printf("Warning: Ξέχασες να ανοίξεις παρένθεση\n"); warnings++; } 
	;

fact_list: 
	LEFT_PAR elements RIGHT_PAR              { printf("\tΓεγονός\n"); }
	|fact_list LEFT_PAR elements RIGHT_PAR   { printf("\tΓεγονός\n"); }
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
	LEFT_PAR DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR  { }
	|DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR          { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση defrule.\n"); warnings++; } 
	;

test: 
	LEFT_PAR TEST equal RIGHT_PAR { printf("\tΈλεγχος\n"); }
	|TEST equal RIGHT_PAR         { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση test.\n"); warnings++; }
	;

printout: 
	LEFT_PAR PRINTOUT fact_list RIGHT_PAR           { printf("\tΣυνάρτηση printout\n"); }
	|printout LEFT_PAR PRINTOUT fact_list RIGHT_PAR { printf("\tΣυνάρτηση printout\n"); }
	|PRINTOUT fact_list RIGHT_PAR	                { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση printout t.\n"); warnings++; }
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
	|LEFT_PAR expr expr RIGHT_PAR              { printf("Warning: Ξέχασες το ίσον.\n"); warnings++;  }
	|equal LEFT_PAR expr expr RIGHT_PAR        { printf("Warning: Ξέχασες το ίσον.\n"); warnings++; }
	;

read: 
	LEFT_PAR READ RIGHT_PAR { printf("\tΑνάγνωση\n"); }
	|READ RIGHT_PAR         { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση read.\n"); warnings++; }
	;

bind: 
	LEFT_PAR BIND VARIABLE expr RIGHT_PAR  { printf("\tΑνάθεση τιμής\n"); }
	|LEFT_PAR BIND VARIABLE read RIGHT_PAR { printf("\tΑνάθεση τιμής\n"); }
;

%%

int yyerror(char  const *s) {
	printf("Error: Γραμμή %d \n",line,s);
}

int main(int argc,char **argv){

	int parse = yyparse();

	if (wrongExpressions == 0 && wrongWords == 0 && parse == 0){
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n");	
	}
	else{
		printf("\nINPUT FILE: PARSING FAILED.\n");
	}

	//printing information about the correct words, expressions and incorrect words and expressions if they exist
	printf("Number of correct words detected : %d\n",correctWords);
	printf("Number of correct expressions detected : %d\n",correctExpressions);

	printf("Number of incorrect words detected : %d\n",wrongWords);
	printf("Number of incorrect expressions detected : %d\n",wrongExpressions);

	printf("Parsing completed with %d warnings.\n",warnings);
	return 0;
}
