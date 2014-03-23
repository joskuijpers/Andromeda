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

#import "SPRJSClass.h"

@class SPRColor;

/**
 * @brief A color: JavaScript exports.
 */
@protocol SPRColor <L8Export>

/// The red value, ranged 0 to 255.
@property (assign) uint8_t red;

/// The green value, ranged 0 to 255.
@property (assign) uint8_t green;

/// The blue value, ranged 0 to 255.
@property (assign) uint8_t blue;

/// The alpha value, ranged 0 to 255.
@property (assign) uint8_t alpha;

/**
 * Create a new color.
 *
 * @!param red The red value, ranged 0 to 255.
 * @!param green The green value, ranged 0 to 255.
 * @!param blue The blue value, ranged 0 to 255.
 * @!param alpha The alpha value, ranged 0 to 255. [optional]
 * @return The initialized color.
 */
- (instancetype)init;

/**
 * Blend with another color evenly.
 *
 * @param other The color to blend with.
 * @return The new, blended color.
 */
- (SPRColor *)blend:(SPRColor *)other;

/**
 * Blend with another color, weighted.
 *
 * Note that w1+w2 can't be equal to 0, or an exception
 * is thrown.
 *
 * @param other The color to blend with.
 * @param w1 The weight of self.
 * @param w2 The weight of the other color.
 * @return A new, blended color.
 */
L8_EXPORT_AS(blendWeighted,
- (SPRColor *)blend:(SPRColor *)other
		 withLeftWeight:(double)w1
			rightWeight:(double)w2
);

@end

/**
 * @brief A color.
 */
@interface SPRColor : NSObject <SPRColor, SPRJSClass>

/**
 * Create a new color.
 *
 * @param red The red value, ranged 0 to 255.
 * @param green The green value, ranged 0 to 255.
 * @param blue The blue value, ranged 0 to 255.
 * @return The initialized color.
 */
- (instancetype)initWithRed:(uint8_t)red
					  green:(uint8_t)green
					   blue:(uint8_t)blue;

/**
 * Create a new color.
 *
 * @param red The red value, ranged 0 to 255.
 * @param green The green value, ranged 0 to 255.
 * @param blue The blue value, ranged 0 to 255.
 * @param alpha The alpha value, ranged 0 to 255.
 * @return The initialized color.
 */
- (instancetype)initWithRed:(uint8_t)red
					  green:(uint8_t)green
					   blue:(uint8_t)blue
					  alpha:(uint8_t)alpha;

/**
 * Create an SPRColor with color-information from an
 * NSColor object.
 *
 * @param color The NSColor object.
 * @return The SPRColor.
 */
- (instancetype)initWithNSColor:(NSColor *)color;

/**
 * Get an NSColor representing the same color.
 *
 * @return An NSColor object.
 */
- (NSColor *)toNSColor;

/**
 * Get an CGColor representing the same color.
 *
 * @return A CGColor object.
 */
- (CGColorRef)newCGColor;

@end
