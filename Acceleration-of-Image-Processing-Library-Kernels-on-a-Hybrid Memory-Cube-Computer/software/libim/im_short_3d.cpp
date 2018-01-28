//============================================================
//  File:       im_short_3d.cpp
//  Author:     John Gauch
//  Date:       Fall 2015
//============================================================

#include "im_short_3d.h"

//============================================================
im_short_3d::im_short_3d()
{
   // Allocate image
   Clear();
}

//============================================================
im_short_3d::im_short_3d(int xdim, int ydim, int zdim)
{
   // Allocate image
   Clear();
   Alloc(xdim, ydim, zdim);
}

//============================================================
im_short_3d::im_short_3d(const im_short_3d & copy)
{
   // Allocate image
   Clear();
   Copy(copy);
}

//============================================================
im_short_3d::~im_short_3d()
{
   // Free image
   Free();
}

//============================================================
void im_short_3d::Clear()
{
   // Clear image
   Xdim = 0;
   Ydim = 0;
   Zdim = 0;
   Data1D = NULL;
   Data2D = NULL;
   Data3D = NULL;
}

//============================================================
void im_short_3d::Free()
{
   // Free memory
   if (Data1D != NULL)
      free((void *) Data1D);
   if (Data2D != NULL)
      free((void *) Data2D);
   if (Data3D != NULL)
      free((void *) Data3D);
   Clear();
}

//============================================================
void im_short_3d::Alloc(int xdim, int ydim, int zdim)
{
   // Free memory
   Free();

   // Parameter checking
   if (xdim < 1)
      xdim = 1;
   if (ydim < 1)
      ydim = 1;
   if (zdim < 1)
      zdim = 1;

   // Save image size
   Xdim = xdim;
   Ydim = ydim;
   Zdim = zdim;

   // Allocate memory
   Data1D = (short *) calloc(Xdim*Ydim*Zdim, sizeof(short));
   Data2D = (short **) calloc(Ydim*Zdim, sizeof(short *));
   Data3D = (short ***) calloc(Zdim, sizeof(short *));

   // Initialize pointers
   for (int y = 0; y < Ydim*Zdim; y++)
      Data2D[y] = &(Data1D[y * Xdim]);
   for (int z = 0; z < Zdim; z++)
      Data3D[z] = &(Data2D[z * Ydim]);
}

//============================================================
void im_short_3d::Swap(im_short_3d & copy)
{
   // Swap header data
   int temp = copy.Xdim;
   copy.Xdim = Xdim;
   Xdim = temp;

   temp = copy.Ydim;
   copy.Ydim = Ydim;
   Ydim = temp;

   temp = copy.Zdim;
   copy.Zdim = Zdim;
   Zdim = temp;

   // Swap image data
   short *ptr1 = copy.Data1D;
   copy.Data1D = Data1D;
   Data1D = ptr1;

   short **ptr2 = copy.Data2D;
   copy.Data2D = Data2D;
   Data2D = ptr2;
}

//============================================================
void im_short_3d::Copy(const im_short_3d & copy)
{
   // Copy image data
   Alloc(copy.Xdim, copy.Ydim, copy.Zdim);
   for (int index = 0; index < Xdim*Ydim*Zdim; index++)
      Data1D[index] = copy.Data1D[index];
}
