//============================================================
//  File:       im_complex.cpp
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#include "im_complex.h"

//============================================================
im_complex::im_complex()
{
   // Allocate image
   Clear();
}

//============================================================
im_complex::im_complex(int xdim)
{
   // Allocate image
   Clear();
   Alloc(xdim, 1);
}

//============================================================
im_complex::im_complex(int xdim, int ydim)
{
   // Allocate image
   Clear();
   Alloc(xdim, ydim);
}

//============================================================
im_complex::im_complex(const im_complex & copy)
{
   // Allocate image
   Clear();
   Copy(copy);
}

//============================================================
im_complex::im_complex(const im_float & copy)
{
   // Allocate image
   Clear();
   Re.Alloc(copy.Xdim, copy.Ydim);
   Im.Alloc(copy.Xdim, copy.Ydim);
   for (int i = 0; i < copy.NumPixels; i++)
      Re.Data1D[i] = copy.Data1D[i];
}

//============================================================
im_complex::im_complex(const im_short & copy)
{
   // Allocate image
   Clear();
   Re.Alloc(copy.Xdim, copy.Ydim);
   Im.Alloc(copy.Xdim, copy.Ydim);
   for (int i = 0; i < copy.NumPixels; i++)
      Re.Data1D[i] = copy.Data1D[i];
}

//============================================================
im_complex::~im_complex()
{
   // Empty
}

//============================================================
void im_complex::Clear()
{
   // Clear image
   Re.Clear();
   Im.Clear();
}

//============================================================
void im_complex::Free()
{
   // Process Re and Im images
   Re.Free();
   Im.Free();
}

//============================================================
void im_complex::Alloc(int xdim, int ydim)
{
   // Process Re and Im images
   Re.Alloc(xdim, ydim);
   Im.Alloc(xdim, ydim);
}

//============================================================
void im_complex::Swap(im_complex & copy)
{
   // Process Re and Im images
   Re.Swap(copy.Re);
   Im.Swap(copy.Im);
}

//============================================================
void im_complex::Copy(const im_complex & copy)
{
   // Process Re and Im images
   Re.Copy(copy.Re);
   Im.Copy(copy.Im);
}

//============================================================
void im_complex::GetReal(im_float & im)
{
   im.Copy(Re);
}

//============================================================
void im_complex::GetReal(im_short & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
      im.Data1D[i] = (short) Re.Data1D[i];
}

//============================================================
void im_complex::GetImaginary(im_float & im)
{
   im.Copy(Im);
}

//============================================================
void im_complex::GetImaginary(im_short & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
      im.Data1D[i] = (short) Im.Data1D[i];
}

//============================================================
void im_complex::GetAmplitude(im_float & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float R = Re.Data1D[i];
      float I = Im.Data1D[i];
      float Amp = sqrtf(R * R + I * I);
      im.Data1D[i] = (float) log(1+100*Amp);
   }
   im.Data1D[0] = 0;
}

//============================================================
void im_complex::GetAmplitude(im_short & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float R = Re.Data1D[i];
      float I = Im.Data1D[i];
      float Amp = sqrtf(R * R + I * I);
      im.Data1D[i] = (short) log(1+100*Amp);
   }
   im.Data1D[0] = 0;
}

//============================================================
void im_complex::GetPhase(im_float & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float R = Re.Data1D[i];
      float I = Im.Data1D[i];
      im.Data1D[i] = (float) (100 * atan2f(I, R));
   }
}

//============================================================
void im_complex::GetPhase(im_short & im)
{
   im.Alloc(Re.Xdim, Re.Ydim);
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float R = Re.Data1D[i];
      float I = Im.Data1D[i];
      im.Data1D[i] = (short) (100 * atan2f(I, R));
   }
}

//============================================================
void im_complex::Add(im_complex & in2)
{
   for (int i = 0; i < Re.NumPixels; i++)
   {
      Re.Data1D[i] += in2.Re.Data1D[i];
      Im.Data1D[i] += in2.Im.Data1D[i];
   }
}

//============================================================
void im_complex::Subtract(im_complex & in2)
{
   for (int i = 0; i < Re.NumPixels; i++)
   {
      Re.Data1D[i] -= in2.Re.Data1D[i];
      Im.Data1D[i] -= in2.Im.Data1D[i];
   }
}

