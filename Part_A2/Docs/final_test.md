## Σχόλια

Επίδηξη σωστών εισόδων σχολίων:

- Ανάδηξη σχολίου με χαρακτήρες αλφαβήτου

```
$ fsm -trace final_fsm.fsm
;kazndsfks
s0 ; -> comments 
comments k -> comments 
comments a -> comments 
comments z -> comments 
comments n -> comments 
comments d -> comments 
comments s -> comments 
comments f -> comments 
comments k -> comments 
comments s -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με αριθμούς

```
$ fsm -trace final_fsm.fsm
;2398745
s0 ; -> comments 
comments 2 -> comments 
comments 3 -> comments 
comments 9 -> comments 
comments 8 -> comments 
comments 7 -> comments 
comments 4 -> comments 
comments 5 -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με χαρακτήρες εκτός αλφαβήτου

```
$ fsm -trace final_fsm.fsm
;@#%^%%$#">?"<{<>"
s0 ; -> comments 
comments @ -> comments 
comments # -> comments 
comments % -> comments 
comments ^ -> comments 
comments % -> comments 
comments % -> comments 
comments $ -> comments 
comments # -> comments 
comments " -> comments 
comments > -> comments 
comments ? -> comments 
comments " -> comments 
comments < -> comments 
comments { -> comments 
comments < -> comments 
comments > -> comments 
comments " -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με διαχωριστές κενών/tabs και χαρακτήρες αλφαβήτου

```
$ fsm -trace final_fsm.fsm
;ksjdbn sdjkfbi
s0 ; -> comments 
comments k -> comments 
comments s -> comments 
comments j -> comments 
comments d -> comments 
comments b -> comments 
comments n -> comments 
comments \s -> comments 
comments s -> comments 
comments d -> comments 
comments j -> comments 
comments k -> comments 
comments f -> comments 
comments b -> comments 
comments i -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με ανάμηκτους χαρακτήρες

```
$ fsm -trace final_fsm.fsm
;aksjb091!@#:{P
s0 ; -> comments 
comments a -> comments 
comments k -> comments 
comments s -> comments 
comments j -> comments 
comments b -> comments 
comments 0 -> comments 
comments 9 -> comments 
comments 1 -> comments 
comments ! -> comments 
comments @ -> comments 
comments # -> comments 
comments : -> comments 
comments { -> comments 
comments P -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου με ανάμηκτους χαρακτήρες και χαρακτήρες κενών/tabs

```
$ fsm -trace final_fsm.fsm
;skjdnf 1234            @#!%$#?":">
s0 ; -> comments 
comments s -> comments 
comments k -> comments 
comments j -> comments 
comments d -> comments 
comments n -> comments 
comments f -> comments 
comments \s -> comments 
comments 1 -> comments 
comments 2 -> comments 
comments 3 -> comments 
comments 4 -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments \s -> comments 
comments @ -> comments 
comments # -> comments 
comments ! -> comments 
comments % -> comments 
comments $ -> comments 
comments # -> comments 
comments ? -> comments 
comments " -> comments 
comments : -> comments 
comments " -> comments 
comments > -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου που τελειώνει με EOF

```
$ fsm -trace final_fsm.fsm
;jaha 234@#$ds0 ; -> comments 
comments j -> comments 
comments a -> comments 
comments h -> comments 
comments a -> comments 
comments \s -> comments 
comments 2 -> comments 
comments 3 -> comments 
comments 4 -> comments 
comments @ -> comments 
comments # -> comments 
comments $ -> comments 
comments d -> comments 
comments EOF -> good 
YES
```

- Ανάδηξη σχολίου που έχει μόνο το ερωτηματικό

```
$ fsm -trace final_fsm.fsm
;
s0 ; -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου που ξεκινάει με κενό, στο τελικό fsm είναι σωστό καθώς υπάρχουν οι διαχωριστές

```
$ fsm -trace final_fsm.fsm
  ; 
s0 \s -> s0 
s0 \s -> s0 
s0 ; -> comments 
comments \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη σχολίου που ξεκινάει με tabs, στο τελικό fsm είναι σωστό καθώς υπάρχουν οι διαχωριστές

```
$ fsm -trace final_fsm.fsm
        ;asd
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 ; -> comments 
comments a -> comments 
comments s -> comments 
comments d -> comments 
comments \n -> good 
good EOF -> good 
YES
```

