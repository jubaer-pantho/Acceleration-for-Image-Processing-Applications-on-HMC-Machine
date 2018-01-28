//============================================================
//  File:       im_pixel.cpp
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#include "im_complex.h"

//============================================================
PIXEL IM_TYPE::Sample(int x, int y, char bound)
{
   // Wrap around pixel coordinates
   if (bound == 'w')
   {
      if (y < 0)     y = y % Ydim + Ydim;
      if (y >= Ydim) y = y % Ydim;
      if (x < 0)     x = x % Xdim + Xdim;
      if (x >= Xdim) x = x % Xdim;
   }

   // Clamp pixel coordinates
   else if (bound == 'c')
   {
      if (y < 0)     y = 0;
      if (y >= Ydim) y = Ydim-1;
      if (x < 0)     x = 0;
      if (x >= Xdim) x = Xdim-1;
   }

   // Zero pad pixel coordinates
   else if (bound == 'z')
   {
      if (y < 0)     return 0;
      if (y >= Ydim) return 0;
      if (x < 0)     return 0;
      if (x >= Xdim) return 0;
   }

   // Return pixel sample
   return Data2D[y][x];
}

//============================================================
PIXEL IM_TYPE::Sample(float x, float y, char bound)
{
   // Calculate interpolation weights
   float xdelta = x - (int)x;
   float ydelta = y - (int)y;

   // Get four adjacent pixel values
   PIXEL Value00 = Sample((int)x+0, (int)y+0, bound);
   PIXEL Value01 = Sample((int)x+0, (int)y+1, bound);
   PIXEL Value10 = Sample((int)x+1, (int)y+0, bound);
   PIXEL Value11 = Sample((int)x+1, (int)y+1, bound);

   // Perform bilinear interpolation
   return (PIXEL) (Value00 * (1 - xdelta) * (1 - ydelta) +
		   Value01 * (1 - xdelta) * (ydelta) +
		   Value10 * (xdelta) * (1 - ydelta) +
		   Value11 * (xdelta) * (ydelta));
}

//============================================================
IM_TYPE::IM_TYPE()
{
   // Allocate image
   Clear();
}

//============================================================
IM_TYPE::IM_TYPE(int xdim)
{
   // Allocate image
   Clear();
   Alloc(xdim, 1);
}

//============================================================
IM_TYPE::IM_TYPE(int xdim, int ydim)
{
   // Allocate image
   Clear();
   Alloc(xdim, ydim);
}

//============================================================
IM_TYPE::IM_TYPE(const im_short & copy)
{
   // Allocate image
   Clear();
   Copy(copy);
}

//============================================================
IM_TYPE::IM_TYPE(const im_float & copy)
{
   // Allocate image
   Clear();
   Copy(copy);
}

//============================================================
IM_TYPE::~IM_TYPE()
{
   // Free image
   Free();
}

//============================================================
void IM_TYPE::Clear()
{
   // Clear image
   Xdim = 0;
   Ydim = 0;
   NumPixels = 0;
   Data1D = NULL;
   Data2D = NULL;
}

//============================================================
void IM_TYPE::Free()
{
   // Free memory
   if (Data1D != NULL)
      free((void *) Data1D);
   if (Data2D != NULL)
      free((void *) Data2D);
   Data1D = NULL;
   Data2D = NULL;
   Clear();
}

//============================================================
void IM_TYPE::Alloc(int xdim, int ydim)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;

   // Save image size
   Free();
   Xdim = xdim;
   Ydim = ydim;
   NumPixels = Xdim * Ydim;

   // Allocate memory
   Data1D = (PIXEL *) calloc(NumPixels, sizeof(PIXEL));
   Data2D = (PIXEL **) calloc(Ydim, sizeof(PIXEL *));

   // Initialize pointers
   for (int y = 0; y < Ydim; y++)
      Data2D[y] = &(Data1D[y * Xdim]);
}

//============================================================
void IM_TYPE::Swap(IM_TYPE & copy)
{
   // Swap header data
   int temp = copy.Xdim;
   copy.Xdim = Xdim;
   Xdim = temp;

   temp = copy.Ydim;
   copy.Ydim = Ydim;
   Ydim = temp;

   temp = copy.NumPixels;
   copy.NumPixels = NumPixels;
   NumPixels = temp;

   // Swap image data
   PIXEL *ptr1 = copy.Data1D;
   copy.Data1D = Data1D;
   Data1D = ptr1;

   PIXEL **ptr2 = copy.Data2D;
   copy.Data2D = Data2D;
   Data2D = ptr2;
}

//============================================================
void IM_TYPE::Copy(const im_short & copy)
{
   // Copy image data
   Alloc(copy.Xdim, copy.Ydim);
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = (PIXEL)copy.Data1D[index];
}

//============================================================
void IM_TYPE::Copy(const im_float & copy)
{
   // Copy image data
   Alloc(copy.Xdim, copy.Ydim);
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = (PIXEL)copy.Data1D[index];
}

//============================================================
bool IM_TYPE::ReadHeader(FILE *fd, char* pix_type, int &xdim, int &ydim, int &max)
{
   int ch;
   char line[STRLEN];

   // Read pixel type
   if (fscanf(fd, "%s", pix_type) != 1)
      { printf("Error: Could not read pix_type\n"); return false; }

   // Read xdim value
   while ((ch = fgetc(fd)) != EOF && isspace(ch));
   while (ch == '#') 
   {
      if (fgets(line, sizeof(line), fd) == NULL)
         { printf("Error: Could not read comment\n"); return false; }
      while ((ch = fgetc(fd)) != EOF && isspace(ch));
   } 
   fseek(fd, -1, SEEK_CUR);
   if (fscanf(fd, "%d", &xdim) != 1)
      { printf("Error: Could not read xdim\n"); return false; }

   // Read ydim value
   while ((ch = fgetc(fd)) != EOF && isspace(ch));
   while (ch == '#') 
   {
      if (fgets(line, sizeof(line), fd) == NULL)
         { printf("Error: Could not read comment\n"); return false; }
      while ((ch = fgetc(fd)) != EOF && isspace(ch));
   } 
   fseek(fd, -1, SEEK_CUR);
   if (fscanf(fd, "%d", &ydim) != 1)
      { printf("Error: Could not read ydim\n"); return false; }
   
   // Read max value
   while ((ch = fgetc(fd)) != EOF && isspace(ch));
   while (ch == '#') 
   {
      if (fgets(line, sizeof(line), fd) == NULL)
         { printf("Error: Could not read comment\n"); return false; }
      while ((ch = fgetc(fd)) != EOF && isspace(ch));
   } 
   fseek(fd, -1, SEEK_CUR);
   if (fscanf(fd, "%d", &max) != 1)
      { printf("Error: Could not read max\n"); return false; }
   fgetc(fd);
   return true;
}

//============================================================
bool IM_TYPE::WriteAscii(char *filename)
{
   // Window values to 0..255 range
   Window(0, 255);

   // Open output file
   FILE *fd = fopen(filename, "w");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Write header in portable greymap file format (PGM)
   if (fprintf(fd, "P2\n%d %d\n%d\n", Xdim, Ydim, 255) <= 0)
   { printf("Error: Could not write header\n"); return false; }

   // Write pixels
   for (int index = 0; index < NumPixels; index++)
      if (fprintf(fd, "%d ", (int) Data1D[index]) <= 0)
      { printf("Error: Could not write pixel\n"); return false; }
   fprintf(fd, "\n");

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool IM_TYPE::ReadAscii(char *filename)
{
   // Open input file
   FILE *fd = fopen(filename, "r");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read header in portable greymap file format (PGM)
   char pix_type[STRLEN];
   int xdim, ydim, max;
   ReadHeader(fd, pix_type, xdim, ydim, max);

   // Check pix_type
   if (strcmp(pix_type, "P2") != 0)
   { printf("Error: Expecting PGM P2 format file\n"); return false; }

   // Allocate image
   Alloc(xdim, ydim);

   // Read pixels
   for (int index = 0; index < NumPixels; index++)
   {
      int temp;
      if (fscanf(fd, "%d", &temp) != 1)
      { printf("Error: Could not read pixel\n"); return false; }
      Data1D[index] = (PIXEL) temp;
   }

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool IM_TYPE::WriteBinary(char *filename)
{
   // Map values to 0..255 range
   Greymap(0, 255);

   // Open output file
   FILE *fd = fopen(filename, "wb");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Write header in portable greymap file format (PGM)
   if (fprintf(fd, "P5\n%d %d\n%d\n", Xdim, Ydim, 255) <= 0)
   { printf("Error: Could not write header\n"); return false; }

   // Copy pixels
   unsigned char *data = (unsigned char *) calloc(NumPixels,1);
   for (int index = 0; index < NumPixels; index++)
      data[index] = (unsigned char) Data1D[index];
   
   // Write pixels 
   if (NumPixels != (int) fwrite((void *) data, 
      sizeof(unsigned char), NumPixels, fd))
   { printf("Error: Could not write data\n"); return false; }
   free(data);
   data = NULL;

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool IM_TYPE::ReadBinary(char *filename)
{
   // Open file
   FILE *fd = fopen(filename, "rb");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read header in portable greymap file format (PGM)
   char pix_type[STRLEN];
   int xdim, ydim, max;
   ReadHeader(fd, pix_type, xdim, ydim, max);

   // Check pix_type
   if (strcmp(pix_type, "P5") != 0)
   { printf("Error: Expecting PGM P5 format file\n"); return false; }

   // Allocate image
   Alloc(xdim, ydim);

   // Read pixels 
   unsigned char *data = (unsigned char *) calloc(NumPixels,1);
   if (NumPixels != (int) fread((void *) data, 
      sizeof(unsigned char), NumPixels, fd))
   { printf("Error: Could not read data\n"); return false; }

   // Copy pixels
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = (PIXEL) data[index];
   free(data);
   data = NULL;

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool IM_TYPE::WriteJpg(char *filename)
{
   // Map values to 0..255 range
   Greymap(0, 255);

   // Open JPEG image
   FILE *fd = fopen(filename, "wb");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Copy data to buffer
   unsigned char *buffer = new unsigned char[NumPixels];
   for (int i = 0; i < NumPixels; i++)
      buffer[i] = (unsigned char) Data1D[i];

   // Write JPEG image
   JPEG_write_data(fd, JPEG_GRAY, Xdim, Ydim, (char *) buffer);
   fclose(fd);

   // Release memory
   delete[]buffer;
   return true;
}

//============================================================
bool IM_TYPE::ReadJpg(char *filename)
{
   // Open JPEG image
   FILE *fd = JPEG_open(filename);
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read JPEG image header
   int pixtype, xdim, ydim;
   JPEG_read_header(fd, &pixtype, &xdim, &ydim);

   // Read GREY image
   if (pixtype == JPEG_GRAY)
   {
      // Allocate image
      Alloc(xdim, ydim);

      // Read JPEG image
      unsigned char *buffer = new unsigned char[NumPixels];
      JPEG_read_data(fd, (char *) buffer);
      fclose(fd);

      // Copy data from buffer
      for (int i = 0; i < NumPixels; i++)
	 Data1D[i] = (PIXEL) buffer[i];

      // Release memory
      delete[]buffer;
   }

   // Read RGB image
   else if (pixtype == JPEG_RGB)
   {
      // Allocate image
      Alloc(xdim, ydim);

      // Read JPEG image
      unsigned char *buffer = new unsigned char[NumPixels * 3];
      JPEG_read_data(fd, (char *) buffer);
      fclose(fd);

      // Copy data from buffer
      for (int i = 0; i < NumPixels * 3; i++)
	 Data1D[i / 3] += (PIXEL) (buffer[i] / 3.0);

      // Release memory
      delete[]buffer;
   }

   // Not JPEG format
   else
   { printf("Error: Invalid JPEG image format\n"); return false; }
   return true;
}

//============================================================
void IM_TYPE::Add(IM_TYPE & in2)
{
   // Check input image sizes
   if ((Xdim != in2.Xdim) || (Ydim != in2.Ydim))
      return;

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      float result = (float)(Data1D[index] + in2.Data1D[index]);
      Data1D[index] = (PIXEL)result;
   }
}

//============================================================
void IM_TYPE::Subtract(IM_TYPE & in2)
{
   // Check input image sizes
   if ((Xdim != in2.Xdim) || (Ydim != in2.Ydim))
      return;

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      float result = (float)(Data1D[index] - in2.Data1D[index]);
      Data1D[index] = (PIXEL)result;
   }
}

//============================================================
void IM_TYPE::Multiply(IM_TYPE & in2)
{
   // Check input image sizes
   if ((Xdim != in2.Xdim) || (Ydim != in2.Ydim))
      return;

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      float result = (float)(Data1D[index] * in2.Data1D[index]);
      Data1D[index] = (PIXEL)result;
   }
}

//============================================================
void IM_TYPE::Divide(IM_TYPE & in2)
{
   // Check input image sizes
   if ((Xdim != in2.Xdim) || (Ydim != in2.Ydim))
      return;

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      float result = 0;
      if (in2.Data1D[index] != 0)
         result = (float)(Data1D[index] / in2.Data1D[index]);
      Data1D[index] = (PIXEL)result;
   }
}

