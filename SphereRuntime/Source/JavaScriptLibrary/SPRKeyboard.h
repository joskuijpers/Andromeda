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

#import "SPRInputDevice.h"

/// Keys on a keyboard.
typedef enum spr_keyboard_key_e : unsigned int {
	SPR_KEY_ESCAPE
} spr_keyboard_key_t;

typedef enum spr_keyboard_mod_e : unsigned int {
	SPR_MOD_SHIFT = 1 << 0,
	SPR_MOD_CTRL = 1 << 1,
	SPR_MOD_ALT = 1 << 2,
	SPR_MOD_CMND = 1 << 3,
	SPR_MOD_NUM = 1 << 4, // If any num key is pressed!!
} spr_keyboard_mod_t;


/**
 * @brief Keyboard input device: JavaScript exports.
 */
@protocol SPRKeyboard <L8Export>

/**
 * Get the next key from the queue.
 *
 * @return A key, or KEY_NONE when queue is empty.
 */
- (spr_keyboard_key_t)getKey;

/**
 * Get whether a specific, or any, key is pressed.
 *
 * When no key is supplied, the function will return YES
 * when any key is pressed.
 *
 * @!param key The key to check. [optional]
 * @return YES when pressed, NO otherwise.
 */
- (BOOL)isKeyPressed;

/**
 * Get the state of the toggle-able keys: caps-, scrol-, and numlock.
 *
 * @param key The toggleable key.
 * @return YES when the state is active, NO otherwise.
 */
- (BOOL)getToggleState:(spr_keyboard_key_t)key;

/**
 * Get the string for a key.
 *
 * Returns "a" for KEY_A when shift is NO. When shift is YES,
 * it returns "A".
 *
 * @param key The key.
 * @!param shift Whether shift is pressed during this key.
 * @return The string representing the key. If the key has no representation,
 * returns undefined.
 */
L8_EXPORT_AS(getKeyString,
- (NSString *)getKeyString:(spr_keyboard_key_t)key
);

@end

/**
 * @brief Keyboard input device.
 */
@interface SPRKeyboard : SPRInputDevice <SPRKeyboard>

/**
 * Get the string for a key.
 *
 * Returns "a" for KEY_A when shift is NO. When shift is YES,
 * it returns "A".
 *
 * @param key The key.
 * @param shift Whether shift is pressed during this key.
 * @return The string representing the key. If the key has no representation,
 * returns undefined.
 */
- (NSString *)getKeyString:(spr_keyboard_key_t)key withShift:(BOOL)shift;

@end
