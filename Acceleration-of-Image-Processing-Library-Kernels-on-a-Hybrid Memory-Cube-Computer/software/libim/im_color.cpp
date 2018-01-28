//============================================================
//  File:       im_color.cpp
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#include "im_color.h"
#include "../jpeg/jpeg.h"

//============================================================
im_color::im_color()
{
   // Allocate image
   Clear();
}

//============================================================
im_color::im_color(int xdim)
{
   // Allocate image
   Clear();
   Alloc(xdim, 1);
}

//============================================================
im_color::im_color(int xdim, int ydim)
{
   // Allocate image
   Clear();
   Alloc(xdim, ydim);
}

//============================================================
im_color::im_color(const im_color & copy)
{
   // Allocate image
   Clear();
   Copy(copy);
}

//============================================================
im_color::~im_color()
{
   // Empty
}

//============================================================
void im_color::Clear()
{
   // Clear image
   R.Clear();
   G.Clear();
   B.Clear();
}

//============================================================
void im_color::Free()
{
   // Process RGB images
   R.Free();
   G.Free();
   B.Free();
}

//============================================================
void im_color::Alloc(int xdim, int ydim)
{
   // Process RGB images
   R.Alloc(xdim, ydim);
   G.Alloc(xdim, ydim);
   B.Alloc(xdim, ydim);
}

//============================================================
void im_color::Swap(im_color & copy)
{
   // Process RGB images
   R.Swap(copy.R);
   G.Swap(copy.G);
   B.Swap(copy.B);
}

//============================================================
void im_color::Copy(const im_color & copy)
{
   // Process RGB images
   R.Copy(copy.R);
   G.Copy(copy.G);
   B.Copy(copy.B);
}