//============================================================
void im_complex::Multiply(im_complex & in2)
{
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float NewRe = Re.Data1D[i] * in2.Re.Data1D[i] 
                  - Im.Data1D[i] * in2.Im.Data1D[i];
      float NewIm = Im.Data1D[i] * in2.Re.Data1D[i] 
                  + Re.Data1D[i] * in2.Im.Data1D[i];
      Re.Data1D[i] = NewRe;
      Im.Data1D[i] = NewIm;
   }
}

//============================================================
void im_complex::Divide(im_complex & in2, float min)
{
   for (int i = 0; i < Re.NumPixels; i++)
   {
      float Amp = in2.Re.Data1D[i] * in2.Re.Data1D[i] +
	          in2.Im.Data1D[i] * in2.Im.Data1D[i];
      if (Amp < min) 
         Amp = min;
      float NewRe = Re.Data1D[i] * in2.Re.Data1D[i] 
                  + Im.Data1D[i] * in2.Im.Data1D[i];
      float NewIm = Im.Data1D[i] * in2.Re.Data1D[i] 
                  - Re.Data1D[i] * in2.Im.Data1D[i];
      Re.Data1D[i] = NewRe / Amp;
      Im.Data1D[i] = NewIm / Amp;
   }
}

//============================================================
void im_complex::SlowFT()
{
   // Calculate Slow 1D FT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   if ((ydim == 1) && (xdim > 1))
   {
      FT();
   }

   // Calculate Slow 2D FT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Copy input image
      im_complex image(xdim, ydim);
      Swap(image);
      for (int v = 0; v < ydim; v++)
	 for (int u = 0; u < xdim; u++)
	 {
	    Re.Data2D[v][u] = 0;
	    Im.Data2D[v][u] = 0;
	    double u_angle = u * 2 * M_PI / xdim;
	    double v_angle = v * 2 * M_PI / ydim;
	    for (int y = 0; y < ydim; y++)
	       for (int x = 0; x < xdim; x++)
	       {
		  // Positive angle for FT
		  double angle = x * u_angle + y * v_angle;
		  double cos_angle = cos(angle);
		  double sin_angle = sin(angle);
		  Re.Data2D[v][u] += image.Re.Data2D[y][x] * cos_angle
		     - image.Im.Data2D[y][x] * sin_angle;
		  Im.Data2D[v][u] += image.Re.Data2D[y][x] * sin_angle
		     + image.Im.Data2D[y][x] * cos_angle;
	       }
	    Re.Data2D[v][u] /= xdim * ydim;
	    Im.Data2D[v][u] /= xdim * ydim;
	 }
   }
}

//============================================================
void im_complex::SlowIFT()
{
   // Calculate Slow 1D IFT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   if ((ydim == 1) && (xdim > 1))
   {
      IFT();
   }

   // Calculate Slow 2D IFT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Copy input image
      im_complex image(xdim, ydim);
      Swap(image);
      for (int v = 0; v < ydim; v++)
	 for (int u = 0; u < xdim; u++)
	 {
	    Re.Data2D[v][u] = 0;
	    Im.Data2D[v][u] = 0;
	    double u_angle = u * 2 * M_PI / xdim;
	    double v_angle = v * 2 * M_PI / ydim;
	    for (int y = 0; y < ydim; y++)
	       for (int x = 0; x < xdim; x++)
	       {
		  // Negative angle for IFT
		  double angle = -(x * u_angle + y * v_angle);
		  double cos_angle = cos(angle);
		  double sin_angle = sin(angle);
		  Re.Data2D[v][u] += image.Re.Data2D[y][x] * cos_angle
		     - image.Im.Data2D[y][x] * sin_angle;
		  Im.Data2D[v][u] += image.Re.Data2D[y][x] * sin_angle
		     + image.Im.Data2D[y][x] * cos_angle;
	       }
	 }
   }
}

