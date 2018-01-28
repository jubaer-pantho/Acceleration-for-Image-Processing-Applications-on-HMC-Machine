//============================================================
//  File:       im_color.h
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#ifndef COLOR
#define COLOR 202

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "im_short.h"
#include "im_float.h"

class im_color
{
 public:
   // Image header and data
   im_short R;
   im_short G;
   im_short B;

   // Constructor functions
   im_color();
   im_color(int xdim);
   im_color(int xdim, int ydim);
   im_color(const im_color & copy);
   ~im_color();

   // Utility functions
   void Clear();
   void Free();
   void Alloc(int xdim, int ydim);
   void Swap(im_color & im);
   void Copy(const im_color & im);

   // Input output functions
   bool ReadHeader(FILE *fd, char* pix_type, int &xdim, int &ydim, int &max);
   bool WriteAscii(char *filename);
   bool ReadAscii(char *filename);
   bool WriteBinary(char *filename);
   bool ReadBinary(char *filename);
   bool WriteJpg(char *filename);
   bool ReadJpg(char *filename);

   // Arithmetic operations
   void Add(im_color & in2);
   void Subtract(im_color & in2);
   void Multiply(im_color & in2);
   void Divide(im_color & in2);

   // Point operations
   void Threshold(float value, bool invert = false);
   void ThresholdAutomatic(bool invert = false);
   void Window(int low, int high);
   void Trim(float percentage);
   void Greymap(int low, int high);
   void Quantize(int levels, int iterations);
   void Invert();

   // Enhancement operations
   void Equalize();
   void Equalize(int regions);
   void UnsharpMasking(float sigma, float weight);
   void UnsharpMasking(int iterations, float weight);
   void Power(float gamma);
   void Cubic(float param);
   void Stretch(int r1, int s1, int r2, int s2);
   void Wallis(int radius, float gain);

   // Smoothing operations
   void Average(int xdim, int ydim);
   void Binomial();
   void Binomial(int iterations);
   void Convolve(int xdim, int ydim, float weight[]);
   void Median(int xdim, int ydim);
   void Gaussian(float sigma);
   void AdaptiveGaussian(float sigma1, float sigma2);
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
   void MinMax(short &r_min, short &r_max,
	       short &g_min, short &g_max, short &b_min, short &b_max);
   void Statistics(double &r_mean, double &r_stddev,
		   double &g_mean, double &g_stddev,
		   double &b_mean, double &b_stddev);
   void Statistics(double &r_mean, double &r_stddev, double &r_skew,
		   double &g_mean, double &g_stddev, double &g_skew,
		   double &b_mean, double &b_stddev, double &b_skew);
   void Histogram(int r_histo[], int r_min, int r_max,
		  int g_histo[], int g_min, int g_max,
		  int b_histo[], int b_min, int b_max);
   void Histogram(int r_histo[], int r_Histo[], int r_min, int r_max,
		  int g_histo[], int g_Histo[], int g_min, int g_max,
		  int b_histo[], int b_Histo[], int b_min, int b_max);
   float Contrast();

   // Edge detection 
   void Gradient();
   void GradientEdges(float threshold);
   void Laplacian();
   void LaplacianEdges(float threshold);
   void Canny();
   void CannyEdges(float threshold);
   void ZeroCrossings();
   void ZeroCrossings(float threshold, im_color & gradient);

   // Image features
   void Curvature();
   void Maxima(int radius);
   void Minima(int radius);
   void Extrema(int radius);
   void Corner();
   void Watershed(float sigma, im_short & region);

   // Noise operations
   void NoiseUniform(int range);
   void NoiseGaussian(float stddev);
   void NoiseImpulse(char type, float fraction);
   void FreqNoise(int count, float range);

   // Comparison operations
   void Product(im_color & in2, float &product);
   void Difference(im_color & in2, float &difference);
   void Difference(im_color & in2, float &difference, int search);

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

   // Other Fouier domain operations
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
   void DrawPoint(int x, int y, int size, short r, short g, short b);
   void DrawLine(int x1, int y1, int x2, int y2, int size, 
      short r, short g, short b);
   void DrawLine(float M, float B, int size, short r, short g, short b);

   // Region growing
   void RegionGrow(float threshold);
   void RegionGrow(int x, int y, float threshold);
   void RegionGrowRecursive(im_short &output, int x, int y, 
      float &Rtotal, float &Gtotal, float &Btotal, int &count, 
      float threshold, short color);
   void RegionGrowStack(im_short &output, int x, int y, 
      float &Rtotal, float &Gtotal, float &Btotal, int &count, 
      float threshold, short color);

   // Luminance operations ------------------------
   void EqualizeY();
   void EqualizeY(int regions);
   void WallisY(int radius, float gain);
   void HomomorphicY(float freq, float weight);
   void Whiten();

   // Color space conversion  ------------------------
   void RGBtoXYZ();
   void XYZtoRGB();
   void RGBtoYUV();
   void YUVtoRGB();
   void RGBtoYIQ();
   void YIQtoRGB();
   void RGBtoHSI();
   void HSItoRGB();
   void RGBtoCMYK(im_short &K);
   void CMYKtoRGB(im_short &K);
   void GetLuminance(im_short &im);
};

#endif
