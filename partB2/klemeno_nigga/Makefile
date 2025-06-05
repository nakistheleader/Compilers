all:
	bison  -o klemeno_y.c klemeno.y -d
	flex -o klemeno_l.c klemeno.l
	gcc -o bison_code klemeno_l.c klemeno_y.c -lfl -lm
clean:
	rm bison_code klemeno_l.c klemeno_y.c klemeno_y.h