//============================================================
bool im_color::ReadHeader(FILE *fd, char* pix_type, int &xdim, int &ydim, int &max)
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
bool im_color::WriteAscii(char *filename)
{
   // Map values to 0..255 range
   short r_min, r_max, g_min, g_max, b_min, b_max;
   MinMax(r_min, r_max, g_min, g_max, b_min, b_max);
   if ((r_min < 0) || (r_max > 255) ||
       (g_min < 0) || (g_max > 255) ||
       (b_min < 0) || (b_max > 255))
      Greymap(0, 255);
	
   // Open output file
   FILE *fd = fopen(filename, "w");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Write header in portable pixmap file format (PPM)
   if (fprintf(fd, "P3\n%d %d\n%d\n", R.Xdim, R.Ydim, 255) <= 0)
   { printf("Error: Could not write header\n"); return false; }

   // Write pixels
   for (int index = 0; index < R.NumPixels; index++)
      if (fprintf(fd, "%d %d %d ", R.Data1D[index], G.Data1D[index], B.Data1D[index]) <= 0)
      { printf("Error: Could not write pixel\n"); return false; }
   fprintf(fd, "\n");

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool im_color::ReadAscii(char *filename)
{
   // Open input file
   FILE *fd = fopen(filename, "r");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read header in portable pixmap file format (PPM)
   char pix_type[STRLEN];
   int xdim, ydim, max;
   ReadHeader(fd, pix_type, xdim, ydim, max);

   // Check pix_type
   if (strcmp(pix_type, "P3") != 0)
   { printf("Error: Expecting PPM P3 format file\n"); return false; }

   // Allocate image
   Alloc(xdim, ydim);

   // Read pixels
   for (int index = 0; index < R.NumPixels; index++)
   {
      int tempR, tempG, tempB;
      if (fscanf(fd, "%d %d %d", &tempR, &tempG, &tempB) != 3)
      { printf("Error: Could not read pixel\n"); return false; }
      R.Data1D[index] = tempR;
      G.Data1D[index] = tempG;
      B.Data1D[index] = tempB;
   }

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool im_color::WriteBinary(char *filename)
{
   // Map values to 0..255 range
   short r_min, r_max, g_min, g_max, b_min, b_max;
   MinMax(r_min, r_max, g_min, g_max, b_min, b_max);
   if ((r_min < 0) || (r_max > 255) ||
       (g_min < 0) || (g_max > 255) ||
       (b_min < 0) || (b_max > 255))
      Greymap(0, 255);

   // Open output file
   FILE *fd = fopen(filename, "wb");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Write header in portable pixmap file format (PPM)
   if (fprintf(fd, "P6\n%d %d\n%d\n", R.Xdim, R.Ydim, 255) <= 0)
   { printf("Error: Could not write header\n"); return false; }

   // Copy pixels
   unsigned char *data = (unsigned char *) calloc(R.NumPixels*3,1);
   for (int index = 0; index < R.NumPixels; index++)
   {
      data[3*index+0] = (unsigned char) R.Data1D[index];
      data[3*index+1] = (unsigned char) G.Data1D[index];
      data[3*index+2] = (unsigned char) B.Data1D[index];
   }
  
   // Write pixels   
   if (R.NumPixels*3 != (int) fwrite((void *) data,
      sizeof(unsigned char), R.NumPixels*3, fd))
   { printf("Error: Could not write data\n"); return false; }
   free(data);
   data = NULL;

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool im_color::ReadBinary(char *filename)
{
   // Open input file
   FILE *fd = fopen(filename, "r");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read header in portable pixmap file format (PPM)
   char pix_type[STRLEN];
   int xdim, ydim, max;
   ReadHeader(fd, pix_type, xdim, ydim, max);

   // Check pix_type
   if (strcmp(pix_type, "P6") != 0)
   { printf("Error: Expecting PPM P6 format file\n"); return false; }

   // Allocate image
   Alloc(xdim, ydim);

   // Read pixels   
   unsigned char *data = (unsigned char *) calloc(R.NumPixels*3,1);
   if (R.NumPixels*3 != (int) fread((void *) data,       
      sizeof(unsigned char), R.NumPixels*3, fd))
   { printf("Error: Could not read data\n"); return false; }

   // Copy pixels
   for (int index = 0; index < R.NumPixels; index++)
   {
      R.Data1D[index] = data[3*index+0];
      G.Data1D[index] = data[3*index+1];
      B.Data1D[index] = data[3*index+2];
   }
   free(data);
   data = NULL;

   // Close file
   fclose(fd);
   return true;
}

//============================================================
bool im_color::WriteJpg(char *filename)
{
   // Map values to 0..255 range
   short r_min, r_max, g_min, g_max, b_min, b_max;
   MinMax(r_min, r_max, g_min, g_max, b_min, b_max);
   if ((r_min < 0) || (r_max > 255) ||
       (g_min < 0) || (g_max > 255) ||
       (b_min < 0) || (b_max > 255))
      Greymap(0, 255);

   // Open JPEG image
   FILE *fd = fopen(filename, "wb");
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Copy data to buffer
   unsigned char *buffer = new unsigned char[R.NumPixels * 3];
   for (int i = 0; i < R.NumPixels; i++)
   {
      buffer[3 * i + 0] = (unsigned char) R.Data1D[i];
      buffer[3 * i + 1] = (unsigned char) G.Data1D[i];
      buffer[3 * i + 2] = (unsigned char) B.Data1D[i];
   }

   // Write JPEG image
   JPEG_write_data(fd, JPEG_RGB, R.Xdim, R.Ydim, (char *) buffer);
   fclose(fd);

   // Release memory
   delete[]buffer;
   return true;
}

//============================================================
bool im_color::ReadJpg(char *filename)
{
   // Open JPEG image
   FILE *fd = JPEG_open(filename);
   if (fd == NULL)
   { printf("Error: Could not open file '%s'\n", filename); return false; }

   // Read JPEG image header
   int pixtype, xdim, ydim;
   JPEG_read_header(fd, &pixtype, &xdim, &ydim);

   // Read GRAY image
   if (pixtype == JPEG_GRAY)
   {
      // Allocate image
      Alloc(xdim, ydim);

      // Read JPEG image
      unsigned char *buffer = new unsigned char[R.NumPixels];
      JPEG_read_data(fd, (char *) buffer);
      fclose(fd);

      // Copy data from buffer
      for (int i = 0; i < R.NumPixels; i++)
      {
	 R.Data1D[i] = (short) buffer[i];
	 G.Data1D[i] = (short) buffer[i];
	 B.Data1D[i] = (short) buffer[i];
      }

      // Release memory
      delete[]buffer;
   }

   // Read RGB image
   else if (pixtype == JPEG_RGB)
   {
      // Allocate image
      Alloc(xdim, ydim);

      // Read JPEG image
      unsigned char *buffer = new unsigned char[R.NumPixels * 3];
      JPEG_read_data(fd, (char *) buffer);
      fclose(fd);

      // Copy data from buffer
      for (int i = 0; i < R.NumPixels; i++)
      {
	 R.Data1D[i] = (short) buffer[3 * i];
	 G.Data1D[i] = (short) buffer[3 * i + 1];
	 B.Data1D[i] = (short) buffer[3 * i + 2];
      }

      // Release memory
      delete[]buffer;
   }

   // Not JPEG format
   else
   { printf("Error: Invalid JPEG image format\n"); return false; }
   return true;
}

//============================================================
void im_color::Add(im_color & in2)
{
   // Process RGB images
   R.Add(in2.R);
   G.Add(in2.G);
   B.Add(in2.B);
}

//============================================================
void im_color::Subtract(im_color & in2)
{
   // Process RGB images
   R.Subtract(in2.R);
   G.Subtract(in2.G);
   B.Subtract(in2.B);
}

//============================================================
void im_color::Multiply(im_color & in2)
{
   // Process RGB images
   R.Multiply(in2.R);
   G.Multiply(in2.G);
   B.Multiply(in2.B);
}

//============================================================
void im_color::Divide(im_color & in2)
{
   // Process RGB images
   R.Divide(in2.R);
   G.Divide(in2.G);
   B.Divide(in2.B);
}

//============================================================
void im_color::Threshold(float value, bool invert)
{
   // Process RGB images
   R.Threshold(value, invert);
   G.Threshold(value, invert);
   B.Threshold(value, invert);
}

//============================================================
void im_color::ThresholdAutomatic(bool invert)
{
   // Process RGB images
   R.ThresholdAutomatic(invert);
   G.ThresholdAutomatic(invert);
   B.ThresholdAutomatic(invert);
}

//============================================================
void im_color::Window(int low, int high)
{
   // Process RGB images
   R.Window(low, high);
   G.Window(low, high);
   B.Window(low, high);
}

//============================================================
void im_color::Trim(float fraction)
{
   // Process RGB images
   R.Trim(fraction);
   G.Trim(fraction);
   B.Trim(fraction);
}

//============================================================
void im_color::Greymap(int low, int high)
{
   // Process RGB images
   R.Greymap(low, high);
   G.Greymap(low, high);
   B.Greymap(low, high);
}

//============================================================
void im_color::Quantize(int levels, int iterations)
{
   // Process RGB images
   R.Quantize(levels, iterations);
   G.Quantize(levels, iterations);
   B.Quantize(levels, iterations);
}

//============================================================
void im_color::Invert()
{
   // Process RGB images
   R.Invert();
   G.Invert();
   B.Invert();
}

//============================================================
void im_color::Equalize()
{
   // Process RGB images
   R.Equalize();
   G.Equalize();
   B.Equalize();
}

//============================================================
void im_color::Equalize(int regions)
{
   // Process RGB images
   R.Equalize(regions);
   G.Equalize(regions);
   B.Equalize(regions);
}

//============================================================
void im_color::UnsharpMasking(float sigma, float weight)
{
   // Process RGB images
   R.UnsharpMasking(sigma, weight);
   G.UnsharpMasking(sigma, weight);
   B.UnsharpMasking(sigma, weight);
}

//============================================================
void im_color::UnsharpMasking(int iterations, float weight)
{
   // Process RGB images
   R.UnsharpMasking(iterations, weight);
   G.UnsharpMasking(iterations, weight);
   B.UnsharpMasking(iterations, weight);
}

//============================================================
void im_color::Power(float gamma)
{
   // Process RGB images
   R.Power(gamma);
   G.Power(gamma);
   B.Power(gamma);
}

//============================================================
void im_color::Cubic(float param)
{
   // Process RGB images
   R.Cubic(param);
   G.Cubic(param);
   B.Cubic(param);
}

//============================================================
void im_color::Stretch(int r1, int s1, int r2, int s2)
{
   // Process RGB images
   R.Stretch(r1, s1, r2, s2);
   G.Stretch(r1, s1, r2, s2);
   B.Stretch(r1, s1, r2, s2);
}

//============================================================
void im_color::Wallis(int radius, float gain)
{
   // Process RGB images
   R.Wallis(radius, gain);
   G.Wallis(radius, gain);
   B.Wallis(radius, gain);
}

//============================================================
void im_color::Average(int xdim, int ydim)
{
   // Process RGB images
   R.Average(xdim, ydim);
   G.Average(xdim, ydim);
   B.Average(xdim, ydim);
}

//============================================================
void im_color::Binomial()
{
   // Process RGB images
   R.Binomial();
   G.Binomial();
   B.Binomial();
}

//============================================================
void im_color::Binomial(int iterations)
{
   // Process RGB images
   R.Binomial(iterations);
   G.Binomial(iterations);
   B.Binomial(iterations);
}

//============================================================
void im_color::Convolve(int xdim, int ydim, float weight[])
{
   // Process RGB images
   R.Convolve(xdim, ydim, weight);
   G.Convolve(xdim, ydim, weight);
   B.Convolve(xdim, ydim, weight);
}

//============================================================
void im_color::Median(int xdim, int ydim)
{
   // Process RGB images
   R.Median(xdim, ydim);
   G.Median(xdim, ydim);
   B.Median(xdim, ydim);
}

//============================================================
void im_color::Gaussian(float sigma)
{
   // Process RGB images
   R.Gaussian(sigma);
   G.Gaussian(sigma);
   B.Gaussian(sigma);
}

//============================================================
void im_color::AdaptiveGaussian(float sigma1, float sigma2)
{
   // Process RGB images
   R.AdaptiveGaussian(sigma1, sigma2);
   G.AdaptiveGaussian(sigma1, sigma2);
   B.AdaptiveGaussian(sigma1, sigma2);
}

//============================================================
void im_color::OutlierRemoval(int xdim, int ydim, float threshold)
{
   // Process RGB images
   R.OutlierRemoval(xdim, ydim, threshold);
   G.OutlierRemoval(xdim, ydim, threshold);
   B.OutlierRemoval(xdim, ydim, threshold);
}

//============================================================
void im_color::kNN(int xdim, int ydim, int K)
{
   // Process RGB images
   R.kNN(xdim, ydim, K);
   G.kNN(xdim, ydim, K);
   B.kNN(xdim, ydim, K);
}

//============================================================
void im_color::AlphaMean(int xdim, int ydim, int Alpha)
{
   // Process RGB images
   R.AlphaMean(xdim, ydim, Alpha);
   G.AlphaMean(xdim, ydim, Alpha);
   B.AlphaMean(xdim, ydim, Alpha);
}

//============================================================
void im_color::Translate(float dx, float dy, char bound)
{
   // Process RGB images
   R.Translate(dx, dy, bound);
   G.Translate(dx, dy, bound);
   B.Translate(dx, dy, bound);
}

//============================================================
void im_color::Rotate(float angle, int cx, int cy, char bound)
{
   // Process RGB images
   R.Rotate(angle, cx, cy, bound);
   G.Rotate(angle, cx, cy, bound);
   B.Rotate(angle, cx, cy, bound);
}

//============================================================
void im_color::Scale(float sx, float sy, int cx, int cy, char bound)
{
   // Process RGB images
   R.Scale(sx, sy, cx, cy, bound);
   G.Scale(sx, sy, cx, cy, bound);
   B.Scale(sx, sy, cx, cy, bound);
}

//============================================================
void im_color::Shear(float sx, float sy, int cx, int cy, char bound)
{
   // Process RGB images
   R.Shear(sx, sy, cx, cy, bound);
   G.Shear(sx, sy, cx, cy, bound);
   B.Shear(sx, sy, cx, cy, bound);
}

//============================================================
void im_color::Interpolate(int xdim, int ydim)
{
   // Process RGB images
   R.Interpolate(xdim, ydim);
   G.Interpolate(xdim, ydim);
   B.Interpolate(xdim, ydim);
}

//============================================================
void im_color::InterpolateNN(int xdim, int ydim)
{
   // Process RGB images
   R.InterpolateNN(xdim, ydim);
   G.InterpolateNN(xdim, ydim);
   B.InterpolateNN(xdim, ydim);
}

//============================================================
void im_color::MakeIcon(int size)
{
   // Process RGB images
   R.MakeIcon(size);
   G.MakeIcon(size);
   B.MakeIcon(size);
}

//============================================================
void im_color::Extract(int x1, int x2, int y1, int y2)
{
   // Process RGB images
   R.Extract(x1, x2, y1, y2);
   G.Extract(x1, x2, y1, y2);
   B.Extract(x1, x2, y1, y2);
}

//============================================================
void im_color::FitRectangle(int &x1, int &x2, int &y1, int &y2, int search, char method)
{
   // Get luminance image
   im_short im;
   GetLuminance(im);

   // Fit rectangle 
   im.FitRectangle(x1, x2, y1, y2, search, method);
}

//============================================================
void im_color::FitExtract(int x1, int x2, int y1, int y2, int search, char method)
{
   // Fit rectangle
   FitRectangle(x1, x2, y1, y2, search, method);

   // Perform extract
   Extract(x1, x2, y1, y2);
}

//============================================================
void im_color::PrintRange()
{
   short r_min, r_max, g_min, g_max, b_min, b_max;
   MinMax(r_min, r_max, g_min, g_max, b_min, b_max);
   printf("R[%d..%d], G[%d..%d], B[%d..%d]\n",
      r_min, r_max, g_min, g_max, b_min, b_max);
}

//============================================================
void im_color::MinMax(short &r_min, short &r_max,
		      short &g_min, short &g_max, 
		      short &b_min, short &b_max)
{
   // Process RGB images
   R.MinMax(r_min, r_max);
   G.MinMax(g_min, g_max);
   B.MinMax(b_min, b_max);
}

//============================================================
void im_color::Statistics(double &r_mean, double &r_stddev,
			  double &g_mean, double &g_stddev,
			  double &b_mean, double &b_stddev)
{
   // Process RGB images
   R.Statistics(r_mean, r_stddev);
   G.Statistics(g_mean, g_stddev);
   B.Statistics(b_mean, b_stddev);
}

//============================================================
void im_color::Statistics(double &r_mean, double &r_stddev, double &r_skew,
			  double &g_mean, double &g_stddev, double &g_skew,
			  double &b_mean, double &b_stddev, double &b_skew)
{
   // Process RGB images
   R.Statistics(r_mean, r_stddev, r_skew);
   G.Statistics(g_mean, g_stddev, g_skew);
   B.Statistics(b_mean, b_stddev, b_skew);
}

//============================================================
void im_color::Histogram(int r_histo[], int r_min, int r_max,
			 int g_histo[], int g_min, int g_max,
			 int b_histo[], int b_min, int b_max)
{
   // Process RGB images
   R.Histogram(r_histo, r_min, r_max);
   G.Histogram(g_histo, g_min, g_max);
   B.Histogram(b_histo, b_min, b_max);
}

//============================================================
void im_color::Histogram(int r_histo[], int r_Histo[], int r_min, int r_max,
			 int g_histo[], int g_Histo[], int g_min, int g_max,
			 int b_histo[], int b_Histo[], int b_min, int b_max)
{
   // Process RGB images
   R.Histogram(r_histo, r_Histo, r_min, r_max);
   G.Histogram(g_histo, g_Histo, g_min, g_max);
   B.Histogram(b_histo, b_Histo, b_min, b_max);
}

//============================================================
float im_color::Contrast()
{
   // Process RGB images
   return (R.Contrast() + G.Contrast() + B.Contrast()) / 3;
}

//============================================================
void im_color::Gradient()
{
   // Process RGB images
   R.Gradient();
   G.Gradient();
   B.Gradient();
}

//============================================================
void im_color::GradientEdges(float threshold)
{
   // Process RGB images
   R.GradientEdges(threshold);
   G.GradientEdges(threshold);
   B.GradientEdges(threshold);
}

//============================================================
void im_color::Laplacian()
{
   // Process RGB images
   R.Laplacian();
   G.Laplacian();
   B.Laplacian();
}

//============================================================
void im_color::LaplacianEdges(float threshold)
{
   // Process RGB images
   R.LaplacianEdges(threshold);
   G.LaplacianEdges(threshold);
   B.LaplacianEdges(threshold);
}

//============================================================
void im_color::Canny()
{
   // Process RGB images
   R.Canny();
   G.Canny();
   B.Canny();
}

//============================================================
void im_color::CannyEdges(float threshold)
{
   // Process RGB images
   R.CannyEdges(threshold);
   G.CannyEdges(threshold);
   B.CannyEdges(threshold);
}

//============================================================
void im_color::ZeroCrossings()
{
   // Process RGB images
   R.ZeroCrossings();
   G.ZeroCrossings();
   B.ZeroCrossings();
}

//============================================================
void im_color::ZeroCrossings(float threshold, im_color & gradient)
{
   // Process RGB images
   R.ZeroCrossings(threshold, gradient.R);
   G.ZeroCrossings(threshold, gradient.G);
   B.ZeroCrossings(threshold, gradient.B);
}

//============================================================
void im_color::Curvature()
{
   // Process RGB images
   R.Curvature();
   G.Curvature();
   B.Curvature();
}

//============================================================
void im_color::Maxima(int radius)
{
   // Process RGB images
   R.Maxima(radius);
   G.Maxima(radius);
   B.Maxima(radius);
}

//============================================================
void im_color::Minima(int radius)
{
   // Process RGB images
   R.Minima(radius);
   G.Minima(radius);
   B.Minima(radius);
}

//============================================================
void im_color::Extrema(int radius)
{
   // Process RGB images
   R.Extrema(radius);
   G.Extrema(radius);
   B.Extrema(radius);
}

//============================================================
void im_color::Corner()
{
   // Process RGB images
   R.Corner();
   G.Corner();
   B.Corner();
}

//============================================================
void im_color::Watershed(float sigma, im_short & region)
{
   // Process RGB images
   R.Watershed(sigma, region);
   G.Watershed(sigma, region);
   B.Watershed(sigma, region);
}

//============================================================
void im_color::NoiseUniform(int range)
{
   // Process RGB images
   R.NoiseUniform(range);
   G.NoiseUniform(range);
   B.NoiseUniform(range);
}

//============================================================
void im_color::NoiseGaussian(float stddev)
{
   // Process RGB images
   R.NoiseGaussian(stddev);
   G.NoiseGaussian(stddev);
   B.NoiseGaussian(stddev);
}

//============================================================
void im_color::NoiseImpulse(char type, float fraction)
{
   // Process RGB images
   R.NoiseImpulse(type, fraction);
   G.NoiseImpulse(type, fraction);
   B.NoiseImpulse(type, fraction);
}

//============================================================
void im_color::FreqNoise(int count, float range)
{
   // Process RGB images
   R.FreqNoise(count, range);
   G.FreqNoise(count, range);
   B.FreqNoise(count, range);
}

//============================================================
void im_color::Product(im_color & in2, float &product)
{
   // Process RGB images
   float Rprod, Gprod, Bprod;
   R.Product(in2.R, Rprod);
   G.Product(in2.G, Gprod);
   B.Product(in2.B, Bprod);
   product = (Rprod + Gprod + Bprod) / 3;
}

//============================================================
void im_color::Difference(im_color & in2, float &difference)
{
   // Process RGB images
   float Rdiff, Gdiff, Bdiff;
   R.Difference(in2.R, Rdiff);
   G.Difference(in2.G, Gdiff);
   B.Difference(in2.B, Bdiff);
   difference = (Rdiff + Gdiff + Bdiff) / 3;
}

//============================================================
void im_color::Difference(im_color & in2, float &difference, int search)
{
   // Process RGB images
   float Rdiff, Gdiff, Bdiff;
   R.Difference(in2.R, Rdiff, search);
   G.Difference(in2.G, Gdiff, search);
   B.Difference(in2.B, Bdiff, search);
   difference = (Rdiff + Gdiff + Bdiff) / 3;
}

//============================================================
void im_color::IdealLP(float freq)
{
   // Process RGB images
   R.IdealLP(freq);
   G.IdealLP(freq);
   B.IdealLP(freq);
}

//============================================================
void im_color::IdealHP(float freq)
{
   // Process RGB images
   R.IdealHP(freq);
   G.IdealHP(freq);
   B.IdealHP(freq);
}

//============================================================
void im_color::IdealBP(float freqL, float freqH)
{
   // Process RGB images
   R.IdealBP(freqL, freqH);
   G.IdealBP(freqL, freqH);
   B.IdealBP(freqL, freqH);
}

//============================================================
void im_color::IdealNotch(int u1, int v1, int u2, int v2)
{
   // Process RGB images
   R.IdealNotch(u1, v1, u2, v2);
   G.IdealNotch(u1, v1, u2, v2);
   B.IdealNotch(u1, v1, u2, v2);
}

//============================================================
void im_color::ButterworthLP(float freq, float power)
{
   // Process RGB images
   R.ButterworthLP(freq, power);
   G.ButterworthLP(freq, power);
   B.ButterworthLP(freq, power);
}

//============================================================
void im_color::ButterworthHP(float freq, float power, float weight)
{
   // Process RGB images
   R.ButterworthHP(freq, power, weight);
   G.ButterworthHP(freq, power, weight);
   B.ButterworthHP(freq, power, weight);
}

//============================================================
void im_color::ButterworthBP(float freqL, float freqH, float power)
{
   // Process RGB images
   R.ButterworthBP(freqL, freqH, power);
   G.ButterworthBP(freqL, freqH, power);
   B.ButterworthBP(freqL, freqH, power);
}

//============================================================
void im_color::ButterworthNotch(int cu, int cv, float freq, float power)
{
   // Process RGB images
   R.ButterworthNotch(cu, cv, freq, power);
   G.ButterworthNotch(cu, cv, freq, power);
   B.ButterworthNotch(cu, cv, freq, power);
}

//============================================================
void im_color::GaussLP(float freq)
{
   // Process RGB images
   R.GaussLP(freq);
   G.GaussLP(freq);
   B.GaussLP(freq);
}

//============================================================
void im_color::GaussHP(float freq, float weight)
{
   // Process RGB images
   R.GaussHP(freq, weight);
   G.GaussHP(freq, weight);
   B.GaussHP(freq, weight);
}

//============================================================
void im_color::GaussBP(float center, float freq)
{
   // Process RGB images
   R.GaussBP(center, freq);
   G.GaussBP(center, freq);
   B.GaussBP(center, freq);
}

//============================================================
void im_color::GaussNotch(int cu, int cv, float freq)
{
   // Process RGB images
   R.GaussNotch(cu, cv, freq);
   G.GaussNotch(cu, cv, freq);
   B.GaussNotch(cu, cv, freq);
}

//============================================================
void im_color::Derivative(int partialX, int partialY)
{
   // Process RGB images
   R.Derivative(partialX, partialY);
   G.Derivative(partialX, partialY);
   B.Derivative(partialX, partialY);
}

//============================================================
void im_color::Laplacian2()
{
   // Process RGB images
   R.Laplacian2();
   G.Laplacian2();
   B.Laplacian2();
}

//============================================================
void im_color::Homomorphic(float freq, float weight)
{
   // Process RGB images
   R.Homomorphic(freq, weight);
   G.Homomorphic(freq, weight);
   B.Homomorphic(freq, weight);
}

//============================================================
void im_color::SincLP(float width)
{
   // Process RGB images
   R.SincLP(width);
   G.SincLP(width);
   B.SincLP(width);
}

//============================================================
void im_color::Filter(char *name)
{
   // Process RGB images
   R.Filter(name);
   G.Filter(name);
   B.Filter(name);
}

//============================================================
void im_color::InverseFilter(char *name, float min)
{
   // Process RGB images
   R.InverseFilter(name, min);
   G.InverseFilter(name, min);
   B.InverseFilter(name, min);
}

//============================================================
void im_color::Midpoint(float radius)
{
   // Process RGB images
   R.Midpoint(radius);
   G.Midpoint(radius);
   B.Midpoint(radius);
}

//============================================================
void im_color::Erode(float radius)
{
   // Process RGB images
   R.Erode(radius);
   G.Erode(radius);
   B.Erode(radius);
}

//============================================================
void im_color::Dilate(float radius)
{
   // Process RGB images
   R.Dilate(radius);
   G.Dilate(radius);
   B.Dilate(radius);
}

//============================================================
void im_color::Open(float radius)
{
   // Process RGB images
   R.Open(radius);
   G.Open(radius);
   B.Open(radius);
}

//============================================================
void im_color::Close(float radius)
{
   // Process RGB images
   R.Close(radius);
   G.Close(radius);
   B.Close(radius);
}

//============================================================
void im_color::Morphology(char *command, float radius)
{
   // Process RGB images
   R.Morphology(command, radius);
   G.Morphology(command, radius);
   B.Morphology(command, radius);
}

//============================================================
void im_color::DrawPoint(int x, int y, int size, short r, short g, short b)
{
   // Process RGB images
   R.DrawPoint(x,y, size, r);
   G.DrawPoint(x,y, size, g);
   B.DrawPoint(x,y, size, b);
}

//============================================================
void im_color::DrawLine(int x1, int y1, int x2, int y2, int size, 
   short r, short g, short b)
{
   // Process RGB images
   R.DrawLine(x1,y1, x2,y2, size, r);
   G.DrawLine(x1,y1, x2,y2, size, g);
   B.DrawLine(x1,y1, x2,y2, size, b);
}

//============================================================
void im_color::DrawLine(float Mval, float Bval, int size, 
   short r, short g, short b)
{
   // Process RGB images
   R.DrawLine(Mval, Bval, size, r);
   G.DrawLine(Mval, Bval, size, g);
   B.DrawLine(Mval, Bval, size, b);
}

//============================================================
void im_color::RegionGrow(float threshold)
{
   // Create extrema image
   im_short extrema(R.Xdim, R.Ydim);
   for (int y = 0; y < R.Ydim; y++)
   for (int x = 0; x < R.Xdim; x++)
      extrema.Data2D[y][x] = R.Data2D[y][x] + G.Data2D[y][x] + B.Data2D[y][x];
   extrema.Extrema(2);

   // Create output image
   im_short out(R.Xdim, R.Ydim);

   // Segment image using region growing
   int color = 1;
   for (int y = 0; y < R.Ydim; y++)
   for (int x = 0; x < R.Xdim; x++)
      {
      // Perform region growing
      if ((extrema.Data2D[y][x] != 0) && (out.Data2D[y][x] == 0))
      {
         int size = 1;
         float Rtotal = R.Data2D[y][x];
         float Gtotal = G.Data2D[y][x];
         float Btotal = B.Data2D[y][x];
         RegionGrowStack(out, x, y, Rtotal, Gtotal, Btotal, size, threshold, color++);
         if (size < 50)
            out.BlobUnColor(x, y, --color);
      }
   }
   R.Copy(out);
   G.Copy(out);
   B.Copy(out);
}

//============================================================
void im_color::RegionGrow(int x, int y, float threshold)
{
   // Create output image
   im_short out(R.Xdim, R.Ydim);

   // Grow region from seed point
   int size = 1;
   float Rtotal = R.Data2D[y][x];
   float Gtotal = G.Data2D[y][x];
   float Btotal = B.Data2D[y][x];
   RegionGrowStack(out, x, y, Rtotal, Gtotal, Btotal, size, threshold, 255);
   R.Copy(out);
   G.Copy(out);
   B.Copy(out);
}

//============================================================
void im_color::RegionGrowRecursive(im_short &output, int x, int y, 
   float &Rtotal, float &Gtotal, float &Btotal, int &size, 
   float threshold, short color)
{
   // Check terminating conditions
   if ((x >= 0) && (x < R.Xdim) && (y >= 0) && (y < R.Ydim) &&
      (output.Data2D[y][x] == 0) && 
      (fabs(Rtotal / size - R.Data2D[y][x]) +
       fabs(Gtotal / size - G.Data2D[y][x]) + 
       fabs(Btotal / size - B.Data2D[y][x]) < threshold * 3))
   {
      // Update output image
      output.Data2D[y][x] = color;
      Rtotal += R.Data2D[y][x];
      Gtotal += G.Data2D[y][x];
      Btotal += B.Data2D[y][x];
      size++;

      // Make recursive calls
      if ((y-1 >= 0) && (output.Data2D[y-1][x] == 0))
         RegionGrowRecursive(output, x, y - 1, 
            Rtotal, Gtotal, Btotal, size, threshold, color);
      if ((y+1 < R.Ydim) && (output.Data2D[y+1][x] == 0))
         RegionGrowRecursive(output, x, y + 1, 
            Rtotal, Gtotal, Btotal, size, threshold, color);
      if ((x-1 >= 0) && (output.Data2D[y][x-1] == 0))
         RegionGrowRecursive(output, x - 1, y, 
            Rtotal, Gtotal, Btotal, size, threshold, color);
      if ((x+1 < R.Xdim) && (output.Data2D[y][x+1] == 0))
         RegionGrowRecursive(output, x + 1, y, 
            Rtotal, Gtotal, Btotal, size, threshold, color);
   }
}

//============================================================
void im_color::RegionGrowStack(im_short &output, int x, int y, 
   float &Rtotal, float &Gtotal, float &Btotal, int &size, 
   float threshold, short color)
{
   // Push seed point on stack
   int *sx = new int[R.NumPixels];
   int *sy = new int[R.NumPixels];
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
      if ((x >= 0) && (x < R.Xdim) && (y >= 0) && (y < R.Ydim) &&
         (output.Data2D[y][x] == 0) && 
         (fabs(Rtotal / size - R.Data2D[y][x]) +
          fabs(Gtotal / size - G.Data2D[y][x]) + 
          fabs(Btotal / size - B.Data2D[y][x]) < threshold * 3))
      {
	 // Add point to region
	 output.Data2D[y][x] = color;
         Rtotal += R.Data2D[y][x];
         Gtotal += G.Data2D[y][x];
         Btotal += B.Data2D[y][x];
	 size++;

	 // Add neighbors to stack
         if ((x+1 < R.Xdim) && (output.Data2D[y][x+1] == 0) && (top < R.NumPixels))
	 {
	    top++;
	    sx[top] = x + 1;
	    sy[top] = y;
	 }
         if ((x-1 >= 0) && (output.Data2D[y][x-1] == 0) && (top < R.NumPixels))
	 {
	    top++;
	    sx[top] = x - 1;
	    sy[top] = y;
	 }
         if ((y+1 < R.Ydim) && (output.Data2D[y+1][x] == 0) && (top < R.NumPixels))
	 {
	    top++;
	    sx[top] = x;
	    sy[top] = y + 1;
	 }
         if ((y-1 >= 0) && (output.Data2D[y-1][x] == 0) && (top < R.NumPixels))
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
void im_color::EqualizeY()
{
   // Convert to YUV
   RGBtoYUV();

   // Filter the Y image
   R.Equalize();

   // Convert to RGB
   YUVtoRGB();
}

//============================================================
void im_color::EqualizeY(int regions)
{
   // Convert to YUV
   RGBtoYUV();

   // Filter the Y image
   R.Equalize(regions);

   // Convert to RGB
   YUVtoRGB();
}

//============================================================
void im_color::WallisY(int radius, float gain)
{
   // Convert to YUV
   RGBtoYUV();

   // Filter the Y image
   R.Wallis(radius, gain);

   // Convert to RGB
   YUVtoRGB();
}

//============================================================
void im_color::HomomorphicY(float freq, float weight)
{
   // Convert to YUV
   RGBtoYUV();

   // Filter the Y image
   R.Homomorphic(freq, weight);

   // Convert to RGB
   YUVtoRGB();
}

//============================================================
void im_color::Whiten()
{
   // Calculate current min max values
   short MinR, MaxR, MinG, MaxG, MinB, MaxB;
   MinMax(MinR, MaxR, MinG, MaxG, MinB, MaxB);
   short MidR = (MinR + MaxR) / 2;
   short MidG = (MinG + MaxG) / 2;
   short MidB = (MinB + MaxB) / 2;

   // Calculate average white value
   float AveR = 0;
   float AveG = 0;
   float AveB = 0;
   int Count = 1;
   for (int i = 0; i < R.NumPixels; i++)
   if ((R.Data1D[i] > MidR) && (G.Data1D[i] > MidG) && (B.Data1D[i] > MidB))
   {
      AveR += R.Data1D[i];
      AveG += G.Data1D[i];
      AveB += B.Data1D[i];
      Count++;
   }
   AveR /= Count;
   AveG /= Count;      
   AveB /= Count;      
   printf("mean RGB = %3.0f,%3.0f,%3.0f\n", AveR, AveG, AveB);

   // Whiten image
   float Ave = (AveR + AveG + AveB) / 3;
   float ScaleR = Ave / AveR;
   float ScaleG = Ave / AveG;
   float ScaleB = Ave / AveB;
   for (int i = 0; i < R.NumPixels; i++)
   {
      R.Data1D[i] = (short) (R.Data1D[i] * ScaleR);
      G.Data1D[i] = (short) (G.Data1D[i] * ScaleG);
      B.Data1D[i] = (short) (B.Data1D[i] * ScaleB);
      if (R.Data1D[i] > MaxR)
	 R.Data1D[i] = MaxR;
      if (G.Data1D[i] > MaxG)
	 G.Data1D[i] = MaxG;
      if (B.Data1D[i] > MaxB)
	 B.Data1D[i] = MaxB;
   }
}

//============================================================
void im_color::RGBtoXYZ()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert RGB to XYZ 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 0.412 * R.Data1D[i] + 0.358 * G.Data1D[i] + 0.180 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + 0.213 * R.Data1D[i] + 0.715 * G.Data1D[i] + 0.072 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 0.019 * R.Data1D[i] + 0.119 * G.Data1D[i] + 0.950 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::XYZtoRGB()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert XYZ to RGB 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 3.240 * R.Data1D[i] - 1.537 * G.Data1D[i] - 0.499 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + -0.969 * R.Data1D[i] + 1.876 * G.Data1D[i] + 0.042 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 0.056 * R.Data1D[i] - 0.204 * G.Data1D[i] + 1.057 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::RGBtoYUV()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert RGB to YUV 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 0.299 * R.Data1D[i] + 0.587 * G.Data1D[i] + 0.114 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + -0.147 * R.Data1D[i] - 0.289 * G.Data1D[i] + 0.436 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 0.615 * R.Data1D[i] - 0.515 * G.Data1D[i] - 0.100 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::YUVtoRGB()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert YUV to RGB 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] + 0.000 * G.Data1D[i] + 1.140 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] - 0.395 * G.Data1D[i] - 0.580 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] + 2.032 * G.Data1D[i] + 0.000 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::RGBtoYIQ()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert RGB to YIQ 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 0.299 * R.Data1D[i] + 0.587 * G.Data1D[i] + 0.114 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + 0.596 * R.Data1D[i] - 0.274 * G.Data1D[i] - 0.321 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 0.211 * R.Data1D[i] - 0.523 * G.Data1D[i] + 0.311 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::YIQtoRGB()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert YIQ to RGB 
   for (int i = 0; i < R.NumPixels; i++)
   {
      out.R.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] + 0.956 * G.Data1D[i] + 0.621 * B.Data1D[i]);
      out.G.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] - 0.272 * G.Data1D[i] - 0.647 * B.Data1D[i]);
      out.B.Data1D[i] = (short) 
         (0.5 + 1.000 * R.Data1D[i] - 1.107 * G.Data1D[i] + 1.705 * B.Data1D[i]);
   }
   Swap(out);
}

