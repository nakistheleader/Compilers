%option noyywrap
%x error

%{
#include <stdio.h>
#include <stdlib.h>

// header file που παράγει ο bison για την σωστή συνδεση του flex με τον bison
#include "teliko_y.h"


// Μεταβλητές που κάνει extern από αρχείο με τον κώδικα bison.
extern int line;            // Mεταβλητή που μετράει τις γραμμές 
extern int correctWords;    // Μεταβλητή που μετραέι τις σωστά αναγνωρισμένες λέξεις
extern int wrongWords;      // Μεταβλητή που μετράει τις λάθος αναγνωρισμένες λέξεις
extern int warnings;        // Μεταβλητή που μετράει τα warnings που μπορεί να εμφανιστούν
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
PRINTOUT_WARN   "printoutt"|"printout"|"prntout"|"prntout t"
READ_WARN       "readd"|"red"|"resd"
BIND_WARN       "bindd"|"bbind"|"bnd"|"bbnd"
VELOS_WARN      "-->"|">"|"- >"

%%
{DELIMITER}        { }
{LEFT_PAR}         { return LEFT_PAR; }
{RIGHT_PAR}        { return RIGHT_PAR; }
{OPERATOR}         { correctWords++; return OPERATOR; }
{ISON}             { correctWords++; return ISON; }
{ISON_WARN}        { printf("Warning: Έβαλες 2 ίσον.\n"); warnings++; return ISON; }
{VELOS}            { correctWords++; return VELOS; }
{VELOS_WARN}       { printf("Warning: Έγραψες λάθος το βέλος.\n"); warnings++; return VELOS; }
{INTCONST}         { correctWords++; return INTCONST; }
{FLOAT}			   { correctWords++; return FLOAT;}
{VARIABLE}	       { correctWords++; return VARIABLE; }
{COMMENTS}         { }
{DEFFACTS}         { correctWords++; return DEFFACTS; }
{DEFFACTS_WARN}    { printf("Warning: Έγραψες λάθος την συνάρτηση deffacts.\n"); warnings++; return DEFFACTS; }
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
{STRING}		   { correctWords++; return STRING; }
{ERROR}            { printf("\nΛάθος στην γραμμή: %d\n", line); BEGIN(error); wrongWords++; }
{NEWLINE}          { line++; }

<error>[ \t\n]+    { BEGIN(0); }
<error>.           { }

%%

/*
Στην αρχή του προγράμματος έχουμε δηλώσει την κατάσταση error που την χρησημοποιούμε στο πεδίο των κανόνων.
Στο πεδίο των ορισμών προσθέσαμε τους LEFT_PAR, RIGHT_PAR, ISON, DEFFACTS, DEFRULE, TEST, PRINTOUT, READ, BIND, VELOS και ERROR.

Ο LEFT_PAR αναγνωρίζει την αριστερή παρένθεση
Ο RIGHT_PAR αναγνωρίζει την δεξιά παρένθεση

Οι ορισμοί DEFFACTS, DEFRULE, TEST, PRINTOUT, READ και BIND αναγνωρίζουν τις αντίστοιχες συναρτήσεις.
Ο VELOS αναγνωρίζει το βελάκι που υπάρχει στην εντολή def
Ο ορισμός ERROR χρησημοποιείτε για τις λέξεις οι οποίες δεν είναι αναγνωρίσημες.

Επίσης έχουμε δημιουργήσει κάποιες εκφράσεις για τυχόν λάθος είσοδο από τον χρήστη.
Ο ISON_WARN αναγνωρίζει αν ο χρήστης δώσει 2 ίσον.
Οι ορισμοί DEFFACTS, DEFRULE, TEST, PRINTOUT, READ και BIND περιέχουν πιθανά ορθογραφικά λάθη που μπορεί να κάνει ο χρήστης κατά την είσοδό τους.
Ο VELOS_WARN αναγνωρίζει πιθανά λάθη στην είσοδο του βέλους.

Στο πεδίο των κανόνων έχουμε τους ορισμούς που ορίσαμε και την ενέργεια που θα εκτελεσθεί όταν αναγνωριστεί κάποιος από αυτούς.
Η σειρά των κανόνων είναι τέτοια ώστε στην αρχή να βρίσκονται οι πιο ειδικοί κανόνες και στο τέλος οι πιο γενικοί.
Επειδή ο λεκτικός αναλυτής όταν αναγνωρίσει έναν κανόνα δεν συνεχίζει την αναζήτηση στους επόμενους.
Όταν αναγνωρίζεται ένας ορισμός, αν θεωρείτε λέξη τότε αυξάνεται ο μετρητής correctWords και επιστρέφεται στο bison το αντίστοιχο token.
Οι ορισμοί warning είναι ακριβώς κάτω από τους αντίστοιχους κανόνες τους λόγω της προτεραιότητας που ισχύει.
Αν αναγνωριστεί κάποιος ορισμός warning τότε αυξάνεται ο μετρητής warnings, εμφανίζεται ανάλογο μήνυμα και επιστρέφεται το σωστό token.

Ο κανόνας NEWLINE αυξάνει τον μετρητή γραμμής ο οποίος χρησημοποιείτε σε μηνύματα προς τον χρήστη.
Έχουμε κανόνες όπως οι DELIMITER και COMMENTS όπου δεν εκτελούν κάποια ενέργεια καθώς δεν μας είναι χρήσιμα τα συγκεκριμένα token,
και τους κανόνες LEFT_PAR και RIGHT_PAR οι οποίοι απλός επιστρέφουν το token τους.

Τέλος, έχουμε μια κατάσταση error στην οποία πηγαίνουμε όταν έχουμε λάθος είσοδο (τα σύμβολα που δίνει δεν ανήκουν στο αλφάβητο) από τον χρήστη (έχει αναγνωριστεί ο κανόνας ERROR).
Σε αυτήν την κατάσταση μένουμε μέχρι να λάβουμε κάποιον διαχωριστή που σημαίνει ότι έχει τελειώσει το εκάστοτε token και επιστρέφουμε στην εκτέλεση του
προγράμματος αυξάνοντας τον μετρητή wrongWords.
*/