//============================================================
void IM_TYPE::Threshold(float value, bool invert)
{
   // Process all pixels
   int BLACK = invert ? 1 : 0;
   int WHITE = invert ? 0 : 1;
   for (int index = 0; index < NumPixels; index++)
   {
      // Threshold image
      if (Data1D[index] < value)
	 Data1D[index] = BLACK;
      else
	 Data1D[index] = WHITE;
   }
}

//============================================================
void IM_TYPE::ThresholdAutomatic(bool invert)
{
   // Calculate pixel range and histogram
   PIXEL Min, Max;
   MinMax(Min, Max);
   int Range = (int) (Max - Min + 1);
   int *histo = new int[Range];
   int *Histo = new int[Range];
   Histogram(histo, Histo, (int) Min, (int) Max);

   // Calculate total intensity
   float *Total = new float[Range];
   Total[0] = histo[0] * Min;
   for (int i = 1; i < Range; i++)
      Total[i] = Total[i - 1] + histo[i] * (Min + i);

   // Calculate automatic threshold
   float threshold = 0;
   for (int i = 1; i < Range - 1; i++)
   {
      float mean1 = Total[i] / Histo[i];
      float mean2 = (Total[Range - 1] - Total[i]) 
                  / (Histo[Range - 1] - Histo[i]);
      threshold = (mean1 + mean2) / 2;
      if (Min + i >= threshold)
	 break;
   }

   // Perform threshold
   Threshold(threshold, invert);

   // Release memory
   delete[]histo;
   delete[]Histo;
   delete[]Total;
}

//============================================================
void IM_TYPE::Window(PIXEL low, PIXEL high)
{
   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      // Window image
      if (Data1D[index] < low)
	 Data1D[index] = low;
      if (Data1D[index] > high)
	 Data1D[index] = high;
   }
}

//============================================================
void IM_TYPE::Trim(float fraction)
{
   // Parameter checking
   if (fraction <= 0) return;
   if (fraction >= 1) return;

   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);
   int Range = (int)Max - (int)Min + 1;

   // Calculate intensity histogram
   int *histo = new int[Range];
   int *Histo = new int[Range];
   Histogram(histo, Histo, (int) Min, (int) Max);

   // Find trim window
   int low_index = 0;
   while ((low_index < Range) && (Histo[low_index] < fraction*NumPixels))
      low_index++;
   int high_index = Range-1;
   while ((high_index >= 0) && (Histo[high_index] > (1-fraction)*NumPixels))
      high_index--;

   // Window image
   PIXEL low = (PIXEL) (Min + low_index);
   PIXEL high = (PIXEL) (Min + high_index);
   Window(low, high);

   // Release memory
   delete[]histo;
   delete[]Histo;
}

//============================================================
void IM_TYPE::Greymap(int low, int high)
{
   // Calculate scale factor
   PIXEL min, max;
   MinMax(min, max);
   float scale = 1.0;
   if (max > min)
      scale = (float) (high - low) / (float) (max - min);

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = (PIXEL) (low + scale * (Data1D[index] - min));
}

//============================================================
void IM_TYPE::Quantize(int levels, int iterations)
{
   // Parameter checking 
   if (levels < 2)
      levels = 2;
   if (iterations < 1)
      iterations = 1;

   // Calculate current pixel range
   PIXEL min, max;
   MinMax(min, max);

   // Calculate intensity histogram
   int range = (int) (max - min + 1);
   int *histo = new int[range];
   int *quant = new int[levels + 1];
   int *thresh = new int[levels + 1];
   int *map = new int[range];
   Histogram(histo, (int) min, (int) max);

   // Initialize thresholds
   for (int n = 0; n < levels; n++)
      thresh[n] = (n * range) / levels;
   thresh[levels] = range;

   // Perform iterative optimization
   float prev_error = range;
   for (int iteration = 0; iteration < iterations; iteration++)
   {
      // Loop over all quantization levels
      int total_count = 0;
      float total_error = 0;
      for (int n = 0; n < levels; n++)
      {
	 // Calculate quantization level
	 int count = 0;
	 float total = 0;
	 for (int i = thresh[n]; i < thresh[n + 1]; i++)
	 {
	    count += histo[i];
	    total += histo[i] * i;
	 }
	 if (count > 0)
	    quant[n] = (int) (total / count);
	 else
	    quant[n] = (thresh[n] + thresh[n + 1] + 1) / 2;

	 // Calculate quantization error
	 count = 0;
	 float error = 0;
	 for (int i = thresh[n]; i < thresh[n + 1]; i++)
	 {
	    float diff = i - quant[n];
	    error += histo[i] * diff * diff;
	    count += histo[i];
	 }
	 total_error += error;
	 total_count += count;
      }

      // Update thresholds
      for (int n = 1; n < levels; n++)
	 thresh[n] = (quant[n - 1] + quant[n] + 1) / 2;

      // Check for convergence
      total_error = sqrt(total_error / total_count);
      if (total_error >= prev_error)
	 iteration = iterations;
      else
	 prev_error = total_error;
   }

   // Create quantization map
   for (int n = 0; n < levels; n++)
      for (int i = thresh[n]; i < thresh[n + 1]; i++)
	 map[i] = quant[n] + (int) min;

   // Quantize the input image
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = map[(int) (Data1D[index] - min)];

   // Release memory
   delete[]histo;
   delete[]quant;
   delete[]thresh;
   delete[]map;
}

//============================================================
void IM_TYPE::Invert()
{
   // Invert pixel values 
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = 255 - Data1D[index];
}

//============================================================
void IM_TYPE::Equalize()
{
   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);
   int Range = (int) (Max - Min + 1);

   // Calculate intensity histogram
   int *histo = new int[Range];
   int *Histo = new int[Range];
   Histogram(histo, Histo, (int) Min, (int) Max);

   // Perform histogram equalization
   for (int index = 0; index < Range; index++)
      Histo[index] = (int) (Min + (Max - Min) * Histo[index] / NumPixels);
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = Histo[(int) (Data1D[index] - Min)];

   // Release memory
   delete[]histo;
   delete[]Histo;
}

//============================================================
void IM_TYPE::Equalize(int regions)
{
   // Parameter checking
   if (regions < 1)
      regions = 1;

   // Create subimage
   IM_TYPE subimage(Xdim / regions, Ydim / regions);

   // Equalize each subimage
   for (int ry = 0; ry < regions; ry++)
      for (int rx = 0; rx < regions; rx++)
      {
	 // Define subimage
	 int sy = ry * subimage.Ydim;
	 int sx = rx * subimage.Xdim;

	 // Copy pixels 
	 for (int y = 0; y < subimage.Ydim; y++)
	    for (int x = 0; x < subimage.Xdim; x++)
	       subimage.Data2D[y][x] = Data2D[y + sy][x + sx];

	 // Perform histogram equalization
	 subimage.Equalize();

	 // Copy pixels 
	 for (int y = 0; y < subimage.Ydim; y++)
	    for (int x = 0; x < subimage.Xdim; x++)
	       Data2D[y + sy][x + sx] = subimage.Data2D[y][x];
      }
}

//============================================================
void IM_TYPE::UnsharpMasking(float sigma, float weight)
{
   // Parameter checking 
   if (sigma < 1)
      sigma = 1;
   if (weight < 0)
      weight = 0;

   // Perform smoothing
   IM_TYPE blur(*this);
   blur.Gaussian(sigma);

   // Process all pixels
   PIXEL Min, Max;
   MinMax(Min, Max);
   for (int index = 0; index < NumPixels; index++)
   {
      PIXEL Mask = Data1D[index] - blur.Data1D[index];
      Data1D[index] += weight * Mask;
      if (Data1D[index] > Max) Data1D[index] = Max;
      if (Data1D[index] < Min) Data1D[index] = Min;
   }
}

//============================================================
void IM_TYPE::UnsharpMasking(int iterations, float weight, char bound)
{
   // Parameter checking 
   if (iterations < 1)
      iterations = 1;
   if (weight < 0)
      weight = 0;
   if (weight > 1)
      weight = 1;

   // Perform Binomial smoothing
   IM_TYPE blur(*this);
   blur.Binomial(iterations, bound);

   // Process all pixels
   PIXEL Min, Max;
   MinMax(Min, Max);
   for (int index = 0; index < NumPixels; index++)
   {
      PIXEL Mask = Data1D[index] - blur.Data1D[index];
      Data1D[index] += weight * Mask;
      if (Data1D[index] > Max) Data1D[index] = Max;
      if (Data1D[index] < Min) Data1D[index] = Min;
   }
}

//============================================================
void IM_TYPE::Power(float gamma)
{
   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);
   int Range = (int) (Max - Min + 1);

   // Initialize the mapping function
   float *Map = new float[Range];
   float Scale = Range / pow(Range, gamma);
   for (int i = 0; i < Range; i++)
      Map[i] = Scale * pow(i, gamma) + Min;

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
      Data1D[index] = (PIXEL) Map[(int) (Data1D[index] - Min)];

   // Release memory
   delete[]Map;
}

