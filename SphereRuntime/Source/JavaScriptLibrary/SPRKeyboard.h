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

/**
 * @brief Keyboard input device: JavaScript exports.
 */
@protocol SPRKeyboard <L8Export>

/**
 * Get the next key from the queue.
 *
 * @return A key, or KEY_NONE when queue is empty.
 */
- (int)getKey;

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

- (BOOL)getToggleState:(int)key;

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
L8_EXPORT_AS(getKeyString,
- (NSString *)getKeyString:(int)key withShift:(BOOL)shift
);

@end

/**
 * @brief Keyboard input device.
 */
@interface SPRKeyboard : SPRInputDevice <SPRKeyboard>

@end
