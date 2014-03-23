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

#import "SPRJSClass.h"

@class SPRInput, SPRMouse, SPRKeyboard, SPRGamepad;
@protocol SPRGamepad;

/**
 * @brief Input services: JavaScript exports.
 */
@protocol SPRInput <L8Export>

@property (readonly) SPRMouse *Mouse; // Use a capital to simulate a class
@property (readonly) SPRKeyboard *Keyboard; // Use a capital to simulate a class
@property (readonly) SPRGamepad *Gamepad; // Use a capital to simulate a class
@property (readonly) NSArray<SPRGamepad> *gamepads;

@end

/**
 * @brief Input configuration: JavaScript exports.
 */
@protocol SPRInputConfig <L8Export>

@property (assign) int menu;
@property (assign) int up;
@property (assign) int down;
@property (assign) int left;
@property (assign) int right;
@property (assign) int a;
@property (assign) int b;
@property (assign) int x;
@property (assign) int y;

- (void)save;

@end

/**
 * @brief Input services.
 */
@interface SPRInput : NSObject <SPRInput, SPRJSClass>

@end

/**
 * @brief Input configuration.
 */
@interface SPRInputConfig : NSObject <SPRInputConfig, SPRJSClass>

/**
 * Create an input config object with specified configuration
 *
 * @param configuration The configuration.
 * @return An initialized SPRInputConfig object.
 */
- (instancetype)initWithConfiguration:(NSDictionary *)configuration;

@end
