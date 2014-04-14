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

#import "AMDGamepad.h"

@implementation AMDGamepad

+ (void)installIntoContext:(L8Context *)context
{
	L8Value *gamepad, *axis, *button;

	gamepad = [L8Value valueWithNewObjectInContext:context];
	axis = [L8Value valueWithNewObjectInContext:context];
	button = [L8Value valueWithNewObjectInContext:context];

	axis[@"X"] = @(AMD_GAMEPAD_AXIS_X);
	axis[@"Y"] = @(AMD_GAMEPAD_AXIS_Y);

	button[@"NONE"] = @(0);
	button[@"A"] = @(1);

	gamepad[@"Axis"] = axis;
	gamepad[@"Button"] = button;
	context[@"Input"][@"Gamepad"] = gamepad;
}

- (size_t)numberOfButtons
{
	return 0;
}

- (size_t)numberOfAxes
{
	return 0;
}

- (BOOL)isButtonPressed:(int)button
{
	return NO;
}

- (double)getAxis:(spr_gamepad_axis_t)axis
{
	return 0.0;
}

@end