//============================================================
void im_complex::FT()
{
   // Calculate 1D FT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   if ((ydim == 1) && (xdim > 1))
   {
      // Copy input image
      im_complex image(xdim);
      Swap(image);
      for (int u = 0; u < xdim; u++)
      {
	 Re.Data1D[u] = 0;
	 Im.Data1D[u] = 0;
	 double u_angle = u * 2 * M_PI / xdim;
	 for (int x = 0; x < xdim; x++)
	 {
	    // Positive angle for FT
	    double angle = x * u_angle;
	    double cos_angle = cos(angle);
	    double sin_angle = sin(angle);
	    Re.Data1D[u] += image.Re.Data1D[x] * cos_angle
	       - image.Im.Data1D[x] * sin_angle;
	    Im.Data1D[u] += image.Re.Data1D[x] * sin_angle
	       + image.Im.Data1D[x] * cos_angle;
	 }
	 Re.Data1D[u] /= xdim;
	 Im.Data1D[u] /= xdim;
      }
   }

   // Calculate 2D FT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Perform 1D FT on each row
      im_complex row(xdim);
      for (int y = 0; y < ydim; y++)
      {
	 for (int x = 0; x < xdim; x++)
	 {
	    row.Re.Data1D[x] = Re.Data2D[y][x];
	    row.Im.Data1D[x] = Im.Data2D[y][x];
	 }
	 row.FT();
	 for (int x = 0; x < xdim; x++)
	 {
	    Re.Data2D[y][x] = row.Re.Data1D[x];
	    Im.Data2D[y][x] = row.Im.Data1D[x];
	 }
      }

      // Perform 1D FT on each column
      im_complex column(ydim);
      for (int x = 0; x < xdim; x++)
      {
	 for (int y = 0; y < ydim; y++)
	 {
	    column.Re.Data1D[y] = Re.Data2D[y][x];
	    column.Im.Data1D[y] = Im.Data2D[y][x];
	 }
	 column.FT();
	 for (int y = 0; y < ydim; y++)
	 {
	    Re.Data2D[y][x] = column.Re.Data1D[y];
	    Im.Data2D[y][x] = column.Im.Data1D[y];
	 }
      }
   }
}

//============================================================
void im_complex::IFT()
{
   // Calculate 1D IFT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   if ((ydim == 1) && (xdim > 1))
   {
      // Copy input image
      im_complex image(xdim);
      Swap(image);
      for (int u = 0; u < xdim; u++)
      {
	 Re.Data1D[u] = 0;
	 Im.Data1D[u] = 0;
	 double u_angle = u * 2 * M_PI / xdim;
	 for (int x = 0; x < xdim; x++)
	 {
	    // Negative angle for IFT
	    double angle = -x * u_angle;
	    double cos_angle = cos(angle);
	    double sin_angle = sin(angle);
	    Re.Data1D[u] += image.Re.Data1D[x] * cos_angle
	       - image.Im.Data1D[x] * sin_angle;
	    Im.Data1D[u] += image.Re.Data1D[x] * sin_angle
	       + image.Im.Data1D[x] * cos_angle;
	 }
      }
   }

   // Calculate 2D IFT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Perform 1D IFT on each column
      im_complex column(ydim);
      for (int x = 0; x < xdim; x++)
      {
	 for (int y = 0; y < ydim; y++)
	 {
	    column.Re.Data1D[y] = Re.Data2D[y][x];
	    column.Im.Data1D[y] = Im.Data2D[y][x];
	 }
	 column.IFT();
	 for (int y = 0; y < ydim; y++)
	 {
	    Re.Data2D[y][x] = column.Re.Data1D[y];
	    Im.Data2D[y][x] = column.Im.Data1D[y];
	 }
      }

      // Perform 1D IFT on each row
      im_complex row(xdim);
      for (int y = 0; y < ydim; y++)
      {
	 for (int x = 0; x < xdim; x++)
	 {
	    row.Re.Data1D[x] = Re.Data2D[y][x];
	    row.Im.Data1D[x] = Im.Data2D[y][x];
	 }
	 row.IFT();
	 for (int x = 0; x < xdim; x++)
	 {
	    Re.Data2D[y][x] = row.Re.Data1D[x];
	    Im.Data2D[y][x] = row.Im.Data1D[x];
	 }
      }
   }
}

