//============================================================
//  File:       im_float_3d.h
//  Author:     John Gauch
//  Date:       Fall 2015
//============================================================

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <time.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#define STRLEN 256

class im_float_3d
{
 public:
   // Image header and data
   int Xdim;
   int Ydim;
   int Zdim;
   float *Data1D;
   float **Data2D;
   float ***Data3D;

   // Constructor functions
   im_float_3d();
   im_float_3d(int xdim, int ydim, int zdim);
   im_float_3d(const im_float_3d & copy);
   ~im_float_3d();

   // Utility functions
   void Clear();
   void Free();
   void Alloc(int xdim, int ydim, int zdim);
   void Swap(im_float_3d & im);
   void Copy(const im_float_3d & im);
};