//============================================================
void IM_TYPE::Cubic(float param)
{
   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);
   int Range = (int) (Max - Min);

   // Initialize the mapping function
   float *Map = new float[Range+1];
   for (int i = 0; i <= Range; i++)
      Map[i] = i + Min;

   // Check parameters
   if (param < -1) param = -1;
   if (param > 1) param = 1;

   // Define initial points
   float p0x = 0;
   float p0y = 0;
   float p1x = (param > 0) ? 0 : -param;
   float p1y = (param > 0) ? param : 0;
   float p2x = (param > 0) ? 1-param : 1;
   float p2y = (param > 0) ? 1 : 1+param;
   float p3x = 1;
   float p3y = 1;

   // Calculate intermediate points
   float step = 0.1 / Range;
   for (float t = 0; t <= 1; t += step)
   {
      float q0x = p0x + t * (p1x - p0x);
      float q0y = p0y + t * (p1y - p0y);
      float q1x = p1x + t * (p2x - p1x);
      float q1y = p1y + t * (p2y - p1y);
      float q2x = p2x + t * (p3x - p2x);
      float q2y = p2y + t * (p3y - p2y);

      float r0x = q0x + t * (q1x - q0x);
      float r0y = q0y + t * (q1y - q0y);
      float r1x = q1x + t * (q2x - q1x);
      float r1y = q1y + t * (q2y - q1y);

      float x = r0x + t * (r1x - r0x);
      float y = r0y + t * (r1y - r0y);
      Map[(int)(Range*x)] = Range*y + Min;
   }

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      int pixel = (int)(Data1D[index] - Min);
      Data1D[index] = (PIXEL) Map[pixel];
   }

   // Release memory
   delete[]Map;
}

//============================================================
void IM_TYPE::Stretch(int r1, int s1, int r2, int s2)
{
   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);

   // Calculate slope of line segments
   float Slope1 = 0, Slope2 = 0, Slope3 = 0;
   if (r1 > Min)
      Slope1 = (float) (s1 - Min) / (float) (r1 - Min);
   if (r2 > r1)
      Slope2 = (float) (s2 - s1) / (float) (r2 - r1);
   if (Max > r2)
      Slope3 = (float) (Max - s2) / (float) (Max - r2);

   // Process all pixels
   for (int index = 0; index < NumPixels; index++)
   {
      if (Data1D[index] < r1)
	 Data1D[index] = (PIXEL) (Slope1 * (Data1D[index] - Min) + Min);
      else if (Data1D[index] < r2)
	 Data1D[index] = (PIXEL) (Slope2 * (Data1D[index] - r1) + s1);
      else
	 Data1D[index] = (PIXEL) (Slope3 * (Data1D[index] - r2) + s2);
   }
}

//============================================================
void IM_TYPE::Wallis(int radius, float A, float B)
{
   // Parameter checking
   if (radius < 1)
      radius = 1;
   if (A < 0) A = 0;
   if (B < 0) B = 0;
   if (B > 1) B = 1;

   // Copy input image
   IM_TYPE in(*this);

   // Calculate global statistics
   PIXEL Min, Max;
   MinMax(Min, Max);
   double Mean = 0.0;
   double Stddev = 0.0;
   Statistics(Mean, Stddev);

   // Process all pixels
   int area = (2 * radius + 1) * (2 * radius + 1);
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Calculate local mean 
	 float mean = 0;
	 for (int dy = y - radius; dy <= y + radius; dy++)
	    for (int dx = x - radius; dx <= x + radius; dx++)
	       mean += in.Sample(dx, dy);
	 mean = mean / area;

	 // Calculate local standard deviation
	 float stddev = 1;
	 for (int dy = y - radius; dy <= y + radius; dy++)
	    for (int dx = x - radius; dx <= x + radius; dx++)
	    {
	       float diff = mean - in.Sample(dx, dy);
	       stddev += diff * diff;
	    }
	 stddev = sqrt(stddev / area);

	 // Perform enhancement
	 Data2D[y][x] = Stddev * (Data2D[y][x] - mean) / (stddev + A) 
                      + Mean * B + mean * (1 - B);
         if (Data2D[y][x] < Min) Data2D[y][x] = Min;
         if (Data2D[y][x] > Max) Data2D[y][x] = Max;
      }
}

//============================================================
void IM_TYPE::Average(int xdim, int ydim)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;

   // Copy input image
   IM_TYPE in(*this);

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;
   int area = xdim * ydim;

   // Calculate local average
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float sum = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       sum += in.Sample(dx, dy);
	 Data2D[y][x] = (PIXEL) (sum / area);
      }
}

//============================================================
void IM_TYPE::Binomial(char bound)
{
   // Copy input image
   IM_TYPE in(*this);

   // Handle center pixels
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
	 Data2D[y][x] = (in.Data2D[y - 1][x - 1] +
			 in.Data2D[y - 1][x] * 2 +
			 in.Data2D[y - 1][x + 1] +

			 in.Data2D[y][x - 1] * 2 +
			 in.Data2D[y][x] * 4 +
			 in.Data2D[y][x + 1] * 2 +

			 in.Data2D[y + 1][x - 1] +
			 in.Data2D[y + 1][x] * 2 +
			 in.Data2D[y + 1][x + 1] + 8) / 16;
      }

   // Handle border pixels
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x += Xdim - 1)
      {
	 Data2D[y][x] = (in.Sample(x-1, y-1, bound) +
			 in.Sample(x,   y-1, bound) * 2 +
			 in.Sample(x+1, y-1, bound) +

			 in.Sample(x-1, y, bound) * 2 +
			 in.Sample(x,   y, bound) * 4 +
			 in.Sample(x+1, y, bound) * 2 +

			 in.Sample(x-1, y+1, bound) +
			 in.Sample(x,   y+1, bound) * 2 +
			 in.Sample(x+1, y+1, bound) + 8) / 16;
      }
   for (int y = 0; y < Ydim; y += Ydim - 1)
      for (int x = 0; x < Xdim; x++)
      {
	 Data2D[y][x] = (in.Sample(x-1, y-1, bound) +
			 in.Sample(x,   y-1, bound) * 2 +
			 in.Sample(x+1, y-1, bound) +

			 in.Sample(x-1, y, bound) * 2 +
			 in.Sample(x,   y, bound) * 4 +
			 in.Sample(x+1, y, bound) * 2 +

			 in.Sample(x-1, y+1, bound) +
			 in.Sample(x,   y+1, bound) * 2 +
			 in.Sample(x+1, y+1, bound) + 8) / 16;
      }
}

//============================================================
void IM_TYPE::Binomial(int iterations, char bound)
{
   // Perform Binomial smoothing
   for (int count = 0; count < iterations; count++)
      Binomial(bound);
}

//============================================================
void IM_TYPE::Convolve(int xdim, int ydim, float weight[])
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;

   // Copy input image
   IM_TYPE in(*this);

   // Calculate sum of weights
   float total = 0;
   for (int index = 0; index < xdim * ydim; index++)
      total += weight[index];
   if (total != 0)
      for (int index = 0; index < xdim * ydim; index++)
	 weight[index] /= total;

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;

   // Calculate weighted average
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float sum = 0;
	 int index = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       sum += in.Sample(dx, dy) * weight[index++];
	 Data2D[y][x] = (PIXEL) sum;
      }
}

//============================================================
void quicksort(PIXEL data[], int low, int high)
{
   int mid, left, right;
   PIXEL temp, pivot;

   // Check terminating condition
   if (low < high)
   {
      pivot = data[high];
      left = low - 1;
      right = high;

      // Partition array into two unsorted sections
      do
      {
	 // Scan left to right
	 while ((left < right) && (data[++left] < pivot));

	 // Scan right to left
	 while ((left < right) && (data[--right] > pivot));

	 // Swap data values
	 temp = data[left];
	 data[left] = data[right];
	 data[right] = temp;
      }
      while (left < right);

      // Correct for last swap
      data[right] = data[left];
      data[left] = data[high];
      data[high] = temp;
      mid = left;

      // Recursive calls to sort array
      quicksort(data, low, mid - 1);
      quicksort(data, mid + 1, high);
   }
}

//============================================================
void IM_TYPE::Median(int xdim, int ydim)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;

   // Copy input image
   IM_TYPE in(*this);

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;
   int area = xdim * ydim;
   PIXEL *Data = new PIXEL[area];

   // Perform median smoothing
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Copy pixels in window
	 int count = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       if ((dy >= 0) && (dy < Ydim) && (dx >= 0) && (dx < Xdim))
		  Data[count++] = in.Data2D[dy][dx];

	 // Perform sort and select median
	 quicksort(Data, 0, count - 1);
	 Data2D[y][x] = Data[count / 2];
      }

   // Release memory
   delete[]Data;
}

//============================================================
void IM_TYPE::Gaussian(float sigma)
{
   // Parameter checking
   if (sigma <= 0.01)
      sigma = 0.01;

   // Create weight array
   int radius = (int) (3 * sigma);
   if (radius < 1)
      radius = 1;
   int size = 2 * radius + 1;
   float *weight = new float[size];

   // Initialize weight array
   int index = 0;
   for (int x = -radius; x <= radius; x++)
      weight[index++] = exp(-(x * x) / (2 * sigma * sigma));

   // Perform convolution
   Convolve(size, 1, weight);
   Convolve(1, size, weight);

   // Release memory
   delete[]weight;
}

//============================================================
void IM_TYPE::AdaptiveGaussian(float min_sigma, float max_sigma)
{
   // Parameter checking
   if (min_sigma <= 0.01)
      min_sigma = 0.01;
   if (max_sigma <= min_sigma)
      max_sigma = min_sigma;

   // Copy input image
   IM_TYPE in(*this);

   // Calculate gradient
   Gradient();
   PIXEL min_grad, max_grad;
   MinMax(min_grad, max_grad);
   float slope = (max_sigma - min_sigma) / (max_grad - min_grad);

   // Process all pixels
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
         // Calculate adaptive sigma
         float sigma = max_sigma - slope * (Data2D[y][x] - min_grad);
         if (sigma <= min_sigma)
            sigma = min_sigma;
         int radius = (int) (3 * sigma);
         if (radius < 1)
            radius = 1;

         // Perform adaptive gaussian
         float sum = 0;
         float total = 0;
	 for (int dy = 0; dy <= radius; dy++)
	    for (int dx = 0; dx <= radius; dx++)
            {
	       float weight = exp(-(dx * dx + dy * dy) / (2 * sigma * sigma));
	       sum += in.Sample(x+dx, y+dy) * weight;
	       total += weight;
               if (dx > 0) 
               {
	          sum += in.Sample(x-dx, y+dy) * weight;
	          total += weight;
               }
               if (dy > 0) 
               {
	          sum += in.Sample(x+dx, y-dy) * weight;
	          total += weight;
               }
               if ((dx > 0) && (dy > 0)) 
               {
	          sum += in.Sample(x-dx, y-dy) * weight;
	          total += weight;
               }
            }
         Data2D[y][x] = (PIXEL)(sum / total);
      }

}

//============================================================
void IM_TYPE::OutlierRemoval(int xdim, int ydim, float threshold)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;
   if (threshold < 0)
      threshold = 0;

   // Copy input image
   IM_TYPE in(*this);

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;
   int area = xdim * ydim;

   // Process all pixels
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Calculate local mean 
	 float mean = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       mean += in.Sample(dx, dy);
	 mean = (mean - Data2D[y][x]) / (area - 1);

	 // Remove outliers
	 if (fabs(in.Data2D[y][x] - mean) > threshold)
	    Data2D[y][x] = (PIXEL) mean;
      }
}

