CC = g++ -O3 -Wall

all: libim.a

libim.a: im*.cpp im*.h
	$(CC) -c im_color.cpp im_complex.cpp im_float.cpp im_short.cpp
	ar rc libim.a *.o
	/bin/rm -f *.o
	g++ -c *3d.cpp

clean:
	/bin/rm -f *.o libim.a