Επίδηξη λάθων εισόδων σχολίων:

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με χαρακτήρα αλφαβήτου

```
$ fsm -trace final_fsm.fsm
asd;asd
s0 a -> names_s1 
names_s1 s -> names_s1 
names_s1 d -> names_s1 
names_s1 ; -> bin 
bin a -> bin 
bin s -> bin 
bin d -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με αριθμό

```
$ fsm -trace final_fsm.fsm
12;jknfd
s0 1 -> num_s3 
num_s3 2 -> num_s3 
num_s3 ; -> bin 
bin j -> bin 
bin k -> bin 
bin n -> bin 
bin f -> bin 
bin d -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου που ξεκινάει με χαρακτήρα εκτός αλφαβήτου και εκτός του ερωτηματικού

```
$ fsm -trace final_fsm.fsm
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

- Ανάδηξη λανθασμένου σχολίου που έχει συνδιασμό χαρακτήρων πριν το ερωτηματικό

```
$ fsm -trace final_fsm.fsm
kas234@#$;as
s0 k -> names_s1 
names_s1 a -> names_s1 
names_s1 s -> names_s1 
names_s1 2 -> names_s1 
names_s1 3 -> names_s1 
names_s1 4 -> names_s1 
names_s1 @ -> bin 
bin # -> bin 
bin $ -> bin 
bin ; -> bin 
bin a -> bin 
bin s -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένου σχολίου με πολλά new line

```
$ fsm -trace final_fsm.fsm
;ka 21
s0 ; -> comments 
comments k -> comments 
comments a -> comments 
comments \s -> comments 
comments 2 -> comments 
comments 1 -> comments 
comments \n -> good 

good \n -> bin 

bin \n -> bin 
bin EOF -> bad 
NO
```

## Συμβολοσειρές

Επίδηξη σωστών εισόδων συμβολοσειρών:

- Ανάδηξη συμβολοσειράς μόνο με αυτάκια

```
$ fsm -trace final_fsm.fsm
""
s0 " -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με χαρακτήρες αλφαβήτου

```
$ fsm -trace final_fsm.fsm
"asdsadf"
s0 " -> strings 
strings a -> strings 
strings s -> strings 
strings d -> strings 
strings s -> strings 
strings a -> strings 
strings d -> strings 
strings f -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με αριθμούς

```
$ fsm -trace final_fsm.fsm
"12345324"
s0 " -> strings 
strings 1 -> strings 
strings 2 -> strings 
strings 3 -> strings 
strings 4 -> strings 
strings 5 -> strings 
strings 3 -> strings 
strings 2 -> strings 
strings 4 -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με χαρακτήρες εκτός αλφαβήτου

```
$ fsm -trace final_fsm.fsm
"!#$@%$%#"
s0 " -> strings 
strings ! -> strings 
strings # -> strings 
strings $ -> strings 
strings @ -> strings 
strings % -> strings 
strings $ -> strings 
strings % -> strings 
strings # -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές κενών

```
$ fsm -trace final_fsm.fsm
"  "
s0 " -> strings 
strings \s -> strings 
strings \s -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές tabs

```
$ fsm -trace final_fsm.fsm
"               "
s0 " -> strings 
strings \t -> strings 
strings \t -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με διαχωριστές κενών/tabs και χαρακτήρες

```
$ fsm -trace final_fsm.fsm
"alsnd 2143     @#%"
s0 " -> strings 
strings a -> strings 
strings l -> strings 
strings s -> strings 
strings n -> strings 
strings d -> strings 
strings \s -> strings 
strings 2 -> strings 
strings 1 -> strings 
strings 4 -> strings 
strings 3 -> strings 
strings \s -> strings 
strings \s -> strings 
strings \s -> strings 
strings \s -> strings 
strings \s -> strings 
strings @ -> strings 
strings # -> strings 
strings % -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με ανάμηκτους χαρακτήρες

```
$ fsm -trace final_fsm.fsm
"sjfd#%$#@9876432"
s0 " -> strings 
strings s -> strings 
strings j -> strings 
strings f -> strings 
strings d -> strings 
strings # -> strings 
strings % -> strings 
strings $ -> strings 
strings # -> strings 
strings @ -> strings 
strings 9 -> strings 
strings 8 -> strings 
strings 7 -> strings 
strings 6 -> strings 
strings 4 -> strings 
strings 3 -> strings 
strings 2 -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς με τους αποδεκτούς συνδιασμών χαρακτήρων με το backslash