//============================================================
void IM_TYPE::kNN(int xdim, int ydim, int K)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;
   if (K < 1)
      K = 1;

   // Copy input image
   IM_TYPE in(*this);

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;
   int area = xdim * ydim;
   PIXEL *Data = new PIXEL[area];

   // Perform smoothing
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Copy pixels in window
	 int count = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       if ((dy >= 0) && (dy < Ydim) && (dx >= 0) && (dx < Xdim))
		  Data[count++] = in.Data2D[dy][dx];

	 // Perform sort 
	 quicksort(Data, 0, count - 1);

	 // Select K nearest neighbors
	 int left = 0;
	 int right = count - 1;
	 PIXEL center = in.Data2D[y][x];
	 for (int i = 0; i < (count - K); i++)
	 {
	    if (fabs((float) (Data[left] - center)) >
		fabs((float) (Data[right] - center)))
	       left++;
	    else
	       right--;
	 }

	 // Calculate average of kNN
	 float total = 0;
	 for (int i = left; i <= right; i++)
	    total += Data[i];
	 Data2D[y][x] = (PIXEL) (total / (right - left + 1));
      }

   // Release memory
   delete[]Data;
}

//============================================================
void IM_TYPE::AlphaMean(int xdim, int ydim, int Alpha)
{
   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;
   if (Alpha < 0)
      Alpha = 0;

   // Copy input image
   IM_TYPE in(*this);

   // Define processing window
   int xlow = -xdim / 2;
   int xhigh = xlow + xdim;
   int ylow = -ydim / 2;
   int yhigh = ylow + ydim;
   int area = xdim * ydim;
   PIXEL *Data = new PIXEL[area];

   // Perform smoothing
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Copy pixels in window
	 int count = 0;
	 for (int dy = y + ylow; dy < y + yhigh; dy++)
	    for (int dx = x + xlow; dx < x + xhigh; dx++)
	       if ((dy >= 0) && (dy < Ydim) && (dx >= 0) && (dx < Xdim))
		  Data[count++] = in.Data2D[dy][dx];

	 // Perform sort 
	 quicksort(Data, 0, count - 1);

	 // Trim largest and smallest neighbors
	 int left = Alpha / 2;
	 int right = count - 1 - Alpha + Alpha / 2;
	 if (Alpha >= count)
	    left = right = count / 2;

	 // Calculate average of remaining values
	 float total = 0;
	 for (int i = left; i <= right; i++)
	    total += Data[i];
	 Data2D[y][x] = (PIXEL) (total / (right - left + 1));
      }

   // Release memory
   delete[]Data;
}

//============================================================
void IM_TYPE::Translate(float dx, float dy, char bound)
{
   // Copy input image
   IM_TYPE in(*this);

   // Perform translation
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float xpos = x - dx;
	 float ypos = y - dy;
	 Data2D[y][x] = in.Sample(xpos, ypos, bound);
      }
}

//============================================================
void IM_TYPE::Rotate(float angle, int cx, int cy, char bound)
{
   // Copy input image
   IM_TYPE in(*this);

   // Calculate rotation parameters
   angle = M_PI * angle / 180;
   float sin_angle = (float) sin(angle);
   float cos_angle = (float) cos(angle);

   // Perform rotate
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float xpos = (x - cx) * cos_angle + (y - cy) * sin_angle + cx;
	 float ypos = (y - cy) * cos_angle - (x - cx) * sin_angle + cy;
	 Data2D[y][x] = in.Sample(xpos, ypos, bound);
      }
}

//============================================================
void IM_TYPE::Scale(float sx, float sy, int cx, int cy, char bound)
{
   // Copy input image
   IM_TYPE in(*this);

   // Perform scale
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float xpos = (x - cx) / sx + cx;
	 float ypos = (y - cy) / sy + cy;
	 Data2D[y][x] = in.Sample(xpos, ypos, bound);
      }
}

//============================================================
void IM_TYPE::Shear(float sx, float sy, int cx, int cy, char bound)
{
   // Copy input image
   IM_TYPE in(*this);

   // Perform scale
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 float xpos = x + (y - cy) * sx;
	 float ypos = y + (x - cx) * sy;
	 Data2D[y][x] = in.Sample(xpos, ypos, bound);
      }
}

