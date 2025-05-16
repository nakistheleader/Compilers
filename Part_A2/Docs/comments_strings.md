## Strings

Το regex για τις συμβολοσειρές ξεκινάει και τελειώνει με ". Οποιαδήποτε είσοδος που δεν ξεκινάει με " δεν είναι δεκτή.
Μέσα η συμβολοσειρά μπορεί να είναι κένη ή όχι. Το regex κρατάει τους χαρακτήρες ```\\, \", \n``` (στο regex έχω χρησημοποιήσει διπλό ```\\```
για να πιάσει το μονό ```\```) και όσους χαρακτήρες δεν ταιριάζουν με ```", \, \n, \r```.

Regex:
```
"((\\\\)|(\\")|(\\n)|[^"\\\n\r])*"
```

Το fsm έχει 6 καταστάσεις, η κατάσταση S0 η οποία ελέγχει αν ο πρώτος χαρακτήρας που θα δεχθεί είναι τα διπλά αυτάκια ("),
αν ναι τότε προχοράει στην κατάσταση S1, στην αντίθετη περίπτωση πηγαίνει την κατάσταση BIN η οποία είναι κατάσταση καταβόθρα.
Η κατάσταση S1 ελέγχει αν λάβει το δεύτερο ", σε αυτήν την περίπτοση πήγαίνει στην κατάσταση S3, αν λάβει τον χαρακτήρα \ τότε
πηγαίνει στην κατάσταση S2, αν λάβει το new line πηγαίνει στην κατάσταση BIN και στην περίπτωση που λάβει οποιονδήποτε άλλο
χαρακτήρα μένει στην ίδια κατάσταση.
Η κατάσταση S2 ελέγχει αν μετά το πρώτο backslash \ που έχει λάβει στην κατάσταση S1 ακολουθεί ένας από τους επιτρέπτους χαρακτήρες,
δηλαδή αν ακολουθεί ```\, ", n``` τότε επιστρέφει πάλι στην κατάσταση S1, σε κάθε άλλη περίπτωση πηγαίνει στην κατάσταση BIN.
Η κατάσταση S3 ελέγχει αν μετά το δεύτερο " ακολουθεί new line ή όχι. Σε περίπτωση που ακολουθεί πηγαίνει στην κατάσταση GOOD,
σε κάθε άλλη περίπτωση πηγαίνει στην κατάσταση BIN διότι δεν μπορει να ακολουθεί άλλος χαρακτήρας αφού κλείσει η συμβολοσειρά.
Η κατάσταση BIN παραμένει στον εαυτό της για οποιονδήποτε χαρακτήρα λάβει μέχρι τον χαρακτήρα EOF όπου θα τερματίσει με BAD, αυτό γίνεται διότι από την στιγμή που έχει φτάσει εκεί από μία προηγούμενη κατάσταση σήμαίνει ότι η είσοδος είναι λάθος, άρα ότι και να
ακολουθεί δεν μας ενδιαφέρει. 
Η κατάσταση GOOD είναι η επιθημητή/έγκυρη κατάσταση. Σε περίπτωση που λάβει EOF τότε θα παραμένει στον εαυτό της. Σε οποιαδήποτε άλλη περίπτωση θα πηγαίνει στην κατάσταση ΒΙΝ διότη μετά το new line που θα έχει δώσει ο χρήστης δεν μπορεί να λάβει κάποιον άλλο χαρακτήρα. Το fsm δέχεται μόνο έναν χαρακτήρα new line και όχι παραπάνω καθώς είναι δουλειά των διαχωριστών.

FSM:
```
START=S0
S0:
    " -> S1
    * -> BIN
S1:
    " -> S3
    \\ -> S2
    * -> S1
    \n -> BIN
S2:
    \\ " n -> S1
    * -> BIN
S3:
    \n -> GOOD
    * -> BIN
BIN:
    EOF -> BAD
    * -> BIN
GOOD(OK):
    EOF -> GOOD
    * -> BIN

```

## Comments

Το regex για τα σχόλια θα πρέπει αν κρατάει μόνο τους χαρακτήρες που έπονται του ερωτηματικού.
Για αυτόν τον λόγο το regex ξεκινάει με το ερωτηματικό και μπορεί να ακολουθήσει οποιοσδήποτε χαρακτήρας.

Regex:
```
;.*
```

Το fsm έχει 4 καταστάσεις, την εναρκτήρια S0 η οποία ελέγχει αν ο πρώτος χαρακτήρας που θα δεχθεί είναι το ερωτηματικό, αν ναι τότε προχοράει στην κατάσταση S1, στην αντίθετη περίπτωση πηγαίνει την κατάσταση BIN η οποία είναι κατάσταση καταβόθρα.
Η κατάσταση S1 δέχεται όλους τους χαρακτήρες που ακολουθούν και όταν λάβει τον χαρακτήρα 'new line' ή 'EOF' πηγαίνη στην κατάσταση GOOD.
Η κατάσταση BIN παραμένει στον εαυτό της για οποιονδήποτε χαρακτήρα λάβει μέχρι τον χαρακτήρα EOF όπου θα τερματίσει με BAD, αυτό γίνεται διότι σε περίπτωση που ξεκιναέι χωρίς το ερωτηματικό - άρα δεν είναι σχόλιο - δεν μας ενδιαφέρει τι ακολουθει γιατί δεν είναι έγκυρο.
Η κατάσταση BAD σημαίνει πως το σχόλιο δεν είναι έγκυρο. 
Η κατάσταση GOOD είναι η επιθημητή/έγκυρη κατάσταση. Σε περίπτωση που λάβει EOF τότε θα παραμένει στον εαφτό της. Σε οποιαδήποτε άλλη περίπτωση θα πηγαίνει στην κατάσταση ΒΙΝ διότη μετά το new line που θα έχει δώσει ο χρήστης δεν μπορεί αν λάβει κάποιον άλλο χαρακτήρα.
Το fsm δέχεται μόνο έναν χαρακτήρα new line και όχι παραπάνω καθώς είναι δουλειά των διαχωριστών.

FSM:
```
START=S0
S0:
    ; -> S1
    * -> BIN
S1:
    * -> S1
    \n, EOF -> GOOD
BIN:
    * -> BIN
    EOF -> BAD
GOOD(OK): 
    EOF -> GOOD
    * -> BIN

```

## Εξαντλητικοί έλεγχοι

### Συμβολοσειρές

Το fsm των συμβολοσειρών δέχεται μόνο τις εισόδους που ξεκινούν και τελειώνουν με διπλά αυτάκια. Μέσα στην συμβολοσειρά επιτρέπετε
να χρησημοποιήσουμε μόνο 3 συνδιασμούς χαρακτήρων με το backslash και είναι οι ακόλουθει ```\\, \", \n```, συν όσους χαρακτήρες δεν
ταιριάζουν με ```", \, \n, \r```. Οι συμβολοσειρές τερματίζουν με new line ή EOF μετά από το δεύτερο ".
Αν δεχτεί περισσότερους του ενός χαρακτήρες new line δεν είναι δεχτό καθώς είναι αρμοδιότητα των διαχωριστών.

Επίδηξη σωστών εισόδων συμβολοσειρών:

- Ανάδηξη συμβολοσειράς μόνο με αυτάκια

```
$ fsm -trace strings.fsm  
""
s0 " -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με χαρακτήρες αλφαβήτου

```
$ fsm -trace strings.fsm    
"asdsadf"
s0 " -> s1 
s1 a -> s1 
s1 s -> s1 
s1 d -> s1 
s1 s -> s1 
s1 a -> s1 
s1 d -> s1 
s1 f -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με αριθμούς

```
$ fsm -trace strings.fsm
"12345324"
s0 " -> s1 
s1 1 -> s1 
s1 2 -> s1 
s1 3 -> s1 
s1 4 -> s1 
s1 5 -> s1 
s1 3 -> s1 
s1 2 -> s1 
s1 4 -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με χαρακτήρες εκτός αλφαβήτου

```
$ fsm -trace strings.fsm
"!#$@%$%#"
s0 " -> s1 
s1 ! -> s1 
s1 # -> s1 
s1 $ -> s1 
s1 @ -> s1 
s1 % -> s1 
s1 $ -> s1 
s1 % -> s1 
s1 # -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές κενών

```
$ fsm -trace strings.fsm
"  "
s0 " -> s1 
s1 \s -> s1 
s1 \s -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές tabs

```
$ fsm -trace strings.fsm
"               "
s0 " -> s1 
s1 \t -> s1 
s1 \t -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές κενών/tabs και χαρακτήρες

```
$ fsm -trace strings.fsm
"alsnd 2143     @#%"
s0 " -> s1 
s1 a -> s1 
s1 l -> s1 
s1 s -> s1 
s1 n -> s1 
s1 d -> s1 
s1 \s -> s1 
s1 2 -> s1 
s1 1 -> s1 
s1 4 -> s1 
s1 3 -> s1 
s1 \t -> s1 
s1 @ -> s1 
s1 # -> s1 
s1 % -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με ανάμηκτους χαρακτήρες

```
$ fsm -trace strings.fsm
"sjfd#%$#@9876432"
s0 " -> s1 
s1 s -> s1 
s1 j -> s1 
s1 f -> s1 
s1 d -> s1 
s1 # -> s1 
s1 % -> s1 
s1 $ -> s1 
s1 # -> s1 
s1 @ -> s1 
s1 9 -> s1 
s1 8 -> s1 
s1 7 -> s1 
s1 6 -> s1 
s1 4 -> s1 
s1 3 -> s1 
s1 2 -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με τους αποδεκτούς συνδιασμών χαρακτήρων με το backslash

```
$ fsm -trace strings.fsm
"lksdf\\2834\"!@$32\n"
s0 " -> s1 
s1 l -> s1 
s1 k -> s1 
s1 s -> s1 
s1 d -> s1 
s1 f -> s1 
s1 \ -> s2 
s2 \ -> s1 
s1 2 -> s1 
s1 8 -> s1 
s1 3 -> s1 
s1 4 -> s1 
s1 \ -> s2 
s2 " -> s1 
s1 ! -> s1 
s1 @ -> s1 
s1 $ -> s1 
s1 3 -> s1 
s1 2 -> s1 
s1 \ -> s2 
s2 n -> s1 
s1 " -> s3 
s3 \n -> good 
good EOF -> good 
YES
```

Επίδηξη λάθων εισόδων συμβολοσειρών:

- Ανάδηξη λανθασμένης συμβολοσειράς που περιέχει backslash

```
$ fsm -trace strings.fsm
"scbds\mklsd"
s0 " -> s1 
s1 s -> s1 
s1 c -> s1 
s1 b -> s1 
s1 d -> s1 
s1 s -> s1 
s1 \ -> s2 
s2 m -> bin 
bin k -> bin 
bin l -> bin 
bin s -> bin 
bin d -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που περιέχει τον χαρακτήρα " χωρίς το backslah πριν από αυτό

```
$ fsm -trace strings.fsm
"slkjdnc"ckjsdnc"
s0 " -> s1 
s1 s -> s1 
s1 l -> s1 
s1 k -> s1 
s1 j -> s1 
s1 d -> s1 
s1 n -> s1 
s1 c -> s1 
s1 " -> s3 
s3 c -> bin 
bin k -> bin 
bin j -> bin 
bin s -> bin 
bin d -> bin 
bin n -> bin 
bin c -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που έχει πολλά new lines στο τέλος της

```
$ fsm -trace strings.fsm
"kjsdf"
s0 " -> s1 
s1 k -> s1 
s1 j -> s1 
s1 s -> s1 
s1 d -> s1 
s1 f -> s1 
s1 " -> s3 
s3 \n -> good 

good \n -> bin 

bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που αλλάζει γραμμή πριν κλείσει με το δεύτερο "

```
$ fsm -trace strings.fsm
"kajsnda
s0 " -> s1 
s1 k -> s1 
s1 a -> s1 
s1 j -> s1 
s1 s -> s1 
s1 n -> s1 
s1 d -> s1 
s1 a -> s1 
s1 \n -> bin 
kasj"
bin k -> bin 
bin a -> bin 
bin s -> bin 
bin j -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που δεν κλείνει με "

```
$ fsm -trace strings.fsm
"ASdasd
s0 " -> s1 
s1 A -> s1 
s1 S -> s1 
s1 d -> s1 
s1 a -> s1 
s1 s -> s1 
s1 d -> s1 
s1 \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που έχει backslash πριν το " που κλείνει την συμβολοσειρά

```
$ fsm -trace strings.fsm
"akhsb\"
s0 " -> s1 
s1 a -> s1 
s1 k -> s1 
s1 h -> s1 
s1 s -> s1 
s1 b -> s1 
s1 \ -> s2 
s2 " -> s1 
s1 \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που ξεκινάει με χαρακτήρα αλφαβήτου

```
$ fsm -trace strings.fsm
jas"kasjn"
s0 j -> bin 
bin a -> bin 
bin s -> bin 
bin " -> bin 
bin k -> bin 
bin a -> bin 
bin s -> bin 
bin j -> bin 
bin n -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που ξεκινάει χωρίς "

```
$ fsm -trace strings.fsm
lkamsd"
s0 l -> bin 
bin k -> bin 
bin a -> bin 
bin m -> bin 
bin s -> bin 
bin d -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που ξεκινάει με κενό/tabs

```
$ fsm -trace strings.fsm
        "kajnds"
s0 \s -> bin 
bin \s -> bin 
bin \t -> bin 
bin " -> bin 
bin k -> bin 
bin a -> bin 
bin j -> bin 
bin n -> bin 
bin d -> bin 
bin s -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

### Σχόλια

Το fsm των σχολίων δέχεται μόνο τις εισόδους που ξεκινούν με το ερωτηματικό ; μετά από αυτό μπορεί αν ακολουθεί οποιοσδήποτε
χαρακτήρας. Το κάθε σχόλιο τελειώνει με τον χαρακτήρα new line ή EOF. Αν δεχτεί περισσότερους του ενός χαρακτήρες new line
δεν είναι δεχτό καθώς είναι αρμοδιότητα των διαχωριστών.

Επίδηξη σωστών εισόδων σχολίων:

- Ανάδηξη σχολίου με χαρακτήρες αλφαβήτου

```
$ fsm -trace a2_comments.fsm            
;kazndsfks
s0 ; -> s1 
s1 k -> s1 
s1 a -> s1 
s1 z -> s1 
s1 n -> s1 
s1 d -> s1 
s1 s -> s1 
s1 f -> s1 
s1 k -> s1 
s1 s -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με αριθμούς

```
$ fsm -trace a2_comments.fsm
;2398745       
s0 ; -> s1 
s1 2 -> s1 
s1 3 -> s1 
s1 9 -> s1 
s1 8 -> s1 
s1 7 -> s1 
s1 4 -> s1 
s1 5 -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με χαρακτήρες εκτός αλφαβήτου

```
$ fsm -trace a2_comments.fsm
;@#%^%%$#">?"<{<>"
s0 ; -> s1 
s1 @ -> s1 
s1 # -> s1 
s1 % -> s1 
s1 ^ -> s1 
s1 % -> s1 
s1 % -> s1 
s1 $ -> s1 
s1 # -> s1 
s1 " -> s1 
s1 > -> s1 
s1 ? -> s1 
s1 " -> s1 
s1 < -> s1 
s1 { -> s1 
s1 < -> s1 
s1 > -> s1 
s1 " -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με διαχωριστές κενών/tabs και χαρακτήρες αλφαβήτου

```
$ fsm -trace a2_comments.fsm
;ksjdbn sdjkfbi
s0 ; -> s1 
s1 k -> s1 
s1 s -> s1 
s1 j -> s1 
s1 d -> s1 
s1 b -> s1 
s1 n -> s1 
s1 \s -> s1 
s1 s -> s1 
s1 d -> s1 
s1 j -> s1 
s1 k -> s1 
s1 f -> s1 
s1 b -> s1 
s1 i -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με ανάμηκτους χαρακτήρες

```
$ fsm -trace a2_comments.fsm
;aksjb091!@#:{P
s0 ; -> s1 
s1 a -> s1 
s1 k -> s1 
s1 s -> s1 
s1 j -> s1 
s1 b -> s1 
s1 0 -> s1 
s1 9 -> s1 
s1 1 -> s1 
s1 ! -> s1 
s1 @ -> s1 
s1 # -> s1 
s1 : -> s1 
s1 { -> s1 
s1 P -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με ανάμηκτους χαρακτήρες και χαρακτήρες κενών/tabs

```
$ fsm -trace a2_comments.fsm
;skjdnf 1234            @#!%$#?":">
s0 ; -> s1 
s1 s -> s1 
s1 k -> s1 
s1 j -> s1 
s1 d -> s1 
s1 n -> s1 
s1 f -> s1 
s1 \s -> s1 
s1 1 -> s1 
s1 2 -> s1 
s1 3 -> s1 
s1 4 -> s1 
s1 \s -> s1 
s1 \t -> s1 
s1 \t -> s1 
s1 @ -> s1 
s1 # -> s1 
s1 ! -> s1 
s1 % -> s1 
s1 $ -> s1 
s1 # -> s1 
s1 ? -> s1 
s1 " -> s1 
s1 : -> s1 
s1 " -> s1 
s1 > -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου που τελειώνει με EOF

```
$ fsm -trace a2_comments.fsm
;jaha 234@#$ds0 ; -> s1 
s1 j -> s1 
s1 a -> s1 
s1 h -> s1 
s1 a -> s1 
s1 \s -> s1 
s1 2 -> s1 
s1 3 -> s1 
s1 4 -> s1 
s1 @ -> s1 
s1 # -> s1 
s1 $ -> s1 
s1 d -> s1 
s1 EOF -> good 
YES
```

- Ανάδηξη σχολίου που έχει μόνο το ερωτηματικό

```
$ fsm -trace a2_comments.fsm
;
s0 ; -> s1 
s1 \n -> good 
good EOF -> good 
YES
```

Επίδηξη λάθων εισόδων σχολίων:

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με χαρακτήρα αλφαβήτου

```
$ fsm -trace a2_comments.fsm
asd;asd
s0 a -> bin 
bin s -> bin 
bin d -> bin 
bin ; -> bin 
bin a -> bin 
bin s -> bin 
bin d -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με αριθμό

```
$ fsm -trace a2_comments.fsm
12;jknfds0 1 -> bin 
bin 2 -> bin 
bin ; -> bin 
bin j -> bin 
bin k -> bin 
bin n -> bin 
bin f -> bin 
bin d -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με χαρακτήρα εκτός αλφαβήτου και εκτός του ερωτηματικού

```
$ fsm -trace a2_comments.fsm
@#$;mjkd
s0 @ -> bin 
bin # -> bin 
bin $ -> bin 
bin ; -> bin 
bin m -> bin 
bin j -> bin 
bin k -> bin 
bin d -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με κενό

```
$ fsm -trace a2_comments.fsm
  ;   
s0 \s -> bin 
bin \s -> bin 
bin ; -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με tabs

```
$ fsm -trace a2_comments.fsm
        ;asd
s0 \t -> bin 
bin ; -> bin 
bin a -> bin 
bin s -> bin 
bin d -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που έχει συνδιασμό χαρακτήρων πριν το ερωτηματικό

```
$ fsm -trace a2_comments.fsm
kas234@#$;as
s0 k -> bin 
bin a -> bin 
bin s -> bin 
bin 2 -> bin 
bin 3 -> bin 
bin 4 -> bin 
bin @ -> bin 
bin # -> bin 
bin $ -> bin 
bin ; -> bin 
bin a -> bin 
bin s -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου χωρίς ερωτηματικό

```
$ fsm -trace a2_comments.fsm
sh a         
s0 s -> bin 
bin h -> bin 
bin \s -> bin 
bin a -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου με πολλά new line

```
$ fsm -trace a2_comments.fsm
;ka 21        
s0 ; -> s1 
s1 k -> s1 
s1 a -> s1 
s1 \s -> s1 
s1 2 -> s1 
s1 1 -> s1 
s1 \n -> good 

good \n -> bin 

bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με new line

```
$ fsm -trace a2_comments.fsm

s0 \n -> bin 
;
bin ; -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```
