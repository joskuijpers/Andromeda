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

#import "AMDInputDevice.h"

/// Keys on a keyboard.
typedef enum spr_keyboard_key_e : uint8_t {
	AMD_KEY_NONE = 0,

	// Scancode + 1
	AMD_KEY_A = 1,
	AMD_KEY_S = 2,
	AMD_KEY_D = 3,
	AMD_KEY_F = 4,
	AMD_KEY_H = 5,
	AMD_KEY_G = 6,
	AMD_KEY_Z = 7,
	AMD_KEY_X = 8,
	AMD_KEY_C = 9,
	AMD_KEY_V = 10,
	AMD_KEY_PARAGRAPH = 11,
	AMD_KEY_B = 12,
	AMD_KEY_Q = 13,
	AMD_KEY_W = 14,
	AMD_KEY_E = 15,
	AMD_KEY_R = 16,
	AMD_KEY_Y = 17,
	AMD_KEY_T = 18,
	AMD_KEY_1 = 19,
	AMD_KEY_2 = 20,
	AMD_KEY_3 = 21,
	AMD_KEY_4 = 22,
	AMD_KEY_6 = 23,
	AMD_KEY_5 = 24,
	AMD_KEY_EQUALS = 25,
	AMD_KEY_9 = 26,
	AMD_KEY_7 = 27,
	AMD_KEY_MINUS = 28,
	AMD_KEY_8 = 29,
	AMD_KEY_0 = 30,
	AMD_KEY_CLOSEBRACE = 31,
	AMD_KEY_O = 32,
	AMD_KEY_U = 33,
	AMD_KEY_OPENBRACE = 34,
	AMD_KEY_I = 35,
	AMD_KEY_P = 36,
	AMD_KEY_ENTER = 37,
	AMD_KEY_L = 38,
	AMD_KEY_J = 39,
	AMD_KEY_APOSTROPHE = 40,
	AMD_KEY_K = 41,
	AMD_KEY_SEMICOLON = 42,
	AMD_KEY_BACKSLASH = 43,
	AMD_KEY_COMMA = 44,
	AMD_KEY_SLASH = 45,
	AMD_KEY_N = 46,
	AMD_KEY_M = 47,
	AMD_KEY_PERIOD = 48,
	AMD_KEY_TAB = 49,
	AMD_KEY_SPACE = 50,
	AMD_KEY_TILDE = 51,
	AMD_KEY_BACKSPACE = 52,

	AMD_KEY_ESCAPE = 54,

	AMD_KEY_F5 = 97,
	AMD_KEY_F6 = 98,
	AMD_KEY_F7 = 99,
	AMD_KEY_F3 = 100,
	AMD_KEY_F8 = 101,
	AMD_KEY_F9 = 102,

	AMD_KEY_F11 = 104,

	AMD_KEY_F10 = 110,
	AMD_KEY_F12 = 112,

	AMD_KEY_PAGEUP = 117,
	AMD_KEY_DELETE = 118,
	AMD_KEY_F4 = 119,

	AMD_KEY_F2 = 121,
	AMD_KEY_PAGEDOWN = 122,
	AMD_KEY_F1 = 123,
	AMD_KEY_LEFT = 124,
	AMD_KEY_RIGHT = 125,
	AMD_KEY_DOWN = 126,
	AMD_KEY_UP = 127,

	AMD_KEY_SHIFT = 247,		//MOD
	AMD_KEY_CAPSLOCK = 248,		//MOD
	AMD_KEY_CTRL = 249,			//MOD
	AMD_KEY_ALT = 250,			//MOD
	AMD_KEY_CMND = 251,			//MOD
	AMD_KEY_FN = 252,			//MOD
	AMD_KEY_HOME = 253,			//COMBO CMD+LEFT
	AMD_KEY_END = 254,			//COMBO CMD+RIGHT

	AMD_KEY_NUMLOCK = 255,
	AMD_KEY_SCROLLOCK = 255,
	AMD_KEY_NUM_0 = 255,
	AMD_KEY_NUM_1 = 255,
	AMD_KEY_NUM_2 = 255,
	AMD_KEY_NUM_3 = 255,
	AMD_KEY_NUM_4 = 255,
	AMD_KEY_NUM_5 = 255,
	AMD_KEY_NUM_6 = 255,
	AMD_KEY_NUM_7 = 255,
	AMD_KEY_NUM_8 = 255,
	AMD_KEY_NUM_9 = 255,
	AMD_KEY_INSERT = 255,
} spr_keyboard_key_t;

/**
 * @brief Keyboard input device: JavaScript exports.
 */
@protocol AMDKeyboard <L8Export>

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
@interface AMDKeyboard : AMDInputDevice <AMDKeyboard>

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
