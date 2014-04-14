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
#import "NSMutableArray+SPRQueue.h"
#import "SPRCoordinateUtilities.h"

@implementation SPRMouse

@synthesize wheel=_wheel;

- (instancetype)init
{
    self = [super init];
    if (self) {
		_wheel = [[SPRMouseWheel alloc] init];
    }
    return self;
}

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *mouse;

	mouse = [L8Value valueWithObject:self inContext:context];

	mouse[@"BUTTON_LEFT"] = @(SPR_MOUSE_BUTTON_LEFT);
	mouse[@"BUTTON_RIGHT"] = @(SPR_MOUSE_BUTTON_RIGHT);
	mouse[@"BUTTON_MIDDLE"] = @(SPR_MOUSE_BUTTON_MIDDLE);
	mouse[@"BUTTON_EXTRA_1"] = @(SPR_MOUSE_BUTTON_EXTRA_1);
	mouse[@"BUTTON_EXTRA_2"] = @(SPR_MOUSE_BUTTON_EXTRA_2);

	context[@"Input"][@"Mouse"] = mouse;

	[_wheel installInstanceIntoContext:context];
}

- (float)x
{
	NSPoint location;

	location = [[NSApp mainWindow] mouseLocationOutsideOfEventStream];
	return spr_coord_translate_screen(location).x;
}

- (float)y
{
	NSPoint location;

	location = [[NSApp mainWindow] mouseLocationOutsideOfEventStream];
	return spr_coord_translate_screen(location).y;
}

/*
 * Using IOKit, see http://stackoverflow.com/questions/1828672/osx-number-of-buttons-on-attached-mouse
 * the number of mouse buttons can be found (the useless upper bound).
 * As this number is quite useless, and because almost all macs either have
 * a Magic Mouse (2 buttons), a trackpad (2 click gestures) or a Apple Mouse (2 buttons),
 * the number of buttons is hardcoded to 2.
 */
- (size_t)numberOfButtons
{
	return 2;
}

- (BOOL)isButtonPressed:(spr_mouse_button_t)button
{
	NSUInteger pressedButtons;

	if((unsigned int)button > 4)
		return NO;

	pressedButtons = [NSEvent pressedMouseButtons];

	if(pressedButtons & (0x1 << (unsigned int)button))
	   return YES;

	return NO;
}

- (void)setPositionToX:(float)x y:(float)y
{
	//CGPoint location;

	//Need to translate to screen coordinates

	//CGWarpMouseCursorPosition(location);
}

@end

@implementation SPRMouseWheel {
	id _monitor;
	NSMutableArray *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		NSEvent *(^eventHandler)(NSEvent *);

		_queue = [[NSMutableArray alloc] init];

		eventHandler = ^NSEvent *(NSEvent *event) {
			float deltaX, deltaY;

			deltaX = event.deltaX;
			deltaY = event.deltaY;

			// Do not handle scrolling smaller than 1.0
			// to make the precise scrolling of OSX usable
			// in the Sphere-style games.
			if(deltaY >= 1.0)
				[_queue enqueue:@(SPR_MOUSE_WHEEL_DOWN)];
			else if(deltaY <= -1.0)
				[_queue enqueue:@(SPR_MOUSE_WHEEL_UP)];

			if(deltaX >= 1.0)
				[_queue enqueue:@(SPR_MOUSE_WHEEL_RIGHT)];
			else if(deltaX <= -1.0)
				[_queue enqueue:@(SPR_MOUSE_WHEEL_LEFT)];

			return event;
		};

        _monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSScrollWheelMask
														 handler:eventHandler];
    }
    return self;
}

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *wheel;

	wheel = [L8Value valueWithObject:self inContext:context];

	wheel[@"NONE"] = @(SPR_MOUSE_WHEEL_NONE);
	wheel[@"UP"] = @(SPR_MOUSE_WHEEL_UP);
	wheel[@"DOWN"] = @(SPR_MOUSE_WHEEL_DOWN);
	wheel[@"LEFT"] = @(SPR_MOUSE_WHEEL_LEFT);
	wheel[@"RIGHT"] = @(SPR_MOUSE_WHEEL_RIGHT);

	context[@"Input"][@"Mouse"][@"Wheel"] = wheel;
}

- (void)dealloc
{
	if(_monitor) {
		[NSEvent removeMonitor:_monitor];
		_monitor = nil;
	}
}

- (spr_mouse_wheel_event_t)getEvent
{
	NSNumber *event;

	event = [_queue dequeue];
	if(event)
		return [event unsignedIntValue];

	return SPR_MOUSE_WHEEL_NONE;
}

- (void)clearQueue
{
	[_queue removeAllObjects];
}

@end
