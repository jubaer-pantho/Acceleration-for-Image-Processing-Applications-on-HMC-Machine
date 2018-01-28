#define JPEG_GRAY 1
#define JPEG_RGB 3
#include "jpeglib.h"

FILE *JPEG_open(char *filename);
void JPEG_read_header(FILE *fd, int *pixtype, int *xdim, int *ydim);
void JPEG_read_data(FILE *fd, char *data);
void JPEG_write_data(FILE *fd, int pixtype, int xdim, int ydim, char *data);
