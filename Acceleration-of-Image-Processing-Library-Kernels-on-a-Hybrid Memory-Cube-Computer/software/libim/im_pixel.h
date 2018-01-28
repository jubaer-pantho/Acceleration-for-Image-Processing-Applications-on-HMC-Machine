//============================================================
//  File:       im_pixel.h
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <time.h>
#include <string.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#define STRLEN 256

class im_short;
class im_float;

class IM_TYPE
{
 public:
   // Image header and data
   int Xdim;
   int Ydim;
   int NumPixels;
   PIXEL *Data1D;
   PIXEL **Data2D;

   // Image sampling **
   PIXEL Sample(int x, int y, char bound = 'w');
   PIXEL Sample(float x, float y, char bound = 'w');

   // Constructor functions
   IM_TYPE();
   IM_TYPE(int xdim);
   IM_TYPE(int xdim, int ydim);
   IM_TYPE(const im_short & copy);
   IM_TYPE(const im_float & copy);
   ~IM_TYPE();

   // Utility functions
   void Clear();
   void Free();
   void Alloc(int xdim, int ydim);
   void Swap(IM_TYPE & im);
   void Copy(const im_short & im);
   void Copy(const im_float & im);

   // Input output functions
   bool ReadHeader(FILE *fd, char* pix_type, int &xdim, int &ydim, int &max);
   bool WriteAscii(char *filename);
   bool ReadAscii(char *filename);
   bool WriteBinary(char *filename);
   bool ReadBinary(char *filename);
   bool WriteJpg(char *filename);
   bool ReadJpg(char *filename);

   // Arithmetic operations
   void Add(IM_TYPE & in2);
   void Subtract(IM_TYPE & in2);
   void Multiply(IM_TYPE & in2);
   void Divide(IM_TYPE & in2);

   // Point operations
   void Threshold(float value, bool invert = false);
   void ThresholdAutomatic(bool invert = false);
   void Window(PIXEL low, PIXEL high);
   void Trim(float percentage);
   void Greymap(int low, int high);
   void Quantize(int levels, int iterations);
   void Invert();

   // Enhancement operations
   void Equalize();
   void Equalize(int regions);
   void UnsharpMasking(float sigma, float weight);
   void UnsharpMasking(int iterations, float weight, char bound = 'z');
   void Power(float gamma);
   void Cubic(float param);
   void Stretch(int r1, int s1, int r2, int s2);
   void Wallis(int radius, float A = 0.0, float B = 0.0);

   // Smoothing operations
   void Average(int xdim, int ydim);
   void Binomial(char bound = 'z');
   void Binomial(int iterations, char bound = 'z');
   void Convolve(int xdim, int ydim, float weight[]);
   void Median(int xdim, int ydim);
   void Gaussian(float sigma);
   void AdaptiveGaussian(float max_sigma, float max_gradient);
   void OutlierRemoval(int xdim, int ydim, float threshold);
   void kNN(int xdim, int ydim, int K);
   void AlphaMean(int xdim, int ydim, int Alpha);

   // Geometric operations
   void Translate(float dx, float dy, char bound = 'z');
   void Rotate(float angle, int cx, int cy, char bound = 'z');
   void Scale(float sx, float sy, int cx, int cy, char bound = 'z');
   void Shear(float sx, float sy, int cx, int cy, char bound = 'z');
   void Interpolate(int xdim, int ydim);
   void InterpolateNN(int xdim, int ydim);
   void MakeIcon(int size);
   void Extract(int x1, int x2, int y1, int y2);
   void FitRectangle(int &x1, int &x2, int &y1, int &y2, int search, char method);
   void FitExtract(int x1, int x2, int y1, int y2, int search, char method);

   // Information functions
   void PrintRange();
   void MinMax(PIXEL & min, PIXEL & max);
   void Statistics(double &mean, double &stddev);
   void Statistics(double &mean, double &stddev, double &skew);
   void Histogram(int histo[], int min, int max);
   void Histogram(int histo[], int Histo[], int min, int max);
   float Contrast();

   // Edge detection 
   void Gradient();
   void GradientEdges(float threshold);
   void Laplacian();
   void LaplacianEdges(float threshold);
   void Canny();
   void CannyEdges(float threshold);
   void ZeroCrossings();
   void ZeroCrossings(float threshold, IM_TYPE & gradient);

   // Image features
   void Curvature();
   void Maxima(int radius);
   void Minima(int radius);
   void Extrema(int radius);
   void Corner();
   void Watershed(float sigma, im_short & region);

   // Noise operations
   void NoiseUniform(float range);
   void NoiseGaussian(float stddev);
   void NoiseImpulse(char type, float fraction);
   void FreqNoise(int count, float range);

   // Comparison operations
   void Product(IM_TYPE & in2, float &product);
   void Difference(IM_TYPE & in2, float &difference);
   void Difference(IM_TYPE & in2, float &difference, int search);

   // Ideal filters
   void IdealLP(float freq);
   void IdealHP(float freq);
   void IdealBP(float freqL, float freqH);
   void IdealNotch(int u1, int v1, int u2, int v2);

   // Butterworth filters
   void ButterworthLP(float freq, float power);
   void ButterworthHP(float freq, float power, float weight);
   void ButterworthBP(float freqL, float freqH, float power);
   void ButterworthNotch(int cu, int cv, float freq, float power);

   // Gaussian filters
   void GaussLP(float freq);
   void GaussHP(float freq, float weight);
   void GaussBP(float center, float freq);
   void GaussNotch(int cu, int cv, float freq);

   // Other Fourier domain operations
   void Derivative(int partialX, int partialY);
   void Laplacian2();
   void Homomorphic(float freq, float weight);
   void SincLP(float width);
   void Filter(char *name);
   void InverseFilter(char *name, float min);

   // Mathematical morphology operations
   void Midpoint(float radius);
   void Erode(float radius);
   void Dilate(float radius);
   void Open(float radius);
   void Close(float radius);
   void Morphology(char *command, float radius);

   // Draw operations
   void DrawPoint(int x, int y, int size, PIXEL value);
   void DrawLine(int x1, int y1, int x2, int y2, int size, PIXEL value);
   void DrawLine(float M, float B, int size, PIXEL value);

   // Region growing
   void RegionGrow(float threshold);
   void RegionGrow(int x, int y, float threshold);
   void RegionGrowRecursive(IM_TYPE &output, int x, int y, 
      float &total, int &count, float threshold, PIXEL color);
   void RegionGrowStack(IM_TYPE &output, int x, int y, 
      float &total, int &count, float threshold, PIXEL color);

   // Advanced operations -------------------
   void BlobColor();
   void BlobColor(int min_size);
   void BlobColor(int x, int y, int color, int & blob_size);
   void BlobUnColor(int x, int y, int color);
   void RegionBoundary(int color);
   void GetFeatures(int feature[], int num_rows, int num_cols);
   void CheckNeighbor(IM_TYPE & x_pos, IM_TYPE & y_pos, 
      int x, int y, int dx, int dy);
   void Distance();
};
