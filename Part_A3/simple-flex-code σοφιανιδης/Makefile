all:
	flex -o simple-flex-code.c simple-flex-code.l
	gcc -o simple-flex-code simple-flex-code.c
	./simple-flex-code input.txt output.txt
clean:
	rm simple-flex-code simple-flex-code.c
