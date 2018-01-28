/*---------------------------------------------------------------------------*/
/* Program:  jpeg.c                                                          */
/* Purpose:  This program reads and writes jpg data files.                   */
/*           Uses code borrowed from djpeg.c and cjpeg.c                     */
/* Author:   John Gauch                                                      */
/* Date:     November 30, 1995                                               */
/*---------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include "jpeg.h"

/*---------------------------------------------------------------------------*/
/* Purpose:  This routine opens a JPEG format image.                         */
/*---------------------------------------------------------------------------*/
FILE *JPEG_open(char *filename)
{
   unsigned char c1, c2;
   FILE *fd = fopen(filename, "rb");
   if (fd != NULL)
   {
      c1 = fgetc(fd);
      c2 = fgetc(fd);
      if (c1 == 0xff && c2 == 0xd8)
	 rewind(fd);
      else
      {
	 fclose(fd);
	 fd = NULL;
      }
   }
   return fd;
}

/*---------------------------------------------------------------------------*/
/* Purpose:  This reads in JPEG header.                                      */
/*---------------------------------------------------------------------------*/
void JPEG_read_header(FILE *fd, int *pixtype, int *xdim, int *ydim)
{
   // JPEG declarations
   struct jpeg_decompress_struct dinfo;
   struct jpeg_error_mgr jerr;

   // Initialize the JPEG decompression object with default error handling
   dinfo.err = jpeg_std_error(&jerr);
   jpeg_create_decompress(&dinfo);
   jpeg_stdio_src(&dinfo, fd);

   // Read file header, set default decompression parameters
   jpeg_read_header(&dinfo, TRUE);
   jpeg_calc_output_dimensions(&dinfo);
   *xdim = dinfo.output_width;
   *ydim = dinfo.output_height;

   // Determine pixel type
   if (dinfo.out_color_space == JCS_GRAYSCALE)
      *pixtype = JPEG_GRAY;
   else
      *pixtype = JPEG_RGB;

   // Close JPEG decompressor and input file
   jpeg_destroy_decompress(&dinfo);
   rewind(fd);
}

/*---------------------------------------------------------------------------*/
/* Purpose:  This reads JPEG data.                                           */
/*---------------------------------------------------------------------------*/
void JPEG_read_data(FILE *fd, char *data)
{
   // JPEG declarations 
   struct jpeg_decompress_struct dinfo;
   struct jpeg_error_mgr jerr;
   JSAMPARRAY buffer;
   JSAMPROW ptr;
   int stride, row, value, index = 0;

   // Initialize the JPEG decompression object with default error handling
   dinfo.err = jpeg_std_error(&jerr);
   jpeg_create_decompress(&dinfo);
   jpeg_stdio_src(&dinfo, fd);

   // Read file header, set default decompression parameters 
   jpeg_read_header(&dinfo, TRUE);
   jpeg_calc_output_dimensions(&dinfo);
   jpeg_start_decompress(&dinfo);

   // Calculate number of samples per row in output buffer
   stride = dinfo.output_width * dinfo.output_components;
   buffer = (*dinfo.mem->alloc_sarray) ((j_common_ptr) & dinfo, JPOOL_IMAGE,
					(JDIMENSION) stride, (JDIMENSION) 1);

   // Process JPEG scanlines 
   while (dinfo.output_scanline < dinfo.output_height)
   {
      jpeg_read_scanlines(&dinfo, buffer, 1);
      ptr = buffer[0];
      for (row = 0; row < stride; row++)
      {
	 value = GETJSAMPLE(*ptr++);
	 data[index++] = (unsigned char) value;
      }
   }

   // Finish decompression and release memory
   jpeg_finish_decompress(&dinfo);
   jpeg_destroy_decompress(&dinfo);
}

/*---------------------------------------------------------------------------*/
/* Purpose:  This writes JPEG data.                                          */
/*---------------------------------------------------------------------------*/
void JPEG_write_data(FILE *fd, int pixtype, int xdim, int ydim, char *data)
{
   struct jpeg_compress_struct cinfo;
   struct jpeg_error_mgr jerr;
   int i, quality = 95, smoothness = 0, index = 0;
   // JSAMPARRAY colormap;
   JSAMPARRAY buffer;
   JSAMPROW ptr;

   /* Initialize the JPEG compression object with default error handling. */
   cinfo.err = jpeg_std_error(&jerr);
   jpeg_create_compress(&cinfo);

   /* Initialize JPEG parameters which may be overridden later */
   cinfo.in_color_space = JCS_RGB;
   jpeg_set_defaults(&cinfo);

   /* Set up color map */
   // colormap = (*cinfo.mem->alloc_sarray) ((j_common_ptr) & cinfo, JPOOL_IMAGE, 256, 3);

   /* Obtain file size and colorspace */
   if (pixtype == JPEG_RGB)
   {
      cinfo.input_components = 3;
      cinfo.in_color_space = JCS_RGB;
   }
   else
   {
      cinfo.input_components = 1;
      cinfo.in_color_space = JCS_GRAYSCALE;
   }
   cinfo.image_width = xdim;
   cinfo.image_height = ydim;
   cinfo.data_precision = BITS_IN_JSAMPLE;
   buffer = (*cinfo.mem->alloc_sarray) ((j_common_ptr) & cinfo, JPOOL_IMAGE,
      (JDIMENSION) (cinfo.image_width * cinfo.input_components), (JDIMENSION) 1);

   /* Fix colorspace-dependent defaults */
   jpeg_default_colorspace(&cinfo);

   /* Customize parameters */
   cinfo.smoothing_factor = smoothness;
   jpeg_set_quality(&cinfo, quality, TRUE);

   /* Specify data destination for compression */
   jpeg_stdio_dest(&cinfo, fd);

   /* Start compressor */
   jpeg_start_compress(&cinfo, TRUE);

   /* Process JPEG scanlines */
   while (cinfo.next_scanline < cinfo.image_height)
   {
      ptr = buffer[0];
      for (i = 0; i < (int) cinfo.image_width; i++)
      {
	 if (pixtype == JPEG_RGB)
	 {
	    *ptr++ = (unsigned char) data[index++];
	    *ptr++ = (unsigned char) data[index++];
	    *ptr++ = (unsigned char) data[index++];
	 }
	 else
	    *ptr++ = (unsigned char) data[index++];
      }
      (void) jpeg_write_scanlines(&cinfo, buffer, 1);
   }

   /* Finish compression and release memory */
   jpeg_finish_compress(&cinfo);
   jpeg_destroy_compress(&cinfo);
}
