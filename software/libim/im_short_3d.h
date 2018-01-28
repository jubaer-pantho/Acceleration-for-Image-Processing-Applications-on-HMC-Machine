//============================================================
//  File:       im_short_3d.h
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

class im_short_3d
{
 public:
   // Image header and data
   int Xdim;
   int Ydim;
   int Zdim;
   short *Data1D;
   short **Data2D;
   short ***Data3D;

   // Constructor functions
   im_short_3d();
   im_short_3d(int xdim, int ydim, int zdim);
   im_short_3d(const im_short_3d & copy);
   ~im_short_3d();

   // Utility functions
   void Clear();
   void Free();
   void Alloc(int xdim, int ydim, int zdim);
   void Swap(im_short_3d & im);
   void Copy(const im_short_3d & im);
};