//============================================================
void IM_TYPE::Interpolate(int xdim, int ydim)
{
   // Parameter checking
   if (xdim < 2)
      xdim = 2;
   if (ydim < 2)
      ydim = 2;

   // Create output image
   IM_TYPE out(xdim, ydim);

   // Perform interpolate
   float xscale = (float) (Xdim - 1) / (float) (xdim - 1);
   float yscale = (float) (Ydim - 1) / (float) (ydim - 1);
   for (int y = 0; y < ydim; y++)
      for (int x = 0; x < xdim; x++)
      {
	 float xpos = x * xscale;
	 float ypos = y * yscale;
	 out.Data2D[y][x] = Sample(xpos, ypos);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::InterpolateNN(int xdim, int ydim)
{
   // Parameter checking
   if (xdim < 2)
      xdim = 2;
   if (ydim < 2)
      ydim = 2;

   // Create output image
   IM_TYPE out(xdim, ydim);

   // Perform interpolate
   float xscale = (float) (Xdim - 1) / (float) (xdim - 1);
   float yscale = (float) (Ydim - 1) / (float) (ydim - 1);
   for (int y = 0; y < ydim; y++)
      for (int x = 0; x < xdim; x++)
      {
	 int xpos = (int) (0.5 + x * xscale);
	 int ypos = (int) (0.5 + y * yscale);
	 out.Data2D[y][x] = Sample(xpos, ypos);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::MakeIcon(int size)
{
   // Calculate scale factor
   float xscale = (float) size / (float) Xdim;
   float yscale = (float) size / (float) Ydim;
   float scale = (xscale < yscale) ? xscale : yscale;

   // Perform interpolation
   if (scale < 1.0)
   {
      int xdim = (int) (Xdim * scale);
      int ydim = (int) (Ydim * scale);
      Interpolate(xdim, ydim);
   }
}

//============================================================
void IM_TYPE::Extract(int x1, int x2, int y1, int y2)
{
   // Parameter checking
   if (x2 < x1)
   {
      int temp = x1;
      x1 = x2;
      x2 = temp;
   }
   if (y2 < y1)
   {
      int temp = y1;
      y1 = y2;
      y2 = temp;
   }

   // Create output image
   int xdim = x2 - x1 + 1;
   int ydim = y2 - y1 + 1;
   IM_TYPE out(xdim, ydim);

   // Perform extract
   for (int y = 0; y < ydim; y++)
      for (int x = 0; x < xdim; x++)
      {
	 int ypos = y + y1;
	 int xpos = x + x1;
	 out.Data2D[y][x] = Sample(xpos, ypos);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::FitRectangle(int &x1, int &x2, int &y1, int &y2, int search, char method)
{
   // Parameter checking
   if (x2 < x1)
   {
      int temp = x1;
      x1 = x2;
      x2 = temp;
   }
   if (y2 < y1)
   {
      int temp = y1;
      y1 = y2;
      y2 = temp;
   }

   // Initialize x and y projections
   float *x_project = new float[Xdim];
   float *y_project = new float[Ydim];
   for (int x=x1; x<=x2; x++)
      x_project[x] = 0;
   for (int y=y1; y<=y2; y++)
      y_project[y] = 0;

   // Calculate x and y projections
   for (int y=y1; y<=y2; y++)
   for (int x=x1; x<=x2; x++)
   {
      // Fit to gradient magnitude
      if (method == 'g')
      {
         float dx = (Data2D[y][x+1] - Data2D[y][x]);
         float dy = (Data2D[y+1][x] - Data2D[y][x]);
         float grad = sqrt(dx*dx + dy*dy);
         x_project[x] -= grad; 
         y_project[y] -= grad; 
      }

      // Fit to intensity minima
      else if (method == '-')
      {
         x_project[x] -= Data2D[y][x]; 
         y_project[y] -= Data2D[y][x]; 
      }

      // Fit to intensity maxima
      else if (method == '+')
      {
         x_project[x] += Data2D[y][x]; 
         y_project[y] += Data2D[y][x]; 
      }
   }

   // Search for best x1
   int best = x1;
   for (int x = x1; (x <= x1 + search) && (x < x2); x++)
      if (x_project[x] > x_project[best])
         best = x;
   x1 = best;

   // Search for best x2
   best = x2;
   for (int x = x2; (x >= x2 - search) && (x > x1); x--)
      if (x_project[x] > x_project[best])
         best = x;
   x2 = best;

   // Search for best y1
   best = y1;
   for (int y = y1; (y <= y1 + search) && (y < y2); y++)
      if (y_project[y] > y_project[best])
         best = y;
   y1 = best;

   // Search for best y2
   best = y2;
   for (int y = y2; (y >= y2 - search) && (y > y1); y--)
      if (y_project[y] > y_project[best])
         best = y;
   y2 = best;

   // Free memory
   delete[]x_project;
   delete[]y_project;
}

//============================================================
void IM_TYPE::FitExtract(int x1, int x2, int y1, int y2, int search, char method)
{
   // Fit rectangle
   FitRectangle(x1, x2, y1, y2, search, method);

   // Perform extract
   Extract(x1, x2, y1, y2);
}

//============================================================
void IM_TYPE::PrintRange()
{
   PIXEL min, max;
   MinMax(min, max);
   if (sizeof(min) == 2)
      printf("[%d..%d]\n", (int)min, (int)max);
   else
      printf("[%f..%f]\n", (float)min, (float)max);
}

//============================================================
void IM_TYPE::MinMax(PIXEL & min, PIXEL & max)
{
   // Process all pixels
   min = Data1D[0];
   max = Data1D[0];
   for (int index = 0; index < NumPixels; index++)
   {
      // Find min and max values
      if (Data1D[index] < min)
	 min = Data1D[index];
      else if (Data1D[index] > max)
	 max = Data1D[index];
   }
}

//============================================================
void IM_TYPE::Statistics(double &mean, double &stddev)
{
   // Calculate mean intensity
   mean = 0;
   for (int index = 0; index < NumPixels; index++)
      mean += Data1D[index];
   mean /= NumPixels;

   // Calculate standard deviation
   stddev = 0;
   for (int index = 0; index < NumPixels; index++)
      stddev += (Data1D[index] - mean) * (Data1D[index] - mean);
   stddev = sqrt(stddev / NumPixels);
}

//============================================================
void IM_TYPE::Statistics(double &mean, double &stddev, double &skew)
{
   // Calculate mean intensity
   mean = 0;
   for (int index = 0; index < NumPixels; index++)
      mean += Data1D[index];
   mean /= NumPixels;

   // Calculate standard deviation and skew
   stddev = 0;
   skew = 0;
   for (int index = 0; index < NumPixels; index++)
   {
      double diff = Data1D[index] - mean;
      stddev += diff * diff;
      skew += diff * diff * diff;
   }
   stddev = sqrt(stddev / NumPixels);
   skew = cbrt(skew / NumPixels);
}

//============================================================
void IM_TYPE::Histogram(int histo[], int min, int max)
{
   // Initialize histogram array
   int range = max - min + 1;
   for (int index = 0; index < range; index++)
      histo[index] = 0;

   // Calculate intensity histogram
   for (int index = 0; index < NumPixels; index++)
      if ((Data1D[index] >= min) && (Data1D[index] <= max))
	 histo[(int) (Data1D[index] - min)]++;
}

//============================================================
void IM_TYPE::Histogram(int histo[], int Histo[], int min, int max)
{
   // Initialize histogram array
   int range = max - min + 1;
   for (int index = 0; index < range; index++)
      histo[index] = 0;

   // Calculate intensity histogram
   for (int index = 0; index < NumPixels; index++)
      if ((Data1D[index] >= min) && (Data1D[index] <= max))
	 histo[(int) (Data1D[index] - min)]++;

   // Calculate cumulative histogram
   Histo[0] = histo[0];
   for (int index = 1; index < range; index++)
      Histo[index] = histo[index] + Histo[index - 1];
}

//============================================================
float IM_TYPE::Contrast()
{
   // Calculate local contrast 
   float Sum = 0;
   for (int y = 1; y < Ydim; y++)
      for (int x = 1; x < Xdim; x++)
      {
	 // Calculate 1st derivatives
         float dX =(Data2D[y + 1][x + 1]
                  + Data2D[y][x + 1] * 2
                  + Data2D[y - 1][x + 1]
                  - Data2D[y + 1][x - 1]
                  - Data2D[y][x - 1] * 2 
                  - Data2D[y - 1][x - 1])/8.0;
	 float dY =(Data2D[y + 1][x + 1]
                  + Data2D[y + 1][x] * 2
                  + Data2D[y + 1][x - 1]
                  - Data2D[y - 1][x + 1]
                  - Data2D[y - 1][x] * 2 
                  - Data2D[y - 1][x - 1])/8.0;

	 // Calculate gradient magnitude
	 Sum += sqrt(dX * dX + dY * dY);
      }
   return (Sum / NumPixels);
}

//============================================================
void IM_TYPE::Gradient()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Process image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
	 // Calculate 1st derivatives
         float dX =(Data2D[y + 1][x + 1]
                  + Data2D[y][x + 1] * 2
                  + Data2D[y - 1][x + 1]
                  - Data2D[y + 1][x - 1]
                  - Data2D[y][x - 1] * 2 
                  - Data2D[y - 1][x - 1])/8.0;
	 float dY =(Data2D[y + 1][x + 1]
                  + Data2D[y + 1][x] * 2
                  + Data2D[y + 1][x - 1]
                  - Data2D[y - 1][x + 1]
                  - Data2D[y - 1][x] * 2 
                  - Data2D[y - 1][x - 1])/8.0;

	 // Calculate gradient magnitude
	 out.Data2D[y][x] = (PIXEL)sqrt(dX * dX + dY * dY);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::GradientEdges(float threshold)
{
   // Calculate gradient
   Gradient();

   // Apply threshold
   Threshold(threshold, false);
}

//============================================================
void IM_TYPE::Laplacian()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Process image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
	 // Calculate 2nd derivatives
	 float dXX = Data2D[y][x - 1] - 2 * Data2D[y][x] + Data2D[y][x + 1];
	 float dYY = Data2D[y - 1][x] - 2 * Data2D[y][x] + Data2D[y + 1][x];

	 // Calculate Laplacian
	 out.Data2D[y][x] = (PIXEL)(dXX + dYY);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::LaplacianEdges(float threshold)
{
   // Calculate gradient
   IM_TYPE gradient(*this);
   gradient.Gradient();

   // Calculate derivative
   IM_TYPE deriv(*this);
   deriv.Laplacian();

   // Find zero crossings
   deriv.ZeroCrossings(threshold, gradient);
   Swap(deriv);
}

//============================================================
void IM_TYPE::Canny()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Process image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
	 // Calculate 1st derivatives
         float dX =(Data2D[y + 1][x + 1]
                  + Data2D[y][x + 1] * 2
                  + Data2D[y - 1][x + 1]
                  - Data2D[y + 1][x - 1]
                  - Data2D[y][x - 1] * 2 
                  - Data2D[y - 1][x - 1])/8.0;
	 float dY =(Data2D[y + 1][x + 1]
                  + Data2D[y + 1][x] * 2
                  + Data2D[y + 1][x - 1]
                  - Data2D[y - 1][x + 1]
                  - Data2D[y - 1][x] * 2 
                  - Data2D[y - 1][x - 1])/8.0;

	 // Calculate 2nd derivatives
	 float dXX = Data2D[y][x - 1] - 2 * Data2D[y][x] + Data2D[y][x + 1];
	 float dYY = Data2D[y - 1][x] - 2 * Data2D[y][x] + Data2D[y + 1][x];
	 float dXY = (Data2D[y - 1][x - 1] - Data2D[y + 1][x - 1]
	           -  Data2D[y - 1][x + 1] + Data2D[y + 1][x + 1]) / 4.0;

	 // Calculate Canny derivative
	 float deriv = dX * dX * dXX + 2 * dX * dY * dXY + dY * dY * dYY;
         float grad = dX * dX + dY * dY;
         if (grad < 1) grad = 1.0;
         out.Data2D[y][x] = (PIXEL)(deriv/grad);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::CannyEdges(float threshold)
{
   // Calculate gradient
   IM_TYPE gradient(*this);
   gradient.Gradient();

   // Calculate derivative
   IM_TYPE deriv(*this);
   deriv.Canny();

   // Find zero crossings
   deriv.ZeroCrossings(threshold, gradient);
   Swap(deriv);
}

//============================================================
void IM_TYPE::ZeroCrossings()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Find zero crossings
   for (int y = 1; y < Ydim; y++)
      for (int x = 1; x < Xdim; x++)
	 {
	    PIXEL pixel = Data2D[y][x];
	    PIXEL xprev = Data2D[y][x - 1];
	    PIXEL yprev = Data2D[y - 1][x];

	    if ((pixel > 0) && (xprev <= 0))
	       out.Data2D[y][x] = 1;
	    if ((pixel > 0) && (yprev <= 0))
	       out.Data2D[y][x] = 1;
	    if ((xprev > 0) && (pixel <= 0))
	       out.Data2D[y][x - 1] = 1;
	    if ((yprev > 0) && (pixel <= 0))
	       out.Data2D[y - 1][x] = 1;
	 }
   Swap(out);
}

//============================================================
void IM_TYPE::ZeroCrossings(float threshold, IM_TYPE & gradient)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Find zero crossings
   for (int y = 1; y < Ydim; y++)
      for (int x = 1; x < Xdim; x++)
	 if (gradient.Data2D[y][x] > threshold)
	 {
	    PIXEL pixel = Data2D[y][x];
	    PIXEL xprev = Data2D[y][x - 1];
	    PIXEL yprev = Data2D[y - 1][x];

	    if ((pixel > 0) && (xprev <= 0))
	       out.Data2D[y][x] = 1;
	    if ((pixel > 0) && (yprev <= 0))
	       out.Data2D[y][x] = 1;
	    if ((xprev > 0) && (pixel <= 0))
	       out.Data2D[y][x - 1] = 1;
	    if ((yprev > 0) && (pixel <= 0))
	       out.Data2D[y - 1][x] = 1;
	 }
   Swap(out);
}

//============================================================
void IM_TYPE::Curvature()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Process image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
	 // Calculate 1st derivatives
         float dX =(Data2D[y + 1][x + 1]
                  + Data2D[y][x + 1] * 2
                  + Data2D[y - 1][x + 1]
                  - Data2D[y + 1][x - 1]
                  - Data2D[y][x - 1] * 2 
                  - Data2D[y - 1][x - 1])/8.0;
	 float dY =(Data2D[y + 1][x + 1]
                  + Data2D[y + 1][x] * 2
                  + Data2D[y + 1][x - 1]
                  - Data2D[y - 1][x + 1]
                  - Data2D[y - 1][x] * 2 
                  - Data2D[y - 1][x - 1])/8.0;

	 // Calculate 2nd derivatives
	 float dXX = Data2D[y][x - 1] - 2 * Data2D[y][x] + Data2D[y][x + 1];
	 float dYY = Data2D[y - 1][x] - 2 * Data2D[y][x] + Data2D[y + 1][x];
	 float dXY = (Data2D[y - 1][x - 1] - Data2D[y + 1][x - 1]
	           -  Data2D[y - 1][x + 1] + Data2D[y + 1][x + 1]) / 4.0;

	 // Calculate curvature
	 float deriv = dX * dX * dYY - 2 * dX * dY * dXY + dY * dY * dXX;
         float grad = dX * dX + dY * dY;
         if (grad > 1) out.Data2D[y][x] = (PIXEL)(deriv/grad);
      }
   Swap(out);
}

//============================================================
void IM_TYPE::Maxima(int radius)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Locate maxima 
   for (int y = radius; y < Ydim - radius; y++)
      for (int x = radius; x < Xdim - radius; x++)
      {
	 // Check for maximum
         bool maximum = true;
	 PIXEL center = Data2D[y][x];
         for (int dy = -radius; dy <= radius && maximum; dy++)
            for (int dx = -radius; dx <= radius && maximum; dx++)
               if (((dx != 0) || (dy != 0)) && 
                  (center < Data2D[y + dy][x + dx]))
                  maximum = false;
         if (maximum)
	    out.Data2D[y][x] = center;
         else
	    out.Data2D[y][x] = 0;
      }
   Swap(out);
}

//============================================================
void IM_TYPE::Minima(int radius)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Locate minima 
   for (int y = radius; y < Ydim - radius; y++)
      for (int x = radius; x < Xdim - radius; x++)
      {
	 // Check for minimum
         bool minimum = true;
	 PIXEL center = Data2D[y][x];
         for (int dy = -radius; dy <= radius && minimum; dy++)
            for (int dx = -radius; dx <= radius && minimum; dx++)
               if (((dx != 0) || (dy != 0)) && 
                  (center > Data2D[y + dy][x + dx]))
                  minimum = false;
         if (minimum)
	    out.Data2D[y][x] = center;
         else
	    out.Data2D[y][x] = 0;
      }
   Swap(out);
}

//============================================================
void IM_TYPE::Extrema(int radius)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Locate extrema 
   for (int y = radius; y < Ydim - radius; y++)
      for (int x = radius; x < Xdim - radius; x++)
      {
	 // Check for maximum
         bool maximum = true;
	 PIXEL center = Data2D[y][x];
         for (int dy = -radius; dy <= radius && maximum; dy++)
            for (int dx = -radius; dx <= radius && maximum; dx++)
               if (((dx != 0) || (dy != 0)) && 
                  (center < Data2D[y + dy][x + dx]))
                  maximum = false;

	 // Check for minimum
         bool minimum = true;
	 center = Data2D[y][x];
         for (int dy = -radius; dy <= radius && minimum; dy++)
            for (int dx = -radius; dx <= radius && minimum; dx++)
               if (((dx != 0) || (dy != 0)) && 
                  (center > Data2D[y + dy][x + dx]))
                  minimum = false;

         // Save result
         if (maximum)
	    out.Data2D[y][x] = center;
         else if (minimum)
	    out.Data2D[y][x] = -center;
         else
	    out.Data2D[y][x] = 0;
      }
   Swap(out);
}

