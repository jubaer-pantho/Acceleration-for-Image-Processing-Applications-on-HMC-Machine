//============================================================
//  File:       im_complex.h
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#ifndef COMPLEX
#define COMPLEX 404

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "im_float.h"
#include "im_short.h"

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

class im_complex
{
 public:
   // Image header and data
   im_float Re;
   im_float Im;

   // Constructor functions
   im_complex();
   im_complex(int xdim);
   im_complex(int xdim, int ydim);
   im_complex(const im_complex & copy);
   im_complex(const im_float & copy);
   im_complex(const im_short & copy);
   ~im_complex();

   // Utility functions
   void Clear();
   void Free();
   void Alloc(int xdim, int ydim);
   void Swap(im_complex & im);
   void Copy(const im_complex & im);

   // Get functions **
   void GetReal(im_float & im);
   void GetReal(im_short & im);
   void GetImaginary(im_float & im);
   void GetImaginary(im_short & im);
   void GetAmplitude(im_float & im);
   void GetAmplitude(im_short & im);
   void GetPhase(im_float & im);
   void GetPhase(im_short & im);

   // Arithmetic operations
   void Add(im_complex & in2);
   void Subtract(im_complex & in2);
   void Multiply(im_complex & in2);
   void Divide(im_complex & in2, float min);

   // Fourier transform functions **
   void SlowFT();
   void SlowIFT();
   void FT();
   void IFT();
   void FastFT();
   void FastIFT();

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
   void ReadFilter(char *name);
   void Filter(char *name);
   void InverseFilter(char *name, float min);

   // Noise operations
   void FreqNoise(int count, float range);
};

#endif
