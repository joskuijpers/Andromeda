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

#import "AMDInput.h"
#import "AMDKeyboard.h"
#import "AMDGamepad.h"
#import "AMDMouse.h"

@implementation AMDInput

@synthesize gamepads=_gamepads;

+ (void)installIntoContext:(L8Context *)context
{
	AMDInput *input;

	input = [[AMDInput alloc] initWithContext:context];
	context[@"Input"] = input;

	[input.mouse installInstanceIntoContext:context];
	[input.keyboard installInstanceIntoContext:context];

	[[AMDGamepad class] installIntoContext:context];
}

- (instancetype)initWithContext:(L8Context *)context
{
    self = [super init];
    if (self) {
		_mouse = [[AMDMouse alloc] init];
		_keyboard = [[AMDKeyboard alloc] init];

		_gamepads = (NSArray<AMDGamepad> *)@[];
    }
    return self;
}

@end

@implementation AMDInputConfig

- (instancetype)initWithConfiguration:(NSDictionary *)configuration
{
	self = [super init];
	if(self) {
	}
	return self;
}

- (void)save
{

}

@end