//============================================================
void im_color::RGBtoHSI()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert RGB to HSI 
   for (int n = 0; n < R.NumPixels; n++)
   {
      // Get RGB values in [0..1] range
      float r = R.Data1D[n] / 255.0;
      float g = G.Data1D[n] / 255.0;
      float b = B.Data1D[n] / 255.0;
      float min_rgb = r; 
      if (min_rgb > g) min_rgb = g;
      if (min_rgb > b) min_rgb = b;

      // Calculate HSI in [0..2pi], [0..1], [0..1] range
      float small = 0.00001;
      float num = 0.5 * (r-g + r-b);
      float den = sqrtf( (r-g)*(r-g) + (r-b)*(g-b) ) + small;
      float h = (b <= g) ? acos(num/den) : 2*M_PI - acos(num/den);
      float s = 1 - 3 * min_rgb / (r+g+b);
      float i = (r+g+b) / 3;

      // Save HSI in [0..360], [0..255], [0.255] range
      out.R.Data1D[n] = (short)(h * 180 / M_PI);
      out.G.Data1D[n] = (short)(s * 255);
      out.B.Data1D[n] = (short)(i * 255);
   }
   Swap(out);
}

//============================================================
void im_color::HSItoRGB()
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Angle constants
   float degree60 = M_PI/3;
   float degree120 = 2 * degree60;
   float degree240 = 2 * degree120;

   // Convert HSI to RGB 
   for (int n = 0; n < R.NumPixels; n++)
   {
      // Calculate HSI in [0..2pi], [0..1], [0..1] range
      float h = R.Data1D[n] * M_PI / 180.0;
      float s = G.Data1D[n] / 255.0;
      float i = B.Data1D[n] / 255.0;

      // Calculate RGB in [0..1] range
      float r=0, g=0, b=0;
      if (h < degree120)
      {
         b = i * (1 - s);
         r = i * (1 + s * cos(h) / cos(degree60 - h));
         g = i * 3 - b - r;
      }
      else if ((h >= degree120) && (h < degree240))
      {
         h = h - degree120;
         r = i * (1 - s);
         g = i * (1 + s * cos(h) / cos(degree60 - h));
         b = i * 3 - r - g;
      }
      else if (h >= degree240)
      {
         h = h - degree240;
         g = i * (1 - s);
         b = i * (1 + s * cos(h) / cos(degree60 - h));
         r = i * 3 - g - b;
      }

      // Save RGB in [0..255] range
      out.R.Data1D[n] = (short) (r * 255);
      out.G.Data1D[n] = (short) (g * 255);
      out.B.Data1D[n] = (short) (b * 255);
   }
   Swap(out);
}

