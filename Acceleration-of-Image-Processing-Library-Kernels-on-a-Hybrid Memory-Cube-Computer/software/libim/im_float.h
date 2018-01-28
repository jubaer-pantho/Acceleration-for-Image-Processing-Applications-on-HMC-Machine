//============================================================
//  File:       im_float.h
//  Author:     John Gauch
//  Date:       Spring 2009 - Fall 2016
//============================================================

#ifndef FLOAT
#define FLOAT 303

#ifdef IM_TYPE
#undef IM_TYPE
#undef PIXEL
#endif

#define IM_TYPE im_float
#define PIXEL float
#include "im_pixel.h"

#endif
