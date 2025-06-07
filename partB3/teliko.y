%{
#include <stdio.h>
#include <stdlib.h>

int line = 1;               // Mετρητής γραμμών 
int correctWords = 0;       // Μετρητής σωστά αναγνωρισμένων λέξεων
int wrongWords = 0;         // Μετρητής λάθος αναγνωρισμένων λέξεων
int wrongExpressions = 0;   // Μετρητής λάθος αναγνωρισμένων εκφράσεων
int correctExpressions = 0; // Μετρητής σωστά αναγνωρισμένων εκφράσεων
int warnings = 0;           // Μετρητής warnings
	
// Αρχικοποίηση yy συναρτήσεων για την μετέπειτα υλοποίηση και κλήση τους
int yylex(); 
int yyerror(const char *s);
	
%}

// Ορισμοί των token που θα χρησιμοποιηθούν στους γραμματικούς κανόνες
%token INTCONST VARIABLE OPERATOR ISON DEFRULE DEFFACTS TEST PRINTOUT READ BIND FACT_RULE_NAME LEFT_PAR RIGHT_PAR VELOS STRING FLOAT 

// Δήλωση μη τερματικό εκκίνησης
%start program

%%
// Αναγνωρίζονται 4 εντολές της γλώσσας deffacts, defrule, test και bind 
// οτιδήποτε άλλο (π.χ. σκέτη αριθμητική πράξη ) θεωρείται συντακτικό λάθος (error)
// Κάθε φορά που αναγνωρίζεται μία από τις παρακάτω εντολές αυξάνεται ο μετρητής σωστών εκφράσεων
// Διαφορετικά αυξάνεται ο μετρητής λάθος εκφράσεων
program:
	program deffacts   { printf("Βρέθηκε Ορισμός Γεγονότων στη γραμμή %d\n",line); correctExpressions++; }
	|program defrule   { printf("Βρέθηκε Ορισμός Κανόνα στη γραμμή %d\n",line); correctExpressions++; }
	|program test      { printf("Βρέθηκε Test Function στη γραμμή %d\n",line); correctExpressions++; }
	|program bind      { printf("Βρέθηκε Bind Function στη γραμμή %d\n",line); correctExpressions++; }
	|program error     { wrongExpressions++;  }
	|
	;

// Το μη τερματικό deffacts αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί deffacts,
// όνομα του κανόνα, μία σειρά από γεγονότα και τέλος δεξιά παρένθεση.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
deffacts:
	LEFT_PAR DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR 
	|DEFFACTS FACT_RULE_NAME fact_list RIGHT_PAR           { printf("Warning: Ξέχασες να ανοίξεις παρένθεση\n"); warnings++; } 
	;

// Το μη τερματικό fact_list αναγνωρίζει μία σειρά από γεγονότα. Τα γεγονότα είναι εκφράσεις της μορφής:
// αριστερή παρένθεση, μία σειρά από στοιχεία (elements) και δεξιά παρένθεση.
// Η αναγνώριση των γεγονότων γίνεται αναδρομικά για την περίπτωση που υπάρχουν περισσότερα από ένα γεγονότα σε σειρά.
// Κατά την αναγνώριση των γεγονότων εμφανίζεται ένα αντίστοιχο μήνυμα στην οθόνη
fact_list: 
	LEFT_PAR elements RIGHT_PAR              { printf("\tΓεγονός\n"); }
	|fact_list LEFT_PAR elements RIGHT_PAR   { printf("\tΓεγονός\n"); }
	;

// Το μη τερματικό elements αναγνωρίζει μία σειρά από στοιχεία που μπορεί να είναι:
// μη τερματικό expr , όνομα ορισμού και στοιχείου γεγονότος FACT_RULE_NAME και συμβολοσειρά STRING .
// Η αναγνώριση των στοιχείων γίνεται αναδρομικά για την περίπτωση που υπάρχουν περισσότερα από ένα στοιχεία σε σειρά.
elements: 
	expr
	|elements expr
	|FACT_RULE_NAME            
	|elements FACT_RULE_NAME
	|STRING
	|elements STRING
	;