//============================================================
void im_color::RGBtoCMYK(im_short &K)
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert RGB to CMYK
   for (int i = 0; i < R.NumPixels; i++)
   {
      short c = 255 - R.Data1D[i];
      short m = 255 - G.Data1D[i];
      short y = 255 - B.Data1D[i];
      short k = c; if (k>m) k=m; if (k>y) k=y;
      out.R.Data1D[i] = c - k;
      out.G.Data1D[i] = m - k;
      out.B.Data1D[i] = y - k;
      K.Data1D[i] = k;
   }
   Swap(out);
}

//============================================================
void im_color::CMYKtoRGB(im_short &K)
{
   // Create output image
   im_color out(R.Xdim, R.Ydim);

   // Convert CMYK to RGB 
   for (int i = 0; i < R.NumPixels; i++)
   {
      short c = R.Data1D[i];
      short m = G.Data1D[i];
      short y = B.Data1D[i];
      short k = K.Data1D[i];
      out.R.Data1D[i] = 255 - c - k;
      out.G.Data1D[i] = 255 - m - k;
      out.B.Data1D[i] = 255 - y - k;
   }
   Swap(out);
}

//============================================================
void im_color::GetLuminance(im_short &im)
{
   // Allocate output image
   im.Alloc(R.Xdim, R.Ydim);

   // Calculate luminance
   for (int i = 0; i < R.NumPixels; i++)
   {
      im.Data1D[i] = (short) (0.5 
         + 0.299 * R.Data1D[i] 
         + 0.587 * G.Data1D[i] 
         + 0.114 * B.Data1D[i]);
   }
}

