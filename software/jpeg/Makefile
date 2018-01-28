CC = g++ -O3 -Wall

all: libjpeg.a

libjpeg.a: *.cpp
	$(CC) -c *.cpp
	ar rc libjpeg.a *.o
	/bin/rm -f *.o

clean:
	/bin/rm -f *.o libjpeg.a 
