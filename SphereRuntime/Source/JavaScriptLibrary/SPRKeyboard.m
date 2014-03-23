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

#import "SPRKeyboard.h"
#import "NSMutableArray+SPRQueue.h"

@implementation SPRKeyboard {
	id _monitor;
	NSMutableArray *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		NSEventMask mask;
		NSEvent *(^eventHandler)(NSEvent *);

		_queue = [[NSMutableArray alloc] init];

		eventHandler = ^NSEvent *(NSEvent *event) {
			NSLog(@"[KB] Got event %@",event);

			return event;
		};

		mask = NSKeyDownMask | NSKeyUpMask;
        _monitor = [NSEvent addLocalMonitorForEventsMatchingMask:mask
														 handler:eventHandler];
    }
    return self;
}

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *keyboard;

	keyboard = [L8Value valueWithObject:self inContext:context];

#define SET_KEY(key) keyboard[@#key] = @(SPR_##key);

	SET_KEY(KEY_NONE)
	SET_KEY(KEY_F1)
	SET_KEY(KEY_F2)
	SET_KEY(KEY_F3)
	SET_KEY(KEY_F4)
	SET_KEY(KEY_F5)
	SET_KEY(KEY_F6)
	SET_KEY(KEY_F7)
	SET_KEY(KEY_F8)
	SET_KEY(KEY_F9)
	SET_KEY(KEY_F10)
	SET_KEY(KEY_F11)
	SET_KEY(KEY_F12)
	SET_KEY(KEY_TILDE)
	SET_KEY(KEY_0)
	SET_KEY(KEY_1)
	SET_KEY(KEY_2)
	SET_KEY(KEY_3)
	SET_KEY(KEY_4)
	SET_KEY(KEY_5)
	SET_KEY(KEY_6)
	SET_KEY(KEY_7)
	SET_KEY(KEY_8)
	SET_KEY(KEY_9)
	SET_KEY(KEY_MINUS)
	SET_KEY(KEY_EQUALS)
	SET_KEY(KEY_BACKSPACE)
	SET_KEY(KEY_TAB)
	SET_KEY(KEY_A)
	SET_KEY(KEY_B)
	SET_KEY(KEY_C)
	SET_KEY(KEY_D)
	SET_KEY(KEY_E)
	SET_KEY(KEY_F)
	SET_KEY(KEY_G)
	SET_KEY(KEY_H)
	SET_KEY(KEY_I)
	SET_KEY(KEY_J)
	SET_KEY(KEY_K)
	SET_KEY(KEY_L)
	SET_KEY(KEY_M)
	SET_KEY(KEY_N)
	SET_KEY(KEY_O)
	SET_KEY(KEY_P)
	SET_KEY(KEY_Q)
	SET_KEY(KEY_R)
	SET_KEY(KEY_S)
	SET_KEY(KEY_T)
	SET_KEY(KEY_U)
	SET_KEY(KEY_V)
	SET_KEY(KEY_W)
	SET_KEY(KEY_X)
	SET_KEY(KEY_Y)
	SET_KEY(KEY_Z)
	SET_KEY(KEY_SHIFT)
	SET_KEY(KEY_CAPSLOCK)
	SET_KEY(KEY_NUMLOCK)
	SET_KEY(KEY_SCROLLOCK)
	SET_KEY(KEY_CTRL)
	SET_KEY(KEY_ALT)
	SET_KEY(KEY_SPACE)
	SET_KEY(KEY_OPENBRACE)
	SET_KEY(KEY_CLOSEBRACE)
	SET_KEY(KEY_SEMICOLON)
	SET_KEY(KEY_APOSTROPHE)
	SET_KEY(KEY_COMMA)
	SET_KEY(KEY_PERIOD)
	SET_KEY(KEY_SLASH)
	SET_KEY(KEY_BACKSLASH)
	SET_KEY(KEY_ENTER)
	SET_KEY(KEY_INSERT)
	SET_KEY(KEY_DELETE)
	SET_KEY(KEY_HOME)
	SET_KEY(KEY_END)
	SET_KEY(KEY_PAGEUP)
	SET_KEY(KEY_PAGEDOWN)
	SET_KEY(KEY_UP)
	SET_KEY(KEY_RIGHT)
	SET_KEY(KEY_DOWN)
	SET_KEY(KEY_LEFT)
	SET_KEY(KEY_NUM_0)
	SET_KEY(KEY_NUM_1)
	SET_KEY(KEY_NUM_2)
	SET_KEY(KEY_NUM_3)
	SET_KEY(KEY_NUM_4)
	SET_KEY(KEY_NUM_5)
	SET_KEY(KEY_NUM_6)
	SET_KEY(KEY_NUM_7)
	SET_KEY(KEY_NUM_8)
	SET_KEY(KEY_NUM_9)

	context[@"Input"][@"Keyboard"] = keyboard;
}

- (void)dealloc
{
	if(_monitor) {
		[NSEvent removeMonitor:_monitor];
		_monitor = nil;
	}
}

- (spr_keyboard_key_t)getKey
{
	return SPR_KEY_NONE;
}

- (void)clearQueue
{
	[_queue removeAllObjects];
}

- (BOOL)isKeyPressed
{
	return NO;
}

- (BOOL)getToggleState:(spr_keyboard_key_t)key
{
	return NO;
}

- (NSString *)getKeyString:(spr_keyboard_key_t)key
{
	NSArray *arguments;
	BOOL shift = NO;

	arguments = [L8Context currentArguments];
	if(arguments.count >= 2)
		shift = [arguments[1] toBool];

	return [self getKeyString:key withShift:shift];
}

- (NSString *)getKeyString:(spr_keyboard_key_t)key withShift:(BOOL)shift
{
	return nil;
}

@end
