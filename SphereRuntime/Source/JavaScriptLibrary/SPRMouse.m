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

#import "SPRMouse.h"

@implementation SPRMouse

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *mouse;

	mouse = context[@"Input"][@"Mouse"];

	mouse[@"BUTTON_LEFT"] = @(0);
	mouse[@"BUTTON_MIDDLE"] = @(1);
	mouse[@"BUTTON_RIGHT"] = @(2);
}

- (float)x
{
	return 42.0;
}

- (float)y
{
	return 42.0;
}

- (size_t)numberOfButtons
{
	return 0;
}

- (BOOL)isButtonPressed:(spr_mouse_button_t)button
{
	return NO;
}

- (void)setPositionToX:(float)x y:(float)y
{
	
}

@end

@implementation SPRMouseWheel

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *wheel;

	wheel = context[@"Input"][@"Mouse"][@"Wheel"];

	wheel[@"UP"] = @(3);
	wheel[@"DOWN"] = @(4);
}

- (spr_mouse_wheel_event_t)getEvent
{
	return 0;
}

@end
