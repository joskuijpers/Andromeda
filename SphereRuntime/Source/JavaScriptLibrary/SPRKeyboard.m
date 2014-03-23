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

@implementation SPRKeyboard

- (void)installInstanceIntoContext:(L8Context *)context
{
	[super installInstanceIntoContext:context];

	L8Value *keyboard;

	keyboard = context[@"Input"][@"Keyboard"];

#define SET_KEY(key) keyboard[@#key] = @(SPR_##key);

	SET_KEY(KEY_A)
	SET_KEY(KEY_B)
	SET_KEY(KEY_C)
}

- (spr_keyboard_key_t)getKey
{
	return SPR_KEY_A;
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
	if(key == SPR_KEY_A)
		return shift?@"A":@"a";
	if(key == SPR_KEY_B)
		return shift?@"B":@"c";
	return nil;
}

@end
