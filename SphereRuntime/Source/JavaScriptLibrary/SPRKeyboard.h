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
	SPR_KEY_NONE = 0,

	// Scancode + 1
	SPR_KEY_A = 1,
	SPR_KEY_S = 2,
	SPR_KEY_D = 3,
	SPR_KEY_F = 4,
	SPR_KEY_H = 5,
	SPR_KEY_G = 6,
	SPR_KEY_Z = 7,
	SPR_KEY_X = 8,
	SPR_KEY_C = 9,
	SPR_KEY_V = 10,
	SPR_KEY_PARAGRAPH = 11,
	SPR_KEY_B = 12,
	SPR_KEY_Q = 13,
	SPR_KEY_W = 14,
	SPR_KEY_E = 15,
	SPR_KEY_R = 16,
	SPR_KEY_Y = 17,
	SPR_KEY_T = 18,
	SPR_KEY_1 = 19,
	SPR_KEY_2 = 20,
	SPR_KEY_3 = 21,
	SPR_KEY_4 = 22,
	SPR_KEY_6 = 23,
	SPR_KEY_5 = 24,
	SPR_KEY_EQUALS = 25,
	SPR_KEY_9 = 26,
	SPR_KEY_7 = 27,
	SPR_KEY_MINUS = 28,
	SPR_KEY_8 = 29,
	SPR_KEY_0 = 30,
	SPR_KEY_CLOSEBRACE = 31,
	SPR_KEY_O = 32,
	SPR_KEY_U = 33,
	SPR_KEY_OPENBRACE = 34,
	SPR_KEY_I = 35,
	SPR_KEY_P = 36,
	SPR_KEY_ENTER = 37,
	SPR_KEY_L = 38,
	SPR_KEY_J = 39,
	SPR_KEY_APOSTROPHE = 40,
	SPR_KEY_K = 41,
	SPR_KEY_SEMICOLON = 42,
	SPR_KEY_BACKSLASH = 43,
	SPR_KEY_COMMA = 44,
	SPR_KEY_SLASH = 45,
	SPR_KEY_N = 46,
	SPR_KEY_M = 47,
	SPR_KEY_PERIOD = 48,
	SPR_KEY_TAB = 49,
	SPR_KEY_SPACE = 50,
	SPR_KEY_TILDE = 51,
	SPR_KEY_BACKSPACE = 52,

	SPR_KEY_ESCAPE = 54,

	SPR_KEY_F5 = 97,
	SPR_KEY_F6 = 98,
	SPR_KEY_F7 = 99,
	SPR_KEY_F3 = 100,
	SPR_KEY_F8 = 101,
	SPR_KEY_F9 = 102,

	SPR_KEY_F11 = 104,

	SPR_KEY_F10 = 110,
	SPR_KEY_F12 = 112,

	SPR_KEY_PAGEUP = 117,
	SPR_KEY_DELETE = 118,
	SPR_KEY_F4 = 119,

	SPR_KEY_F2 = 121,
	SPR_KEY_PAGEDOWN = 122,
	SPR_KEY_F1 = 123,
	SPR_KEY_LEFT = 124,
	SPR_KEY_RIGHT = 125,
	SPR_KEY_DOWN = 126,
	SPR_KEY_UP = 127,

	SPR_KEY_SHIFT = 247,		//MOD
	SPR_KEY_CAPSLOCK = 248,		//MOD
	SPR_KEY_CTRL = 249,			//MOD
	SPR_KEY_ALT = 250,			//MOD
	SPR_KEY_CMND = 251,			//MOD
	SPR_KEY_FN = 252,			//MOD
	SPR_KEY_HOME = 253,			//COMBO CMD+LEFT
	SPR_KEY_END = 254,			//COMBO CMD+RIGHT

	SPR_KEY_NUMLOCK = 255,
	SPR_KEY_SCROLLOCK = 255,
	SPR_KEY_NUM_0 = 255,
	SPR_KEY_NUM_1 = 255,
	SPR_KEY_NUM_2 = 255,
	SPR_KEY_NUM_3 = 255,
	SPR_KEY_NUM_4 = 255,
	SPR_KEY_NUM_5 = 255,
	SPR_KEY_NUM_6 = 255,
	SPR_KEY_NUM_7 = 255,
	SPR_KEY_NUM_8 = 255,
	SPR_KEY_NUM_9 = 255,
	SPR_KEY_INSERT = 255,
} spr_keyboard_key_t;

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

/**
 * Empty the queue. For example, when new user input will start.
 */
- (void)clearQueue;

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
