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

#import "AMDKeyboard.h"
#import "NSMutableArray+AMDQueue.h"

@implementation AMDKeyboard {
	id _monitor;
	NSMutableArray *_queue;
	spr_keyboard_key_t _keyStatus[256];
	size_t _numKeysPressed;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		NSEventMask mask;
		NSEvent *(^eventHandler)(NSEvent *);

		_queue = [[NSMutableArray alloc] init];
		bzero(_keyStatus, 256);

		eventHandler = ^NSEvent *(NSEvent *event) {
			unsigned short keyCode;

			if(event.isARepeat)
				return nil;

			keyCode = event.keyCode;

			if AMD_LIKELY(keyCode >= 0 && keyCode < 255) {
				if(event.type == NSKeyDown)
					_keyStatus[keyCode + 1] = 1;
				else
					_keyStatus[keyCode + 1] = 0;
			}

			// TODO: add possibly more information, like MOD states.
			[_queue enqueue:@(keyCode + 1)];

			// TODO: Make it possible to move keys upwards,
			// so that CMD+Q is closing the app.
			return nil;
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

	L8Value *keyboard, *keys;

	keyboard = [L8Value valueWithObject:self inContext:context];
	keys = [L8Value valueWithNewObjectInContext:context];

#define SET_KEY(key) keys[@#key] = @(AMD_KEY_##key);

	SET_KEY(NONE)
	SET_KEY(F1)
	SET_KEY(F2)
	SET_KEY(F3)
	SET_KEY(F4)
	SET_KEY(F5)
	SET_KEY(F6)
	SET_KEY(F7)
	SET_KEY(F8)
	SET_KEY(F9)
	SET_KEY(F10)
	SET_KEY(F11)
	SET_KEY(F12)
	SET_KEY(TILDE)
	SET_KEY(0)
	SET_KEY(1)
	SET_KEY(2)
	SET_KEY(3)
	SET_KEY(4)
	SET_KEY(5)
	SET_KEY(6)
	SET_KEY(7)
	SET_KEY(8)
	SET_KEY(9)
	SET_KEY(MINUS)
	SET_KEY(EQUALS)
	SET_KEY(BACKSPACE)
	SET_KEY(TAB)
	SET_KEY(A)
	SET_KEY(B)
	SET_KEY(C)
	SET_KEY(D)
	SET_KEY(E)
	SET_KEY(F)
	SET_KEY(G)
	SET_KEY(H)
	SET_KEY(I)
	SET_KEY(J)
	SET_KEY(K)
	SET_KEY(L)
	SET_KEY(M)
	SET_KEY(N)
	SET_KEY(O)
	SET_KEY(P)
	SET_KEY(Q)
	SET_KEY(R)
	SET_KEY(S)
	SET_KEY(T)
	SET_KEY(U)
	SET_KEY(V)
	SET_KEY(W)
	SET_KEY(X)
	SET_KEY(Y)
	SET_KEY(Z)
	SET_KEY(SHIFT)
	SET_KEY(CAPSLOCK)
	SET_KEY(NUMLOCK)
	SET_KEY(SCROLLOCK)
	SET_KEY(CTRL)
	SET_KEY(ALT)
	SET_KEY(SPACE)
	SET_KEY(OPENBRACE)
	SET_KEY(CLOSEBRACE)
	SET_KEY(SEMICOLON)
	SET_KEY(APOSTROPHE)
	SET_KEY(COMMA)
	SET_KEY(PERIOD)
	SET_KEY(SLASH)
	SET_KEY(BACKSLASH)
	SET_KEY(ENTER)
	SET_KEY(INSERT)
	SET_KEY(DELETE)
	SET_KEY(HOME)
	SET_KEY(END)
	SET_KEY(PAGEUP)
	SET_KEY(PAGEDOWN)
	SET_KEY(UP)
	SET_KEY(RIGHT)
	SET_KEY(DOWN)
	SET_KEY(LEFT)
	SET_KEY(NUM_0)
	SET_KEY(NUM_1)
	SET_KEY(NUM_2)
	SET_KEY(NUM_3)
	SET_KEY(NUM_4)
	SET_KEY(NUM_5)
	SET_KEY(NUM_6)
	SET_KEY(NUM_7)
	SET_KEY(NUM_8)
	SET_KEY(NUM_9)

	keyboard[@"Key"] = keys;
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
	NSNumber *key;

	key = [_queue dequeue];
	if(key)
		return key.unsignedIntValue;

	return AMD_KEY_NONE;
}

- (void)clearQueue
{
	[_queue removeAllObjects];
}

- (BOOL)isKeyPressed
{
	NSArray *arguments;
	unsigned int key = AMD_KEY_NONE;
	NSUInteger modFlags;

	arguments = [L8Context currentArguments];
	if(arguments.count >= 1)
		key = [[arguments[0] toNumber] unsignedIntValue];

	modFlags = [NSEvent modifierFlags];

	if(key >= 247 && key <= 252) { // Modifier keys
		switch(key) {
			case AMD_KEY_SHIFT:
				return modFlags & (0x1 << 17);
			case AMD_KEY_CAPSLOCK:
				return modFlags & (0x1 << 16);
			case AMD_KEY_CTRL:
				return modFlags & (0x1 << 18);
			case AMD_KEY_ALT:
				return modFlags & (0x1 << 19);
			case AMD_KEY_CMND:
				return modFlags & (0x1 << 20);
			case AMD_KEY_FN:
				return modFlags & (0x1 << 23);
			default: // Is dead.
				return NO;
		}
	}

	return _keyStatus[key];
}

- (BOOL)getToggleState:(spr_keyboard_key_t)key
{
	NSUInteger modFlags;

	// Capslock is the only toggleable key on a Mac keyboard
	if(key != AMD_KEY_CAPSLOCK)
		return NO;

	modFlags = [NSEvent modifierFlags];

	return modFlags & (1 << 16);
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