//============================================================
void IM_TYPE::Corner()
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Define 5x5 templates for 90 degree corners
   int c1[5][5] = {{+1,+1,+1,+1,+1}, 
                   {-1,+1,+1,+1,-1}, 
                   {-1,-1,+1,-1,-1}, 
                   {-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}};
   int c2[5][5] = {{-1,-1,+1,+1,+1}, 
                   {-1,-1,+1,+1,+1}, 
                   {-1,-1,+1,+1,+1}, 
                   {-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}};
   int c3[5][5] = {{-1,-1,-1,-1,+1}, 
                   {-1,-1,-1,+1,+1}, 
                   {-1,-1,+1,+1,+1}, 
                   {-1,-1,-1,+1,+1}, 
                   {-1,-1,-1,-1,+1}};
   int c4[5][5] = {{-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}, 
                   {-1,-1,+1,+1,+1}, 
                   {-1,-1,+1,+1,+1}, 
                   {-1,-1,+1,+1,+1}};
   int c5[5][5] = {{-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}, 
                   {-1,-1,+1,-1,-1}, 
                   {-1,+1,+1,+1,-1}, 
                   {+1,+1,+1,+1,+1}};
   int c6[5][5] = {{-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}, 
                   {+1,+1,+1,-1,-1}, 
                   {+1,+1,+1,-1,-1}, 
                   {+1,+1,+1,-1,-1}};
   int c7[5][5] = {{+1,-1,-1,-1,-1}, 
                   {+1,+1,-1,-1,-1}, 
                   {+1,+1,+1,-1,-1}, 
                   {+1,+1,-1,-1,-1}, 
                   {+1,-1,-1,-1,-1}};
   int c8[5][5] = {{+1,+1,+1,-1,-1}, 
                   {+1,+1,+1,-1,-1}, 
                   {+1,+1,+1,-1,-1}, 
                   {-1,-1,-1,-1,-1}, 
                   {-1,-1,-1,-1,-1}};

   // Convolve image with corner templates
   for (int y=2; y<Ydim-2; y++)
      for (int x=2; x<Xdim-2; x++)
      {
         PIXEL score1 = 0;
         PIXEL score2 = 0;
         PIXEL score3 = 0;
         PIXEL score4 = 0;
         PIXEL score5 = 0;
         PIXEL score6 = 0;
         PIXEL score7 = 0;
         PIXEL score8 = 0;
         for (int dy = -2; dy <= 2; dy++)
         for (int dx = -2; dx <= 2; dx++)
         { 
            PIXEL pixel = Data2D[y+dy][x+dx]+1;
            score1 += c1[2+dy][2+dx] * pixel;
            score2 += c2[2+dy][2+dx] * pixel;
            score3 += c3[2+dy][2+dx] * pixel;
            score4 += c4[2+dy][2+dx] * pixel;
            score5 += c5[2+dy][2+dx] * pixel;
            score6 += c6[2+dy][2+dx] * pixel;
            score7 += c7[2+dy][2+dx] * pixel;
            score8 += c8[2+dy][2+dx] * pixel;
         }
         PIXEL max = score1;
         if (max < score2) max = score2; 
         if (max < score3) max = score3; 
         if (max < score4) max = score4; 
         if (max < score5) max = score5; 
         if (max < score6) max = score6; 
         if (max < score7) max = score7; 
         if (max < score8) max = score8; 
         out.Data2D[y][x] = max;
      }

   // Write output image
   out.Maxima(2);
   Swap(out);
}

//============================================================
void IM_TYPE::Watershed(float sigma, im_short & region)
{
   // Create gradient image
   im_float gradient(*this);
   gradient.Gaussian(sigma);
   gradient.Gradient();
   gradient.Greymap(0, 100);
   gradient.Window(1, 100);
   
   // Initialize region image
   region.Alloc(Xdim, Ydim);
   for (int y=0; y<Ydim; y++)
   for (int x=0; x<Xdim; x++)
      region.Data2D[y][x] = 0;
   for (int y=0; y<Ydim; y++)
      region.Data2D[y][0] = region.Data2D[y][Xdim-1] = 1;
   for (int x=0; x<Xdim; x++)
      region.Data2D[0][x] = region.Data2D[Ydim-1][x] = 1;

   // Initialize direction image
   im_short direction;
   direction.Alloc(Xdim, Ydim);
   for (int y=0; y<Ydim; y++)
   for (int x=0; x<Xdim; x++)
      direction.Data2D[y][x] = 0;
   for (int y=0; y<Ydim; y++)
      direction.Data2D[y][0] = direction.Data2D[y][Xdim-1] = 4;
   for (int x=0; x<Xdim; x++)
      direction.Data2D[0][x] = direction.Data2D[Ydim-1][x] = 4;
   
   // Initialize directions
   int dx[9] = { -1, -1, -1, 0, 0, 0, 1, 1, 1 };
   int dy[9] = { -1, 0, 1, -1, 0, 1, -1, 0, 1 };

   // Calculate direction image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
         // Search 3x3 neighborhood
         int best_index = 4;
         PIXEL best_pixel = gradient.Data2D[y][x];
         for (int index = 0; index < 9; index++)
         {
            // Search for local minima
            PIXEL pixel = gradient.Data2D[y + dy[index]][x + dx[index]];
            if (best_pixel > pixel)
            {
               best_index = index;
               best_pixel = pixel;
            }
         }

         // Save direction information
         direction.Data2D[y][x] = best_index;
         if (best_index == 4)
            region.Data2D[y][x] = 1;
      }

   // Initialize region statistics
   short min, max;
   region.BlobColor();
   region.MinMax(min, max);
   int count = max + 1;
   float *total = new float[count];
   int *size = new int[count];
   for (int index = 0; index < count; index++)
      total[index] = size[index] = 0;

   // Calculate region image
   for (int y = 1; y < Ydim - 1; y++)
      for (int x = 1; x < Xdim - 1; x++)
      {
         int x_pos = x;
         int y_pos = y;
         int reg = region.Data2D[y_pos][x_pos];
         while (reg == 0)
         {
            int index = direction.Data2D[y_pos][x_pos];
            x_pos = x_pos + dx[index];
            y_pos = y_pos + dy[index];
            reg = region.Data2D[y_pos][x_pos];
         }
         region.Data2D[y][x] = reg;
         total[reg] += Data2D[y][x];
         size[reg]++;
      }

   // Calculate output image
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
         // Save average pixel value
         int reg = region.Data2D[y][x];
         Data2D[y][x] = (PIXEL)(total[reg] / size[reg]);
      }

   // Free memory
   delete []total;
   delete []size;

   // Output debug info
   printf("region count = %d\n", count);
}

//============================================================
void IM_TYPE::NoiseUniform(float range)
{
   // Parameter checking
   if (range < 0)
      range = 0;

   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);

   // Process all pixels
   const int RANGE = 1000000;
   srand(clock());
   for (int index = 0; index < NumPixels; index++)
   {
      float noise = rand() % RANGE / (RANGE - 1.0);
      float result = Data1D[index] + noise * range - range / 2;
      if (result < Min)
	 Data1D[index] = Min;
      else if (result > Max)
	 Data1D[index] = Max;
      else
	 Data1D[index] = (PIXEL) result;
   }
}

//============================================================
void IM_TYPE::NoiseGaussian(float stddev)
{
   // Parameter checking
   if (stddev < 0)
      stddev = 0;

   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);

   // Process all pixels
   const int COUNT = 5;
   const int RANGE = 1000000;
   const float SCALE = 0.129;
   srand(clock());
   for (int index = 0; index < NumPixels; index++)
   {
      // Get gaussian random value between [0..1]
      float noise = 0;
      for (int count = 0; count < COUNT; count++)
	 noise += rand() % RANGE / (RANGE - 1.0);
      noise /= COUNT;

      // Add noise to image
      float result = Data1D[index] + (noise - 0.5) * stddev / SCALE;
      if (result < Min)
	 Data1D[index] = Min;
      else if (result > Max)
	 Data1D[index] = Max;
      else
	 Data1D[index] = (PIXEL) result;
   }
}

//============================================================
void IM_TYPE::NoiseImpulse(char type, float fraction)
{
   // Parameter checking
   if (fraction < 0)
      fraction = 0;
   if (fraction > 1)
      fraction = 1;

   // Calculate current pixel range
   PIXEL Min, Max;
   MinMax(Min, Max);
   PIXEL Salt = (PIXEL) (Min + 0.9 * (Max - Min));
   PIXEL Pepper = (PIXEL) (Min + 0.1 * (Max - Min));

   // Process all pixels
   srand(clock());
   for (int index = 0; index < NumPixels; index++)
   {
      int value = rand() % NumPixels;
      if (value < fraction * NumPixels)
      {
	 if (type == 's')
	    Data1D[index] = Salt;
	 else if (type == 'p')
	    Data1D[index] = Pepper;
	 else if (type == 'b')
	    Data1D[index] = (value % 2 == 0) ? Salt : Pepper;
      }
   }
}

//============================================================
void IM_TYPE::FreqNoise(int count, float range)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.FreqNoise(count, range);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Product(IM_TYPE & in2, float &product)
{
   product = 0;
   int skip = 10;

   // Handle two images with same dimensions
   if ((Xdim == in2.Xdim) && (Ydim == in2.Ydim))
   {
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	    if (Data2D[y][x] != 0)
	    {
	       float temp = Data2D[y][x] * in2.Data2D[y][x];
	       product += temp;
	    }
   }

   // Handle two images with different dimensions
   else
   {
      float xscale = (float) (in2.Xdim - 1) / (float) (Xdim - 1);
      float yscale = (float) (in2.Ydim - 1) / (float) (Ydim - 1);
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	    if (Data2D[y][x] != 0)
	    {
	       int yy = (int) (0.5 + y * yscale);
	       int xx = (int) (0.5 + x * xscale);
	       float temp = Data2D[y][x] * in2.Data2D[yy][xx];
	       product += temp;
	    }
   }
   // product = 100 * product / (Xdim * Ydim);
   product = product / (Xdim * Ydim);
}

//============================================================
void IM_TYPE::Difference(IM_TYPE & in2, float &difference)
{
   difference = 0;
   int skip = 10;

   // Handle two images with same dimensions
   if ((Xdim == in2.Xdim) && (Ydim == in2.Ydim))
   {
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	 {
	    float temp = Data2D[y][x] - in2.Data2D[y][x];
	    if (temp < 0)
	       temp = -temp;
	    difference += temp;
	 }
   }

   // Handle two images with different dimensions
   else
   {
      float xscale = (float) (in2.Xdim - 1) / (float) (Xdim - 1);
      float yscale = (float) (in2.Ydim - 1) / (float) (Ydim - 1);
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	 {
	    int yy = (int) (0.5 + y * yscale);
	    int xx = (int) (0.5 + x * xscale);
	    float temp = Data2D[y][x] - in2.Data2D[yy][xx];
	    if (temp < 0) temp = -temp;
	    difference += temp;
	 }
   }
   // difference = 100 * difference / (Xdim * Ydim);
   difference = difference / (Xdim * Ydim);
}

