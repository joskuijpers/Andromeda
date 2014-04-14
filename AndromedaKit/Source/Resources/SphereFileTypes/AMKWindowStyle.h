/*
 * Copyright (c) 2014 Jos Kuijpers. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AMKFile.h"

typedef enum {
	AMKWindowStyleImageUpperLeft = 0,
	AMKWindowStyleImageTop = 1,
	AMKWindowStyleImageUpperRight = 2,
	AMKWindowStyleImageRight = 3,
	AMKWindowStyleImageLowerRight = 4,
	AMKWindowStyleImageBottom = 5,
	AMKWindowStyleImageLowerLeft = 6,
	AMKWindowStyleImageLeft = 7,
	AMKWindowStyleImageBackground = 8
} AMKWindowStyleImage;

typedef enum {
	AMKWindowStyleModeTiled,
	AMKWindowStyleModeStretched,
	AMKWindowStyleModeGradient,
	AMKWindowStyleModeTiledGradient,
	AMKWindowStyleModeStretchedGradient
} AMKWindowStyleMode;

typedef enum {
	AMKWindowStyleCornerUpperLeft = 0,
	AMKWindowStyleCornerUpperRight = 1,
	AMKWindowStyleCornerLowerLeft = 2,
	AMKWindowStyleCornerLowerRight = 3
} AMKWindowStyleCorner;

typedef enum {
	AMKWindowStyleEdgeLeft = 0,
	AMKWindowStyleEdgeTop = 1,
	AMKWindowStyleEdgeRight = 2,
	AMKWindowStyleEdgeBottom = 3
} AMKWindowStyleEdge;

@class AMKImage;

/**
 * @brief A window style. Also the representation of .rws files
 */
@interface AMKWindowStyle : AMKFile

/// Images in the window style. Will always contain 9 items.
@property (readonly) NSArray *images;

/// The background mode: used for drawing the background
@property (assign) AMKWindowStyleMode backgroundMode;

- (void)setOffset:(uint8_t)offset forEdge:(AMKWindowStyleEdge)edge;
- (uint8_t)getOffsetForEdge:(AMKWindowStyleEdge)edge;

- (void)setBackgroundColor:(NSColor *)color forCorner:(AMKWindowStyleCorner)corner;
- (NSColor *)getBackgroundColorForCorner:(AMKWindowStyleCorner)corner;

- (AMKImage *)getImage:(AMKWindowStyleImage)bitmap;
- (void)setImage:(AMKImage *)image atPosition:(AMKWindowStyleImage)bitmap;

@end
