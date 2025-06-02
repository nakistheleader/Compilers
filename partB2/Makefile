all:
	bison -o simple-bison-code.c simple-bison-code.y -d
	flex -o simple-flex-code.c simple-flex-code.l
	gcc -o bison_code simple-bison-code.c simple-flex-code.c -lfl -lm
clean:
	rm bison_code simple-bison-code.c simple-flex-code.c simple-bison-code.h