//============================================================
void IM_TYPE::Difference(IM_TYPE & in2, float &difference, int search)
{
   difference = 0;
   int skip = 10;

   // Handle two images with same dimensions
   if ((Xdim == in2.Xdim) && (Ydim == in2.Ydim))
   {
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	 {
	    // Search for minimum difference
	    float min_temp = Data2D[y][x] - in2.Data2D[y][x];
	    if (min_temp < 0) min_temp = -min_temp;
	    for (int dy = y - search; (dy <= y + search) && (min_temp > 0); dy++)
	       for (int dx = x - search; (dx <= x + search) && (min_temp > 0); dx++)
		  if ((dx >= 0) && (dx < Xdim) && (dy >= 0) && (dy < Ydim))
		  {
		     float temp = Data2D[dy][dx] - in2.Data2D[y][x];
		     if (temp < 0)
			temp = -temp;
		     if (temp < min_temp)
			min_temp = temp;
		  }
	    difference += min_temp;
	 }
   }

   // Handle two images with different dimensions
   else
   {
      float xscale = (float) (in2.Xdim - 1) / (float) (Xdim - 1);
      float yscale = (float) (in2.Ydim - 1) / (float) (Ydim - 1);
      for (int y = skip; y < Ydim - skip; y++)
	 for (int x = skip; x < Xdim - skip; x++)
	 {
	    // Search for minimum difference
	    int yy = (int) (0.5 + y * yscale);
	    int xx = (int) (0.5 + x * xscale);
	    float min_temp = Data2D[y][x] - in2.Data2D[yy][xx];
	    if (min_temp < 0) min_temp = -min_temp;
	    for (int dy = y - search; (dy <= y + search) && (min_temp > 0); dy++)
	       for (int dx = x - search; (dx <= x + search) && (min_temp > 0); dx++)
		  if ((dx >= 0) && (dx < Xdim) && (dy >= 0) && (dy < Ydim))
		  {
		     float temp = Data2D[dy][dx] - in2.Data2D[yy][xx];
		     if (temp < 0)
			temp = -temp;
		     if (temp < min_temp)
			min_temp = temp;
		  }
	    difference += min_temp;
	 }
   }
   // difference = 100 * difference / (Xdim * Ydim);
   difference = difference / (Xdim * Ydim);
}

//============================================================
void IM_TYPE::IdealLP(float freq)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.IdealLP(freq);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::IdealHP(float freq)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.IdealHP(freq);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::IdealBP(float freqL, float freqH)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.IdealBP(freqL, freqH);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::IdealNotch(int u1, int v1, int u2, int v2)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.IdealNotch(u1, v1, u2, v2);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::ButterworthLP(float freq, float power)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.ButterworthLP(freq, power);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::ButterworthHP(float freq, float power, float weight)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.ButterworthHP(freq, power, weight);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::ButterworthBP(float freqL, float freqH, float power)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.ButterworthBP(freqL, freqH, power);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::ButterworthNotch(int cu, int cv, float freq, float power)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.ButterworthNotch(cu, cv, freq, power);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::GaussLP(float freq)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.GaussLP(freq);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::GaussHP(float freq, float weight)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.GaussHP(freq, weight);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::GaussBP(float center, float freq)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.GaussBP(center, freq);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::GaussNotch(int cu, int cv, float freq)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.GaussNotch(cu, cv, freq);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Homomorphic(float freq, float weight)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.Homomorphic(freq, weight);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Derivative(int partialX, int partialY)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.Derivative(partialX, partialY);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Laplacian2()
{
   // Perform operation
   im_complex Copy(*this);
   Copy.Laplacian2();
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::SincLP(float width)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.SincLP(width);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Filter(char *name)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.Filter(name);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::InverseFilter(char *name, float min)
{
   // Perform operation
   im_complex Copy(*this);
   Copy.InverseFilter(name, min);
   Copy.GetReal(*this);
}

//============================================================
void IM_TYPE::Midpoint(float radius)
{
   // Copy input image
   IM_TYPE in(*this);

   // Process all pixels
   int search = (int) (radius + 0.5);
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Find local min and max
	 PIXEL min = in.Data2D[y][x];
	 PIXEL max = in.Data2D[y][x];
	 for (int dy = -search; dy <= search; dy++)
	    for (int dx = -search; dx <= search; dx++)
	    {
	       int dist = dx * dx + dy * dy;
	       if ((dist <= radius * radius) &&
		   (y + dy >= 0) && (y + dy < Ydim) &&
		   (x + dx >= 0) && (x + dx < Xdim))
	       {
		  if (min > in.Data2D[y + dy][x + dx])
		     min = in.Data2D[y + dy][x + dx];
		  if (max < in.Data2D[y + dy][x + dx])
		     max = in.Data2D[y + dy][x + dx];
	       }
	    }
	 Data2D[y][x] = (min + max) / 2;
      }
}

//============================================================
void IM_TYPE::Erode(float radius)
{
   // Copy input image
   IM_TYPE in(*this);

   // Process all pixels
   int search = (int) (radius + 0.5);
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Find local min 
	 PIXEL min = in.Data2D[y][x];
	 for (int dy = -search; dy <= search; dy++)
	    for (int dx = -search; dx <= search; dx++)
	    {
	       int dist = dx * dx + dy * dy;
	       if ((dist <= radius * radius) &&
		   (y + dy >= 0) && (y + dy < Ydim) &&
		   (x + dx >= 0) && (x + dx < Xdim) &&
		   (min > in.Data2D[y + dy][x + dx]))
		  min = in.Data2D[y + dy][x + dx];
	    }
	 Data2D[y][x] = min;
      }
}

//============================================================
void IM_TYPE::Dilate(float radius)
{
   // Copy input image
   IM_TYPE in(*this);

   // Process all pixels
   int search = (int) (radius + 0.5);
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 // Find local max 
	 PIXEL max = in.Data2D[y][x];
	 for (int dy = -search; dy <= search; dy++)
	    for (int dx = -search; dx <= search; dx++)
	    {
	       int dist = dx * dx + dy * dy;
	       if ((dist <= radius * radius) &&
		   (y + dy >= 0) && (y + dy < Ydim) &&
		   (x + dx >= 0) && (x + dx < Xdim) &&
		   (max < in.Data2D[y + dy][x + dx]))
		  max = in.Data2D[y + dy][x + dx];
	    }
	 Data2D[y][x] = max;
      }
}

//============================================================
void IM_TYPE::Open(float radius)
{
   // Perform erode and dilate
   Erode(radius);
   Dilate(radius);
}

//============================================================
void IM_TYPE::Close(float radius)
{
   // Perform dilate and erode
   Dilate(radius);
   Erode(radius);
}

//============================================================
void IM_TYPE::Morphology(char *command, float radius)
{
   // Process sequence of commands
   for (int i = 0; i < (int)strlen(command); i++)
      switch (command[i])
      {
      case 'm':
      case 'M':
	 Midpoint(radius);
	 break;
      case 'e':
      case 'E':
	 Erode(radius);
	 break;
      case 'd':
      case 'D':
	 Dilate(radius);
	 break;
      case 'o':
      case 'O':
	 Open(radius);
	 break;
      case 'c':
      case 'C':
	 Close(radius);
	 break;
      }
}

//============================================================
void IM_TYPE::DrawPoint(int x, int y, int size, PIXEL value)
{
   // Calculate coordinate range for point
   if (size < 1) size = 1;
   int y1 = y - size/2;
   int y2 = y1 + size;
   int x1 = x - size/2;
   int x2 = x1 + size;

   // Fill pixels inside coordinate range
   for (y = y1; y < y2; y++)
      for (x = x1; x < x2; x++)
         if ((x >= 0) && (x < Xdim) && (y >= 0) && (y < Ydim))
            Data2D[y][x] = value;
}

//============================================================
void IM_TYPE::DrawLine(int x1, int y1, int x2, int y2, int size, PIXEL value)
{
   // Calculate step size
   double dx = x2 - x1;
   double dy = y2 - y1;
   double length = sqrt(dx*dx + dy*dy);
   dx = dx / length;
   dy = dy / length;

   // Draw pixels on line
   double x = x1 + 0.5;
   double y = y1 + 0.5;
   for (int i = 0; i <= length; i++)
   {
      DrawPoint((int)x, (int)y, size, value);
      x += dx;
      y += dy;
   }
}

//============================================================
void IM_TYPE::DrawLine(float M, float B, int size, PIXEL value)
{
   int x1 = 0;
   int y1 = M * x1 + B;
   int x2 = Xdim-1;
   int y2 = M * x2 + B;
   DrawLine(x1,y1, x2,y2, size, value);
}

//============================================================
void IM_TYPE::RegionGrow(float threshold)
{
   // Create extrema image
   IM_TYPE extrema(*this);
   extrema.Extrema(2);

   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Segment image using region growing
   int color = 1;
   for (int y = 0; y < Ydim; y++)
   for (int x = 0; x < Xdim; x++)
      {
      // Perform region growing
      if ((extrema.Data2D[y][x] != 0) && (out.Data2D[y][x] == 0))
      {
         int size = 1;
         float total = Data2D[y][x];
         RegionGrowStack(out, x, y, total, size, threshold, color++);
         if (size < 50)
            out.BlobUnColor(x, y, --color);
      }
   }
   Swap(out);
}

//============================================================
void IM_TYPE::RegionGrow(int x, int y, float threshold)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Grow region from seed point
   int size = 1;
   float total = Data2D[y][x];
   RegionGrowStack(out, x, y, total, size, threshold, 255);
   Swap(out);
}

//============================================================
void IM_TYPE::RegionGrowRecursive(IM_TYPE &output, int x, int y, 
   float &total, int &size, float threshold, PIXEL color)
{
   // Check terminating conditions
   if ((x >= 0) && (x < Xdim) && (y >= 0) && (y < Ydim) &&
      (output.Data2D[y][x] == 0) && 
      (fabs(total / size - Data2D[y][x]) < threshold))
   {
      // Update output image
      output.Data2D[y][x] = color;
      total += Data2D[y][x];
      size++;

      // Make recursive calls
      if ((y-1 >= 0) && (output.Data2D[y-1][x] == 0))
         RegionGrowRecursive(output, x, y - 1, total, size, threshold, color);
      if ((y+1 < Ydim) && (output.Data2D[y+1][x] == 0))
         RegionGrowRecursive(output, x, y + 1, total, size, threshold, color);
      if ((x-1 >= 0) && (output.Data2D[y][x-1] == 0))
         RegionGrowRecursive(output, x - 1, y, total, size, threshold, color);
      if ((x+1 < Xdim) && (output.Data2D[y][x+1] == 0))
         RegionGrowRecursive(output, x + 1, y, total, size, threshold, color);
   }
}

