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

/// Gamepad axes.
typedef enum spr_gamepad_axis_e : unsigned int {
	SPR_GAMEPAD_AXIS_X = 0,
	SPR_GAMEPAD_AXIS_Y = 1
} spr_gamepad_axis_t;

/**
 * @brief Gamepad input device: JavaScript exports.
 */
@protocol SPRGamepad <L8Export>

/// Get the number of buttons.
@property (readonly) size_t numberOfButtons;

/// Get the number of axes available.
@property (readonly) size_t numberOfAxes;

/**
 * Get whether specified button is being pressed.
 *
 * @param button The button.
 * @return YES when the button is pressed, NO otherwise.
 */
- (BOOL)isButtonPressed:(int)button;

/**
 * Get the current value of specified axis.
 *
 * @param axis The axis.
 * @return A floating point value for the axis.
 */
- (double)getAxis:(spr_gamepad_axis_t)axis;

@end

/**
 * @brief Gamepad input device.
 */
@interface SPRGamepad : SPRInputDevice <SPRGamepad>

@end
