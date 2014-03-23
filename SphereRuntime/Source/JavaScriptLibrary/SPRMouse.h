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

/// Mouse buttons.
typedef enum spr_mouse_button_e : unsigned int {
	SPR_MOUSE_BUTTON_LEFT		= 0,	// NSLeftMouseDown/Up
	SPR_MOUSE_BUTTON_RIGHT		= 1,	// NSRightMouseDown/Up
	SPR_MOUSE_BUTTON_MIDDLE		= 2,	// NSOtherMouseDown/Up
	SPR_MOUSE_BUTTON_EXTRA_1	= 3,
	SPR_MOUSE_BUTTON_EXTRA_2	= 4
} spr_mouse_button_t;

/// Mouse wheel events.
typedef enum spr_mouse_wheel_event_e : unsigned int {
	SPR_MOUSE_WHEEL_NONE		= 0,
	SPR_MOUSE_WHEEL_UP			= 1,
	SPR_MOUSE_WHEEL_DOWN		= 2,
	SPR_MOUSE_WHEEL_LEFT		= 3,
	SPR_MOUSE_WHEEL_RIGHT		= 4
} spr_mouse_wheel_event_t;

@class SPRMouseWheel;

/**
 * @brief Mouse input device: JavaScript exports.
 */
@protocol SPRMouse <L8Export>

/// The horizontal position of the mouse cursor.
@property (readonly) float x;

/// The vertical position of the mouse cursor.
@property (readonly) float y;

/// Get the number of buttons available.
@property (readonly) size_t numberOfButtons;

/**
 * Set the position of the mouse cursor, within screen bounds.
 *
 * @param x The horizontal position.
 * @param y The vertical position.
 */
L8_EXPORT_AS(setPosition,
- (void)setPositionToX:(float)x y:(float)y
);

/**
 * Get whether specified button is being pressed.
 *
 * @param button The button.
 * @return YES when the button is pressed, NO otherwise.
 */
- (BOOL)isButtonPressed:(spr_mouse_button_t)button;

@end

/**
 * @brief Mouse input device, the scroll wheel: JavaScript exports.
 */
@protocol SPRMouseWheel <L8Export>

/**
 * Get an event from the queue.
 *
 * @return an event, or NONE when no events happened.
 */
- (spr_mouse_wheel_event_t)getEvent;

@end

/**
 * @brief Mouse input device.
 */
@interface SPRMouse : SPRInputDevice <SPRMouse>

/// The mouse wheel input.
@property (readonly) SPRMouseWheel *wheel;

@end

/**
 * @brief Mouse input device, the scroll wheel.
 */
@interface SPRMouseWheel : SPRInputDevice <SPRMouseWheel>

@end