//============================================================
void IM_TYPE::RegionGrowStack(IM_TYPE &output, int x, int y, 
   float &total, int &size, float threshold, PIXEL color)
{
   // Push seed point on stack
   int *sx = new int[NumPixels];
   int *sy = new int[NumPixels];
   int top = 0;
   sx[top] = x;
   sy[top] = y;

   // Iteratively add points to region
   while (top >= 0)
   {
      // Pop point from stack
      int x = sx[top];
      int y = sy[top];
      top--;

      // Compare point to region
      if ((x >= 0) && (x < Xdim) && (y >= 0) && (y < Ydim) &&
         (output.Data2D[y][x] == 0) && 
         (fabs(total / size - Data2D[y][x]) < threshold))
      {
	 // Add point to region
	 output.Data2D[y][x] = color;
	 total += Data2D[y][x];
	 size++;

	 // Add neighbors to stack
         if ((x+1 < Xdim) && (output.Data2D[y][x+1] == 0) && (top < NumPixels))
	 {
	    top++;
	    sx[top] = x + 1;
	    sy[top] = y;
	 }
         if ((x-1 >= 0) && (output.Data2D[y][x-1] == 0) && (top < NumPixels))
	 {
	    top++;
	    sx[top] = x - 1;
	    sy[top] = y;
	 }
         if ((y+1 < Ydim) && (output.Data2D[y+1][x] == 0) && (top < NumPixels))
	 {
	    top++;
	    sx[top] = x;
	    sy[top] = y + 1;
	 }
         if ((y-1 >= 0) && (output.Data2D[y-1][x] == 0) && (top < NumPixels))
	 {
	    top++;
	    sx[top] = x;
	    sy[top] = y - 1;
	 }
      }
   }

   // Release memory
   delete []sx;
   delete []sy;
}

//============================================================
void IM_TYPE::GetFeatures(int feature[], int num_rows, int num_cols)
{
   // Get pixel counts in each region
   int index = 0;
   int total = 1;
   for (int row = 0; row < num_rows; row++)
      for (int col = 0; col < num_cols; col++)
      {
	 // Define region
	 int xmin = col * Xdim / num_cols;
	 int ymin = row * Ydim / num_rows;
	 int xmax = (col + 1) * Xdim / num_cols;
	 int ymax = (row + 1) * Ydim / num_rows;
	 if (xmax > Xdim)
	    xmax = Xdim;
	 if (ymax > Ydim)
	    ymax = Ydim;

	 // Count pixels
	 int count = 0;
	 for (int y = ymin; y < ymax; y++)
	    for (int x = xmin; x < xmax; x++)
	       count += (int) (Data2D[y][x]);
	 feature[index++] = count;
	 total += count;
      }

   // Normalize features
   int num_features = num_rows * num_cols;
   for (index = 0; index < num_features; index++)
      feature[index] = 100 * feature[index] / total;
   feature[num_features] = total;
}

//============================================================
void IM_TYPE::BlobColor()
{
   // Allocate parent array
   int Parent[NumPixels];
   for (int i=0; i<NumPixels; i++)
      Parent[i] = -1;

   // Search for blobs
   int color = 2;
   const int MAX_COLOR = 32767;
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
	 if (Data2D[y][x] == 1)
	 {
            // Get values of neighbors
            int a = (int)((x>0) ? Data2D[y][x-1] : 0);
            int b = (int)((y>0) ? Data2D[y-1][x] : 0);
            int c = (int)((y>0 && x>0) ? Data2D[y-1][x-1] : 0);
            int d = (int)((y>0 && x<Xdim-1) ? Data2D[y-1][x+1] : 0);

            // Get max region 
            int max = a;
            if (max < b) max = b;
            if (max < c) max = c;
            if (max < d) max = d;
            
            // Save blob color
            if (max == 0)
            {
               Data2D[y][x] = color;
               if (color < MAX_COLOR) color++;
            }
            else
            {
               Data2D[y][x] = max;

               // Merge regions
               int max_parent = max;
               while (Parent[max_parent] > 0) max_parent = Parent[max_parent];
               if (Parent[max] > 0) Parent[max] = max_parent;

               if ((a > 0) && (a != max))
               {
                  int a_parent = a;
                  while (Parent[a_parent] > 0) a_parent = Parent[a_parent];
                  if (a_parent != max_parent) Parent[a] = Parent[a_parent] = max_parent;
               }

               if ((b > 0) && (b != max))
               {
                  int b_parent = b;
                  while (Parent[b_parent] > 0) b_parent = Parent[b_parent];
                  if (b_parent != max_parent) Parent[b] = Parent[b_parent] = max_parent;
               }

               if ((c > 0) && (c != max))
               {
                  int c_parent = c;
                  while (Parent[c_parent] > 0) c_parent = Parent[c_parent];
                  if (c_parent != max_parent) Parent[c] = Parent[c_parent] = max_parent;
               }

               if ((d > 0) && (d != max))
               {
                  int d_parent = d;
                  while (Parent[d_parent] > 0) d_parent = Parent[d_parent];
                  if (d_parent != max_parent) Parent[d] = Parent[d_parent] = max_parent;
               }
            }
	 }

   // Count regions
   int count = 0;
   for (int i = 0; i < color; i++)
      if (Parent[i] < 0)
         Parent[i] = -(count++);

   // Renumber regions
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
	 if (Data2D[y][x] > 0)
	 {
            int parent = (int)Data2D[y][x];
            while (Parent[parent] > 0) parent = Parent[parent];
            Data2D[y][x] = -Parent[parent];
         }
}

//============================================================
void IM_TYPE::BlobColor(int min_size)
{
   // Search for blobs
   int color = 2;
   const int MAX_COLOR = 32767;
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
	 if (Data2D[y][x] == 1)
	 {
	    // Recursively color blobs
            int blob_size = 0;
	    BlobColor(x, y, color, blob_size);
	    if (blob_size < min_size)
	       BlobUnColor(x, y, color);
            if (color < MAX_COLOR) color++;
	 }
}

//============================================================
void IM_TYPE::BlobColor(int x, int y, int color, int & blob_size)
{
   // Color pixel and neighbors
   if (Data2D[y][x] == 1)
   {
      blob_size++;
      Data2D[y][x] = color;

      if (x - 1 >= 0)
	 BlobColor(x - 1, y, color, blob_size);
      if (y - 1 >= 0)
	 BlobColor(x, y - 1, color, blob_size);
      if (x + 1 < Xdim)
	 BlobColor(x + 1, y, color, blob_size);
      if (y + 1 < Ydim)
	 BlobColor(x, y + 1, color, blob_size);

      if ((x - 1 >= 0) && (y - 1 >= 0))
	 BlobColor(x - 1, y - 1, color, blob_size);
      if ((x + 1 < Xdim) && (y - 1 >= 0))
	 BlobColor(x + 1, y - 1, color, blob_size);
      if ((x + 1 < Xdim) && (y + 1 < Ydim))
	 BlobColor(x + 1, y + 1, color, blob_size);
      if ((x - 1 >= 0) && (y + 1 < Ydim))
	 BlobColor(x - 1, y + 1, color, blob_size);
   }
}

//============================================================
void IM_TYPE::BlobUnColor(int x, int y, int color)
{
   // UnColor pixel and neighbors
   if (Data2D[y][x] == color)
   {
      Data2D[y][x] = 0;

      if (x - 1 >= 0)
	 BlobUnColor(x - 1, y, color);
      if (y - 1 >= 0)
	 BlobUnColor(x, y - 1, color);
      if (x + 1 < Xdim)
	 BlobUnColor(x + 1, y, color);
      if (y + 1 < Ydim)
	 BlobUnColor(x, y + 1, color);

      if ((x - 1 >= 0) && (y - 1 >= 0))
	 BlobUnColor(x - 1, y - 1, color);
      if ((x + 1 < Xdim) && (y - 1 >= 0))
	 BlobUnColor(x + 1, y - 1, color);
      if ((x + 1 < Xdim) && (y + 1 < Ydim))
	 BlobUnColor(x + 1, y + 1, color);
      if ((x - 1 >= 0) && (y + 1 < Ydim))
	 BlobUnColor(x - 1, y + 1, color);
   }
}

//============================================================
void IM_TYPE::RegionBoundary(int color)
{
   // Create output image
   IM_TYPE out(Xdim, Ydim);

   // Find region boundaries
   for (int y = 1; y < Ydim; y++)
      for (int x = 1; x < Xdim; x++)
         if ((Data2D[y][x] != Data2D[y][x-1]) || 
             (Data2D[y][x] != Data2D[y-1][x]))
            out.Data2D[y][x] = color;
   Swap(out);
}

//============================================================
void IM_TYPE::CheckNeighbor(IM_TYPE & x_pos, IM_TYPE & y_pos,
			    int x, int y, int dx, int dy)
{
   int x2 = x + dx;
   int y2 = y + dy;
   if ((x2 >= 0) && (x2 < Xdim) &&
       (y2 >= 0) && (y2 < Ydim) && 
       (Data2D[y2][x2] < Data2D[y][x]))
   {
      int dx2 = (int) (x_pos.Data2D[y2][x2] - x);
      int dy2 = (int) (y_pos.Data2D[y2][x2] - y);
      int dist2 = dx2 * dx2 + dy2 * dy2;
      if (dist2 < Data2D[y][x] * Data2D[y][x])
      {
	 x_pos.Data2D[y][x] = x_pos.Data2D[y2][x2];
	 y_pos.Data2D[y][x] = y_pos.Data2D[y2][x2];
	 Data2D[y][x] = (int) sqrt((float) dist2);
      }
   }
}

//============================================================
void IM_TYPE::Distance()
{
   // Make temporary images
   IM_TYPE out(Xdim, Ydim);
   IM_TYPE x_pos(Xdim, Ydim);
   IM_TYPE y_pos(Xdim, Ydim);

   // Initialze distances
   int MAX_DIST = (int) sqrt((float) (Xdim * Xdim + Ydim * Ydim));
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
	 if (Data2D[y][x] == 1)
	 {
	    x_pos.Data2D[y][x] = x;
	    y_pos.Data2D[y][x] = y;
	    Data2D[y][x] = 0;
	 }
	 else
	 {
	    x_pos.Data2D[y][x] = 0;
	    y_pos.Data2D[y][x] = 0;
	    Data2D[y][x] = MAX_DIST;
	 }

   // Forward X, forward Y pass
   for (int y = 0; y < Ydim; y++)
      for (int x = 0; x < Xdim; x++)
      {
	 CheckNeighbor(x_pos, y_pos, x, y, -1, 0);
	 CheckNeighbor(x_pos, y_pos, x, y, 0, -1);
	 CheckNeighbor(x_pos, y_pos, x, y, -1, -1);
      }

   // Backward X, forward Y pass
   for (int y = 0; y < Ydim; y++)
      for (int x = Xdim - 1; x >= 0; x--)
      {
	 CheckNeighbor(x_pos, y_pos, x, y, 1, 0);
	 CheckNeighbor(x_pos, y_pos, x, y, 0, -1);
	 CheckNeighbor(x_pos, y_pos, x, y, 1, -1);
      }

   // Forward X, backward Y pass
   for (int y = Ydim - 1; y >= 0; y--)
      for (int x = 0; x < Xdim; x++)
      {
	 CheckNeighbor(x_pos, y_pos, x, y, -1, 0);
	 CheckNeighbor(x_pos, y_pos, x, y, 0, 1);
	 CheckNeighbor(x_pos, y_pos, x, y, -1, 1);
      }

   // Backward X, backward Y pass
   for (int y = Ydim - 1; y >= 0; y--)
      for (int x = Xdim - 1; x >= 0; x--)
      {
	 CheckNeighbor(x_pos, y_pos, x, y, 1, 0);
	 CheckNeighbor(x_pos, y_pos, x, y, 0, 1);
	 CheckNeighbor(x_pos, y_pos, x, y, 1, 1);
      }
}

