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
 * @brief Mouse input device: JavaScript exports.
 */
@protocol SPRMouse <L8Export>

@property (readonly) float x;
@property (readonly) float y;

L8_EXPORT_AS(setPosition,
- (void)setPositionToX:(float)x y:(float)y
);

- (BOOL)isButtonPressed:(int)button;

- (unsigned int)numberOfButtons;

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
- (int)getEvent;

@end

/**
 * @brief Mouse input device.
 */
@interface SPRMouse : SPRInputDevice <SPRMouse>

@end

/**
 * @brief Mouse input device, the scroll wheel.
 */
@interface SPRMouseWheel : NSObject <SPRMouseWheel>

@end
