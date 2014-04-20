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

#import <L8Framework/L8Export.h>

@class L8Value;

/**
 * @brief A class that sends and receives events.
 */
@interface AMDEventEmitter : NSObject

/**
 * Trigger an event.
 *
 * @param event The event.
 * @param arguments The event arguments.
 */
- (void)triggerEvent:(NSString *)event withArguments:(NSArray *)arguments;

/**
 * Add an event listener for specified event.
 *
 * @param event The event.
 * @param function The callback function.
 */
- (void)addEventListener:(NSString *)event function:(L8Value *)function;

- (void)removeEventListener:(NSString *)event function:(L8Value *)function;

- (void)removeAllEventListeners:(NSString *)event;

@end

/**
 * @brief JavaScript exports for classes that send events.
 *
 * Provides the on() function for JavaScript to register callbacks.
 */
@protocol AMDEventSender <L8Export>

/**
 * Add an event listener for an event.
 *
 * @param event The event. [keydown,keyup]
 * @param function The JS function.
 */
L8_EXPORT_AS(on,
- (void)addEventListener:(NSString *)event function:(L8Value *)function
);

@end

/**
 * @brief JavaScript exports for classes that accept events.
 *
 * Provides the .trigger() function for JavaScript to trigger callbacks.
 */
@protocol AMDEventReceiver <L8Export>

/**
 * Trigger an event.
 *
 * @param event The event.
 * @param arguments The event arguments.
 */
L8_EXPORT_AS(trigger,
- (void)triggerEvent:(NSString *)event withArguments:(NSArray *)arguments
);

@end