```
$ fsm -trace final_fsm.fsm
"lksdf\\2834\"!@$32\n"
s0 " -> strings 
strings l -> strings 
strings k -> strings 
strings s -> strings 
strings d -> strings 
strings f -> strings 
strings \ -> strings_s2 
strings_s2 \ -> strings 
strings 2 -> strings 
strings 8 -> strings 
strings 3 -> strings 
strings 4 -> strings 
strings \ -> strings_s2 
strings_s2 " -> strings 
strings ! -> strings 
strings @ -> strings 
strings $ -> strings 
strings 3 -> strings 
strings 2 -> strings 
strings \ -> strings_s2 
strings_s2 n -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

- Ανάδηξη συμβολοσειράς που ξεκινάει με κενό/tabs, στο τελικό fsm είναι σωστό καθώς υπάρχουν οι διαχωριστές

```
$ fsm -trace final_fsm.fsm
                "kajnds"
s0 \s -> s0 
s0 \s -> s0 
s0 \s -> s0 
s0 \t -> s0 
s0 \t -> s0 
s0 " -> strings 
strings k -> strings 
strings a -> strings 
strings j -> strings 
strings n -> strings 
strings d -> strings 
strings s -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 
good EOF -> good 
YES
```

Επίδηξη λάθων εισόδων συμβολοσειρών:

- Ανάδηξη λανθασμένης συμβολοσειράς που περιέχει backslash

```
$ fsm -trace final_fsm.fsm
"scbds\mklsd"
s0 " -> strings 
strings s -> strings 
strings c -> strings 
strings b -> strings 
strings d -> strings 
strings s -> strings 
strings \ -> strings_s2 
strings_s2 m -> bin 
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
$ fsm -trace final_fsm.fsm
"slkjdnc"ckjsdnc"
s0 " -> strings 
strings s -> strings 
strings l -> strings 
strings k -> strings 
strings j -> strings 
strings d -> strings 
strings n -> strings 
strings c -> strings 
strings " -> strings_s1 
strings_s1 c -> bin 
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
$ fsm -trace final_fsm.fsm
"kjsdf"
s0 " -> strings 
strings k -> strings 
strings j -> strings 
strings s -> strings 
strings d -> strings 
strings f -> strings 
strings " -> strings_s1 
strings_s1 \n -> good 

good \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που αλλάζει γραμμή πριν κλείσει με το δεύτερο "

```
$ fsm -trace final_fsm.fsm
"kajsnda
s0 " -> strings 
strings k -> strings 
strings a -> strings 
strings j -> strings 
strings s -> strings 
strings n -> strings 
strings d -> strings 
strings a -> strings 
strings \n -> bin 
skljnd"
bin s -> bin 
bin k -> bin 
bin l -> bin 
bin j -> bin 
bin n -> bin 
bin d -> bin 
bin " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που δεν κλείνει με "

```
$ fsm -trace final_fsm.fsm
"ASdasd
s0 " -> strings 
strings A -> strings 
strings S -> strings 
strings d -> strings 
strings a -> strings 
strings s -> strings 
strings d -> strings 
strings \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που έχει backslash πριν το " που κλείνει την συμβολοσειρά

```
$ fsm -trace final_fsm.fsm
"akhsb\"
s0 " -> strings 
strings a -> strings 
strings k -> strings 
strings h -> strings 
strings s -> strings 
strings b -> strings 
strings \ -> strings_s2 
strings_s2 " -> strings 
strings \n -> bin 
bin EOF -> bad 
NO
```

- Ανάδηξη λανθασμένης συμβολοσειράς που ξεκινάει με χαρακτήρα αλφαβήτου

```
$ fsm -trace final_fsm.fsm
jas"kasjn"
s0 j -> names_s1 
names_s1 a -> names_s1 
names_s1 s -> names_s1 
names_s1 " -> bin 
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
$ fsm -trace final_fsm.fsm
lkamsd"
s0 l -> names_s1 
names_s1 k -> names_s1 
names_s1 a -> names_s1 
names_s1 m -> names_s1 
names_s1 s -> names_s1 
names_s1 d -> names_s1 
names_s1 " -> bin 
bin \n -> bin 
bin EOF -> bad 
NO
```
