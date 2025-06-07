all:
	bison  -o teliko_y.c teliko.y -d
	flex -o teliko_l.c teliko.l
	gcc -o bison_code teliko_l.c teliko_y.c -lfl -lm
clean:
	rm bison_code teliko_l.c teliko_y.c teliko_y.h
