/* Onoma arxeiou:       simple-flex-code.l
   Perigrafh:           Ypodeigma gia anaptyksh lektikou analyth me xrhsh tou ergaleiou Flex
   Syggrafeas:          Ergasthrio Metaglwttistwn, Tmhma Mhxanikwn Plhroforikhs kai Ypologistwn,
                        Panepisthmio Dytikhs Attikhs
   Sxolia:              To paron programma ylopoiei (me th xrhsh flex) enan aplo lektiko analyth
			pou anagnwrizei kena (space kai tab) kai akeraious (dekadikou systhmatos
			mono!) gia th glwssa Uni-CLIPS enw diaxeirizetai tous eidikous xarakthres
			neas grammhs '\n' (new line) kai 'EOF' (end of file). Yparxoun anafores
			gia thn anagnwrish metablhtwn, me ton pragmatiko kwdika na exei antikatastathei
			apo to lektiko FILL ME wste na symplhrwthei apo esas. Proairetika o lektikos
			analyths dexetai orismata arxeiwn gia eisodo kai eksodo.
   Odhgies ekteleshs:   Dinete "make" xwris ta eisagwgika ston trexonta katalogo. Enallaktika:
			flex -o simple-flex-code.c simple-flex-code.l
                        gcc -o simple-flex-code simple-flex-code.c
                        ./simple-flex-code
*/

/* H anagnwsh periorizetai se ena mono arxeio kai termatizei sto prwto EOF */
%option noyywrap


/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens */
/* Κάνουμε include το αρχείο με τα tokens που χρησιμοποιούμε στον λεκτικό μας αναλυτή. Το αρχείο περιέχει το όνομα των tokens και τον αριθμό που τους αντιστοιχεί */
#include "token.h"

/* Orismos metrhth trexousas grammhs */
/* Μεταβλητή η οποία χρησιμεύει στην καταμέτρηση των γραμμών. Χρησιμοποιήτε στην εμφάνιση των μηνυμάτων προς τον χρήστη,
   για να ξέρει σε ποια γραμμή είναι τα tokens που αναγνώρισε ο λεκτικός αναλυτής. */
int line = 1;

%}


/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makroskelwn kai dysnohtwn, kanonikwn ekfrasewn */

/* Εδώ έχουμε ορίσει τις κανονικέσ εκφράσεις και τα ονόματα που τους αντιστοιχούν.
   Τα ονόματα αυτά χρησιμοποιούνται στην συνέχεια στους κανόνες που έχουμε δώσεισ τον λεκτίκο μας αναλυτή.  */

STORED_WORD     (deffacts|defrule|test|bind|read|printout)
DELIMITER       [ \t]+
INTCONST        0|[+-]?[1-9]+[0-9]*
VARIABLE	\?[A-Za-z0-9]+
FACT_RULE_NAME  [A-Za-z]([A-Za-z0-9_-])*
COMMENT         ;.*
FLOAT           [+-]?[0-9]+(([eE][+-]?[0-9]+)|\.[0-9]+[eE][+-]?[0-9]+|\.[0-9]+)
STRING          \"((\\\\)|(\\\")|(\\n)|[^\"\\\n\r])*\"
OPERATOR        =|\+|-|\*|\/
UNKNOWN_TOKEN   [^ \t;\n\r/]+


/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias arithmhtikhs timhs mesw ths synarthshs yylex() */

/* Ανάμεσα στα διπλά %% έχουμε ορίσει τους κανόνες του λεκτικού μας αναλητή.
   Αριστέρα είναι η κανονική έκφραση που θα ελενξεί που ταιριάζουν τα tokens και δεξιά βρήσκεται η τιμή που θα επιστρέψει στην yylex.
   Σε περίπτωση που λάβουμε τον χαρακτήρα νέας γραμμής, τότε αυξάνουμε κατά ένα τον μετρητή γραμμών και έπειτα αλλάζουμε γραμμή.
   Όταν λάβουμε τον χαρακτήρα EOF τότε εμφανίζουμε το ανάλογο μήνυμα. */
%%

{STORED_WORD}	 { return STORED_WORD; }
{DELIMITER}      { return DELIMITER; }
{INTCONST}       { return INTCONST; }
{VARIABLE}	 { return VARIABLE; }
{FACT_RULE_NAME} { return FACT_RULE_NAME; }
{COMMENT}	 { return COMMENT; }
{FLOAT}	         { return FLOAT; }
{STRING}	 { return STRING; }
{OPERATOR}	 { return OPERATOR; }
{UNKNOWN_TOKEN}	 { return UNKNOWN_TOKEN; }
\n               { line++; printf("\n"); }
<<EOF>>		 { printf("#END-OF-FILE#\n"); exit(0); }

%%

/* Pinakas me ola ta tokens se antistoixia me tous orismous sto token.h */
/* Ο πίνακας tname περιέχει όλα τα ονόματα των tokens που χρησιμοποιούμε στον λεκτικό μας αναλυτή.
   Είναι με την ίδια σειρά με αυτή που βρίσκονται στο αρχείο token.h. */
char *tname[] = {"STORED_WORD","DELIMITER", "INTCONST", "VARIABLE", "FACT_RULE_NAME", "COMMENT","FLOAT","STRING","OPERATOR","UNKNOWN TOKEN"};


/* H synarthsh main: O kwdikas autos tha topotheththei autousios sto
   programma C pou tha dhmiourghsei to Flex kai tha apotelesei to arxiko
   shmeio ekteleshs ths efarmoghs tou lektikou analyth. */

int main(int argc, char **argv){
        int token;

        /* Ginetai o elegxos twn orismatwn ths grammhs entolwn. Ean ta
           orismata einai 3, to programma diabazei apo to arxeio tou 2ou
           orismatos kai grafei sto arxeio tou 3ou. Ean ta orismata einai
           2 diabazei apo to arxeio tou 2ou kai grafei sthn othonh.
           Ypenthymizetai oti to 1o orisma (argv[0]) sth C einai to onoma
           tou idiou tou ektelesimou arxeiou. */

        if(argc == 3){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
                if(!(yyout = fopen(argv[2], "w"))) {
                        fprintf(stderr, "Cannot create file: %s\n", argv[2]);
                        return 1;
                }
        }
        else if(argc == 2){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
        }

        /* Η συνάρτηση yylex διαβάζει χαρακτήρες από την είσοδο και προσπαθεί να αναγνωρίσει tokens.
           Τα tokens που αναγνωρίζει είναι αυτά που έχουν οριστεί στο παρόν αρχείο, ανάμεσα στα %% και %% (οι κανόνες του λεκτικού αναλυτή).
           Αν ο κώδικας που αντιστοιχεί σε κάποιο pattern περιέχει την εντολή return ΤΙΜΗ, η yylex()
           επιστρέφει την τιμή αυτή, η οποία και αποθηκεύεται στη μεταβλητή token. Η τιμή που επιστρέφει είναι αυτή που έχουμε ορίσει
           στο αρχείο token.h */

        while( (token=yylex()) >= 0){
                /* Για κάθε token που αναγνωρίστηκε, εκτυπώνεται η γραμμή στην οποία βρέθηκε,
                καθώς και το όνομά του μαζί με την τιμή του. Έχουμε βάλει με την σωστή σειρά τα tokens στον πίνακα tname
                ώστε να εμφανίζονται τα αντίστοιχα ονόματα tokens. */

                fprintf(yyout, "\tLine=%d, token=%s, value=\"%s\"\n", line, tname[token-1], yytext);
        }
        return 0;
}