//============================================================
void im_complex::FastFT()
{
   // Calculate Fast 1D FT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   int half_x = xdim / 2;
   if ((ydim == 1) && (xdim > 1) && (xdim % 2 == 0))
   {
      // Make even and odd images
      im_complex even(half_x);
      im_complex odd(half_x);
      for (int x = 0; x < half_x; x++)
      {
	 even.Re.Data1D[x] = Re.Data1D[x + x];
	 even.Im.Data1D[x] = Im.Data1D[x + x];
	 odd.Re.Data1D[x] = Re.Data1D[x + x + 1];
	 odd.Im.Data1D[x] = Im.Data1D[x + x + 1];
      }

      // Calculate even and odd FTs
      even.FastFT();
      odd.FastFT();

      // Combine even and odd FTs
      for (int x = 0; x < half_x; x++)
      {
	 double angle = (2 * M_PI * x) / xdim;
	 double cos_angle = cos(angle);
	 double sin_angle = sin(angle);
	 double odd_re = odd.Re.Data1D[x] * cos_angle
	    - odd.Im.Data1D[x] * sin_angle;
	 double odd_im = odd.Im.Data1D[x] * cos_angle
	    + odd.Re.Data1D[x] * sin_angle;
	 Re.Data1D[x] = (even.Re.Data1D[x] + odd_re) / 2;
	 Im.Data1D[x] = (even.Im.Data1D[x] + odd_im) / 2;
	 Re.Data1D[x + half_x] = (even.Re.Data1D[x] - odd_re) / 2;
	 Im.Data1D[x + half_x] = (even.Im.Data1D[x] - odd_im) / 2;
      }
   }

   // Calculate Slow 1D FT
   else if ((ydim == 1) && (xdim > 1) && (xdim % 2 == 1))
   {
      FT();
   }

   // Calculate Fast 2D FT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Perform 1D FT on each row
      im_complex row(xdim);
      for (int y = 0; y < ydim; y++)
      {
	 for (int x = 0; x < xdim; x++)
	 {
	    row.Re.Data1D[x] = Re.Data2D[y][x];
	    row.Im.Data1D[x] = Im.Data2D[y][x];
	 }
	 row.FastFT();
	 for (int x = 0; x < xdim; x++)
	 {
	    Re.Data2D[y][x] = row.Re.Data1D[x];
	    Im.Data2D[y][x] = row.Im.Data1D[x];
	 }
      }

      // Perform 1D FT on each column
      im_complex column(ydim);
      for (int x = 0; x < xdim; x++)
      {
	 for (int y = 0; y < ydim; y++)
	 {
	    column.Re.Data1D[y] = Re.Data2D[y][x];
	    column.Im.Data1D[y] = Im.Data2D[y][x];
	 }
	 column.FastFT();
	 for (int y = 0; y < ydim; y++)
	 {
	    Re.Data2D[y][x] = column.Re.Data1D[y];
	    Im.Data2D[y][x] = column.Im.Data1D[y];
	 }
      }
   }
}

//============================================================
void im_complex::FastIFT()
{
   // Calculate Fast 1D IFT
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   int half_x = xdim / 2;
   if ((ydim == 1) && (xdim > 1) && (xdim % 2 == 0))
   {
      // Make even and odd images
      im_complex even(half_x);
      im_complex odd(half_x);
      for (int x = 0; x < half_x; x++)
      {
	 even.Re.Data1D[x] = Re.Data1D[x + x];
	 even.Im.Data1D[x] = Im.Data1D[x + x];
	 odd.Re.Data1D[x] = Re.Data1D[x + x + 1];
	 odd.Im.Data1D[x] = Im.Data1D[x + x + 1];
      }

      // Calculate even and odd FTs
      even.FastIFT();
      odd.FastIFT();

      // Combine even and odd FTs
      for (int x = 0; x < half_x; x++)
      {
	 double angle = (-2 * M_PI * x) / xdim;
	 double cos_angle = cos(angle);
	 double sin_angle = sin(angle);
	 double odd_re = odd.Re.Data1D[x] * cos_angle
	    - odd.Im.Data1D[x] * sin_angle;
	 double odd_im = odd.Im.Data1D[x] * cos_angle
	    + odd.Re.Data1D[x] * sin_angle;
	 Re.Data1D[x] = (even.Re.Data1D[x] + odd_re);
	 Im.Data1D[x] = (even.Im.Data1D[x] + odd_im);
	 Re.Data1D[x + half_x] = (even.Re.Data1D[x] - odd_re);
	 Im.Data1D[x + half_x] = (even.Im.Data1D[x] - odd_im);
      }
   }

   // Calculate Slow 1D IFT
   else if ((ydim == 1) && (xdim > 1) && (xdim % 2 == 1))
   {
      IFT();
   }

   // Calculate Fast 2D IFT
   else if ((ydim > 1) && (xdim > 1))
   {
      // Perform 1D IFT on each column
      im_complex column(ydim);
      for (int x = 0; x < xdim; x++)
      {
	 for (int y = 0; y < ydim; y++)
	 {
	    column.Re.Data1D[y] = Re.Data2D[y][x];
	    column.Im.Data1D[y] = Im.Data2D[y][x];
	 }
	 column.FastIFT();
	 for (int y = 0; y < ydim; y++)
	 {
	    Re.Data2D[y][x] = column.Re.Data1D[y];
	    Im.Data2D[y][x] = column.Im.Data1D[y];
	 }
      }

      // Perform 1D IFT on each row
      im_complex row(xdim);
      for (int y = 0; y < ydim; y++)
      {
	 for (int x = 0; x < xdim; x++)
	 {
	    row.Re.Data1D[x] = Re.Data2D[y][x];
	    row.Im.Data1D[x] = Im.Data2D[y][x];
	 }
	 row.FastIFT();
	 for (int x = 0; x < xdim; x++)
	 {
	    Re.Data2D[y][x] = row.Re.Data1D[x];
	    Im.Data2D[y][x] = row.Im.Data1D[x];
	 }
      }
   }
}

