//============================================================
//  File:       im_short.h
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#ifndef SHORT
#define SHORT 101

#ifdef IM_TYPE
#undef IM_TYPE
#undef PIXEL
#endif

#define IM_TYPE im_short
#define PIXEL short
#include "im_pixel.h"

#endif
