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

#import "AMDColor.h"

@implementation AMDColor

@synthesize red=_red, green=_green, blue=_blue, alpha=_alpha;

+ (void)installIntoContext:(L8Context *)context
{
	context[@"Color"] = [AMDColor class];
}

- (instancetype)init
{
	self = [super init];
	if(self) {
		NSArray *args = [L8Context currentArguments];
		size_t count = args.count;

		_red = (count >= 1)?[args[0] toUInt32]:0.0;
		_green = (count >= 2)?[args[1] toUInt32]:0.0;
		_blue = (count >= 3)?[args[2] toUInt32]:0.0;
		_alpha = (count >= 4)?[args[3] toUInt32]:1.0;
	}
	return self;
}

- (instancetype)initWithRed:(float)red
					  green:(float)green
					   blue:(float)blue
{
	self = [super init];
	if(self) {
		_red = red;
		_green = green;
		_blue = blue;
		_alpha = 1.0;
	}
	return self;
}

- (instancetype)initWithRed:(float)red
					  green:(float)green
					   blue:(float)blue
					  alpha:(float)alpha
{
	self = [super init];
	if(self) {
		_red = red;
		_green = green;
		_blue = blue;
		_alpha = alpha;
	}
	return self;
}

- (instancetype)initWithNSColor:(NSColor *)color
{
	self = [super init];
	if(self) {
		_red = color.redComponent;
		_green = color.greenComponent;
		_blue = color.blueComponent;
		_alpha = color.alphaComponent;
	}
	return self;
}

- (AMDColor *)blend:(AMDColor *)other
{
	return [[AMDColor alloc] initWithRed:(other.red+_red)/2.0
								   green:(other.green+_green)/2.0
									blue:(other.blue+_blue)/2.0
								   alpha:(other.alpha+_alpha)/2.0];
}

- (AMDColor *)blend:(AMDColor *)other
	 withLeftWeight:(double)w1
		rightWeight:(double)w2
{
	w1 = (w1 < 0.0)?-w1:w1;
	w2 = (w2 < 0.0)?-w2:w2;

	if(w1+w2 == 0.0)
		[[L8Value valueWithObject:@"Invalid arguments: (w1+w2) must be > 0.0"
						inContext:[L8Context currentContext]] throwValue];

	return [[AMDColor alloc] initWithRed:(other.red*w2+_red*w1)/(w1+w2)
								   green:(other.green*w2+_green*w1)/(w1+w2)
									blue:(other.blue*w2+_blue*w1)/(w1+w2)
								   alpha:(other.alpha*w2+_alpha*w1)/(w1+w2)];
}

- (BOOL)isEqual:(id)object
{
	if([object isKindOfClass:[self class]]) {
		AMDColor *color = object;
		if(color.red == _red
		   && color.green == _green
		   && color.blue == _blue
		   && color.alpha == _alpha)
			return YES;
	}
	return NO;
}

- (NSColor *)toNSColor
{
	return [NSColor colorWithCalibratedRed:_red green:_green blue:_blue alpha:_alpha];
}

- (CGColorRef)newCGColor
{
	return CGColorCreateGenericRGB(_red, _green, _blue, _alpha);
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<AMDColor>{%f, %f, %f, %f}",
			_red,_green,_blue,_alpha];
}

@end