//============================================================
void im_complex::IdealLP(float freq)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 if (dist > freq * freq)
	 {
	    Re.Data2D[v][u] = 0;
	    Im.Data2D[v][u] = 0;
	 }
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::IdealHP(float freq)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 if (dist < freq * freq)
	 {
	    Re.Data2D[v][u] = 0;
	    Im.Data2D[v][u] = 0;
	 }
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::IdealBP(float freqL, float freqH)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 if ((dist < freqL * freqL) || (dist > freqH * freqH))
	 {
	    Re.Data2D[v][u] = 0;
	    Im.Data2D[v][u] = 0;
	 }
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::IdealNotch(int u1, int v1, int u2, int v2)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int u=u1; u<=u2; u++)
   for (int v=v1; v<=v2; v++)
   if ((u >= 0) && (u < xdim) && (v >= 0) && (v < ydim))
   {
      // Apply filter
      Re.Data2D[v][u] = 0;
      Im.Data2D[v][u] = 0;
      Re.Data2D[ydim-v][xdim-u] = 0;
      Im.Data2D[ydim-v][xdim-u] = 0;
   }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::ButterworthLP(float freq, float power)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 float filter = 1 / (1 + pow(dist / (freq * freq), power));
	 Re.Data2D[v][u] *= filter;
	 Im.Data2D[v][u] *= filter;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::ButterworthHP(float freq, float power, float weight)
{
   // Parameter checking
   if (weight < 0)
      weight = 0;
   if (weight > 1)
      weight = 1;

   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 float filter = 1 / (1 + pow(dist / (freq * freq), power));
	 Re.Data2D[v][u] *= (1 - weight) * (1 - filter) + weight;
	 Im.Data2D[v][u] *= (1 - weight) * (1 - filter) + weight;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::ButterworthBP(float freqL, float freqH, float power)
{
   // Perform FFT
   FastFT();

   // Prepare to filter
   float center = (freqL + freqH) / 2;
   float width = freqH - freqL;
   float freq = width / 2;

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to center
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) sqrt((float) (dv * dv + du * du)) - center;

	 // Apply filter
	 float filter = 1 / (1 + pow((dist * dist) / (freq * freq), power));
	 Re.Data2D[v][u] *= filter;
	 Im.Data2D[v][u] *= filter;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::ButterworthNotch(int cu, int cv, float freq, float power)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
         float dist1 = (float) ((cv-dv) * (cv-dv) + (cu-du) * (cu-du));
         float dist2 = (float) ((-cv-dv) * (-cv-dv) + (-cu-du) * (-cu-du));

         // Apply filter
	 float filter1 = 1 / (1 + pow(dist1 / (freq * freq), power));
	 float filter2 = 1 / (1 + pow(dist2 / (freq * freq), power));
         Re.Data2D[v][u] *= (1 - filter1) * (1 - filter2);
         Im.Data2D[v][u] *= (1 - filter1) * (1 - filter2);
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::GaussLP(float freq)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 float filter = exp(dist / (-2 * freq * freq));
	 Re.Data2D[v][u] *= filter;
	 Im.Data2D[v][u] *= filter;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::GaussHP(float freq, float weight)
{
   // Parameter checking
   if (weight < 0)
      weight = 0;
   if (weight > 1)
      weight = 1;

   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) (dv * dv + du * du);

	 // Apply filter
	 float filter = exp(dist / (-2 * freq * freq));
	 Re.Data2D[v][u] *= (1 - weight) * (1 - filter) + weight;
	 Im.Data2D[v][u] *= (1 - weight) * (1 - filter) + weight;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::GaussBP(float center, float freq)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to center
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
	 float dist = (float) sqrt((float) (dv * dv + du * du)) - center;

	 // Apply filter
	 float filter = exp(dist / (-2 * freq * freq));
	 Re.Data2D[v][u] *= (1 - filter);
	 Im.Data2D[v][u] *= (1 - filter);
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::GaussNotch(int cu, int cv, float freq)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;
         float dist1 = (float) ((cv-dv) * (cv-dv) + (cu-du) * (cu-du));
         float dist2 = (float) ((-cv-dv) * (-cv-dv) + (-cu-du) * (-cu-du));

         // Apply filter
         float filter1 = exp(dist1 / (-2 * freq * freq));
         float filter2 = exp(dist2 / (-2 * freq * freq));
         Re.Data2D[v][u] *= (1 - filter1) * (1 - filter2);
         Im.Data2D[v][u] *= (1 - filter1) * (1 - filter2);
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::Derivative(int partialX, int partialY)
{
   // Parameter checking
   if (partialX < 0)
      partialX = 0;
   if (partialY < 0)
      partialY = 0;
   int i_count = (partialX + partialY) % 4;

   // Perform FFT
   FastFT();

   // Perform filtering
   int xdim = Re.Xdim;
   int ydim = Re.Ydim;
   float constU = (float) (2 * M_PI / xdim);
   float constV = (float) (2 * M_PI / ydim);
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int du = (u < xdim / 2) ? u : u - xdim;
	 int dv = (v < ydim / 2) ? v : v - ydim;

	 // Calculate filter
	 float filter = 1;
	 for (int x = 0; x < partialX; x++)
	    filter *= du * constU;
	 for (int y = 0; y < partialY; y++)
	    filter *= dv * constV;

	 // Handle i^0 case
	 if (i_count == 0)
	 {
	    Re.Data2D[v][u] *= filter;
	    Im.Data2D[v][u] *= filter;
	 }

	 // Handle i^1 case
	 else if (i_count == 1)
	 {
	    float newRe = -Im.Data2D[v][u] * filter;
	    float newIm = Re.Data2D[v][u] * filter;
	    Re.Data2D[v][u] = newRe;
	    Im.Data2D[v][u] = newIm;
	 }

	 // Handle i^2 case
	 else if (i_count == 2)
	 {
	    Re.Data2D[v][u] *= -filter;
	    Im.Data2D[v][u] *= -filter;
	 }

	 // Handle i^3 case
	 else if (i_count == 3)
	 {
	    float newRe = Im.Data2D[v][u] * filter;
	    float newIm = -Re.Data2D[v][u] * filter;
	    Re.Data2D[v][u] = newRe;
	    Im.Data2D[v][u] = newIm;
	 }
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::Laplacian2()
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   float constU = (float) (-4 * M_PI * M_PI / (xdim * xdim));
   float constV = (float) (-4 * M_PI * M_PI / (ydim * ydim));
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;

	 // Apply filter
	 float filter = constU * (du * du) + constV * (dv * dv);
	 Re.Data2D[v][u] *= filter;
	 Im.Data2D[v][u] *= filter;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::Homomorphic(float freq, float weight)
{
   // Calculate image range
   float min, max;
   Re.MinMax(min, max);

   // Take log of Re image
   for (int i = 0; i < Re.NumPixels; i++)
      Re.Data1D[i] = log(Re.Data1D[i] - min + 1);

   // Perform filtering
   GaussHP(freq, weight);

   // Take exp of Re image
   for (int i = 0; i < Re.NumPixels; i++)
      Re.Data1D[i] = exp(Re.Data1D[i]) + min - 1;

   // Reset image range
   Re.Greymap((int) min, (int) max);
}

//============================================================
void im_complex::SincLP(float width)
{
   // Perform FFT
   FastFT();

   // Perform filtering
   int ydim = Re.Ydim;
   int xdim = Re.Xdim;
   for (int v = 0; v < ydim; v++)
      for (int u = 0; u < xdim; u++)
      {
	 // Calculate distance to origin
	 int dv = (v < ydim / 2) ? v : v - ydim;
	 int du = (u < xdim / 2) ? u : u - xdim;

	 // Apply filter
	 float angle_v = M_PI * dv * width / ydim;
	 float angle_u = M_PI * du * width / xdim;
	 float filter_v = (dv == 0) ? 1 : sin(angle_v) / angle_v;
	 float filter_u = (du == 0) ? 1 : sin(angle_u) / angle_u;
	 Re.Data2D[v][u] *= filter_u * filter_v;
	 Im.Data2D[v][u] *= filter_u * filter_v;
      }

   // Perform inverse FFT
   FastIFT();
}

//============================================================
void im_complex::ReadFilter(char *name)
{
   // Read convolution mask
   im_float mask;
   mask.ReadAscii(name);

   // Parameter checking
   if ((Re.Xdim < mask.Xdim) || (Re.Ydim < mask.Ydim))
      Alloc(mask.Xdim, mask.Ydim);

   // Calculate scale factor
   float total = 0;
   for (int y = 0; y < mask.Ydim; y++)
      for (int x = 0; x < mask.Xdim; x++)
	 total += mask.Data2D[y][x];
   if (total == 0.0) total = 1.0;

   // Copy and scale data
   for (int y = 0; y < mask.Ydim; y++)
      for (int x = 0; x < mask.Xdim; x++)
      {
	 int yy = (y - mask.Ydim / 2 + Re.Ydim) % Re.Ydim;
	 int xx = (x - mask.Xdim / 2 + Re.Xdim) % Re.Xdim;
	 Re.Data2D[yy][xx] = mask.Data2D[y][x] / total;
      }
}

//============================================================
void im_complex::Filter(char *name)
{
   // Read convolution mask
   im_complex filter(Re.Xdim, Re.Ydim);
   filter.ReadFilter(name);

   // Create filter from convolution mask
   filter.FastFT();
   float scale = filter.Re.Xdim;
   for (int y=0; y<filter.Re.Ydim; y++)
   for (int x=0; x<filter.Re.Xdim; x++)
   {
      filter.Re.Data2D[y][x] *= scale;
      filter.Re.Data2D[y][x] *= scale;
   }

   // Perform filtering
   FastFT();
   Multiply(filter);
   FastIFT();
}

//============================================================
void im_complex::InverseFilter(char *name, float min)
{
   // Read convolution mask
   im_complex filter(Re.Xdim, Re.Ydim);
   filter.ReadFilter(name);

   // Create filter from convolution mask
   filter.FastFT();
   float scale = filter.Re.Xdim;
   for (int y=0; y<filter.Re.Ydim; y++)
   for (int x=0; x<filter.Re.Xdim; x++)
   {
      filter.Re.Data2D[y][x] *= scale;
      filter.Re.Data2D[y][x] *= scale;
   }

   // Perform filtering
   FastFT();
   Divide(filter, min);
   FastIFT();
}

//============================================================
void im_complex::FreqNoise(int count, float range)
{
   // Perform FFT
   FastFT();

   // Add noise to count random frequencies 
   srand(clock());
   for (int i=0; i<count; i++)
   {
      int u_max = Re.Xdim/4;
      int v_max = Re.Ydim/4;
      int u = 1 + rand() % u_max;
      int v = 1 + rand() % v_max;
      float re = rand() * range / RAND_MAX;
      float im = rand() * range / RAND_MAX;
      // printf("noise %d %d %f %f\n", u, v, re, im);
      Re.Data2D[v][u] += re;
      Im.Data2D[v][u] += im;
      Re.Data2D[Re.Ydim-v][Re.Xdim-u] += re;
      Im.Data2D[Re.Ydim-v][Re.Xdim-u] += im;
   }

   // Perform inverse FFT
   FastIFT();
}
