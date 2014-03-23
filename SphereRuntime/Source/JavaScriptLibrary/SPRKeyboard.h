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
typedef enum spr_keyboard_key_e : uint8_t {
	SPR_KEY_NONE,
	SPR_KEY_F1,
	SPR_KEY_F2,
	SPR_KEY_F3,
	SPR_KEY_F4,
	SPR_KEY_F5,
	SPR_KEY_F6,
	SPR_KEY_F7,
	SPR_KEY_F8,
	SPR_KEY_F9,
	SPR_KEY_F10,
	SPR_KEY_F11,
	SPR_KEY_F12,
	SPR_KEY_TILDE,
	SPR_KEY_0,
	SPR_KEY_1,
	SPR_KEY_2,
	SPR_KEY_3,
	SPR_KEY_4,
	SPR_KEY_5,
	SPR_KEY_6,
	SPR_KEY_7,
	SPR_KEY_8,
	SPR_KEY_9,
	SPR_KEY_MINUS,
	SPR_KEY_EQUALS,
	SPR_KEY_BACKSPACE,
	SPR_KEY_TAB,
	SPR_KEY_A,
	SPR_KEY_B,
	SPR_KEY_C,
	SPR_KEY_D,
	SPR_KEY_E,
	SPR_KEY_F,
	SPR_KEY_G,
	SPR_KEY_H,
	SPR_KEY_I,
	SPR_KEY_J,
	SPR_KEY_K,
	SPR_KEY_L,
	SPR_KEY_M,
	SPR_KEY_N,
	SPR_KEY_O,
	SPR_KEY_P,
	SPR_KEY_Q,
	SPR_KEY_R,
	SPR_KEY_S,
	SPR_KEY_T,
	SPR_KEY_U,
	SPR_KEY_V,
	SPR_KEY_W,
	SPR_KEY_X,
	SPR_KEY_Y,
	SPR_KEY_Z,
	SPR_KEY_SHIFT,
	SPR_KEY_CAPSLOCK,
	SPR_KEY_NUMLOCK,
	SPR_KEY_SCROLLOCK,
	SPR_KEY_CTRL,
	SPR_KEY_ALT,
	SPR_KEY_SPACE,
	SPR_KEY_OPENBRACE,
	SPR_KEY_CLOSEBRACE,
	SPR_KEY_SEMICOLON,
	SPR_KEY_APOSTROPHE,
	SPR_KEY_COMMA,
	SPR_KEY_PERIOD,
	SPR_KEY_SLASH,
	SPR_KEY_BACKSLASH,
	SPR_KEY_ENTER,
	SPR_KEY_INSERT,
	SPR_KEY_DELETE,
	SPR_KEY_HOME,
	SPR_KEY_END,
	SPR_KEY_PAGEUP,
	SPR_KEY_PAGEDOWN,
	SPR_KEY_UP,
	SPR_KEY_RIGHT,
	SPR_KEY_DOWN,
	SPR_KEY_LEFT,
	SPR_KEY_NUM_0,
	SPR_KEY_NUM_1,
	SPR_KEY_NUM_2,
	SPR_KEY_NUM_3,
	SPR_KEY_NUM_4,
	SPR_KEY_NUM_5,
	SPR_KEY_NUM_6,
	SPR_KEY_NUM_7,
	SPR_KEY_NUM_8,
	SPR_KEY_NUM_9
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