// Το μη τερματικό defrule αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί defrule,
// όνομα του κανόνα, μία σειρά από γεγονότα, μία συνθήκη ελέγχου (test), το βέλος και μία συνάρτηση printout.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
defrule: 
	LEFT_PAR DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR  { }
	|DEFRULE FACT_RULE_NAME fact_list test VELOS printout RIGHT_PAR          { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση defrule.\n"); warnings++; } 
	;

// Το μη τερματικό test αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί test,
// μία σύγκριση (equal) και δεξιά παρένθεση.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
test: 
	LEFT_PAR TEST equal RIGHT_PAR { printf("\tΈλεγχος\n"); }
	|TEST equal RIGHT_PAR         { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση test.\n"); warnings++; }
	;

// Το μη τερματικό printout αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί printout t,
// μία σειρά από γεγονότα και δεξιά παρένθεση.
// Η αναγνώριση της συνάρτησης printout γίνεται αναδρομικά για την περίπτωση που υπάρχουν περισσότερες από μία εντολές printout σε σειρά.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings. 
printout:
	LEFT_PAR PRINTOUT fact_list RIGHT_PAR           { printf("\tΣυνάρτηση printout\n"); }
	|printout LEFT_PAR PRINTOUT fact_list RIGHT_PAR { printf("\tΣυνάρτηση printout\n"); }
	|PRINTOUT fact_list RIGHT_PAR	                { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση printout t.\n"); warnings++; }
	;

// Το μη τερματικό mathoperation αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, ένας τελεστής,
// μία αριθμητική έκφραση (expr), μία λίστα από αριθμητικές εκφράσεις (expr_list) και δεξιά παρένθεση.
mathoperation:
	LEFT_PAR OPERATOR expr expr_list RIGHT_PAR   { printf("\tΜαθηματική Έκφραση\n"); }
	;

// Το μη τερματικό expr αναγνωρίζει μία αριθμητική έκφραση που μπορεί να είναι:
// ένας ακέραιος αριθμός (INTCONST), μία μεταβλητή (VARIABLE) ή μία μαθηματική έκφραση (mathoperation).
expr:
	INTCONST
	|VARIABLE
	|mathoperation
	;

// Το μη τερματικό expr_list αναγνωρίζει μία λίστα από αριθμητικές εκφράσεις που μπορεί να είναι:
// μία αριθμητική έκφραση (expr) ή μία σειρά από αριθμητικές εκφράσεις (αναδρομικά expr_list expr).
expr_list: 
	expr
	|expr_list expr
	;

// Το μη τερματικό equal αναγνωρίζει μία σύγκριση που μπορεί να είναι:
// αριστερή παρένθεση, λέξη κλειδί ISON, δύο αριθμητικές εκφράσεις (expr) και δεξιά παρένθεση.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί το ίσον (ISON),
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
equal: 
	LEFT_PAR ISON expr expr RIGHT_PAR          { printf("\tΣύγκριση\n"); }
	|LEFT_PAR expr expr RIGHT_PAR              { printf("Warning: Ξέχασες το ίσον.\n"); warnings++;  }
	;

// Το μη τερματικό read αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί read,
// δεξιά παρένθεση.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
read: 
	LEFT_PAR READ RIGHT_PAR { printf("\tΑνάγνωση\n"); }
	|READ RIGHT_PAR         { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση read.\n"); warnings++; }
	;

// Το μη τερματικό bind αναγνωρίζει την έκφραση της μορφής: αριστερή παρένθεση, λέξη κλειδί bind,
// μία μεταβλητή (VARIABLE), μία αριθμητική έκφραση (expr) ή μία συνάρτηση read και δεξιά παρένθεση.
// Επίσης αναγνωρίζεται η ίδια έκφραση και στην περίπτωση που παραληφθεί η αριστερή παρένθεση,
// απλά εμφανίζεται ένα μήνυμα warning και αυξάνεται ο μετρητής warnings.
bind: 
	LEFT_PAR BIND VARIABLE expr RIGHT_PAR  { printf("\tΑνάθεση τιμής\n"); }
	|LEFT_PAR BIND VARIABLE read RIGHT_PAR { printf("\tΑνάθεση τιμής\n"); }
	|BIND VARIABLE expr RIGHT_PAR          { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση bind.\n"); }
	|BIND VARIABLE read RIGHT_PAR          { printf("Warning: Ξέχασες να ανοίξεις παρένθεση στην συνάρτηση bind.\n"); }
	;

%%

// Συνάρτηση για την εμφάνιση λαθών
int yyerror(char const *s) {
	printf("Error: Συντακτικό λάθος στη γραμμή %d: %s\n",line,s);
}

int main(int argc,char **argv){

	int parse = yyparse();

	// Έλεγχος ότι το πρόγραμμα έχει ολοκληρωθεί χωρίς λάθη ή όχι
	if(wrongExpressions == 0 && wrongWords == 0 && parse == 0){
		printf("\nINPUT FILE: PARSING SUCCEEDED.\n");	
	}
	else{
		printf("\nINPUT FILE: PARSING FAILED.\n");
	}

	// Εμφάνιση αποτελεσμάτων σωστών/λάθος λέξεων/εκφράσεων και warnings
	printf("Number of correct words detected : %d\n",correctWords);
	printf("Number of correct expressions detected : %d\n",correctExpressions);

	printf("Number of incorrect words detected : %d\n",wrongWords);
	printf("Number of incorrect expressions detected : %d\n",wrongExpressions);

	printf("Parsing completed with %d warnings.\n",warnings);
	
	return 0;
}
