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
#import "AMDEventEmitter.h"

@class L8Value;

/**
 * @brief Information about the process: JavaScript exports.
 */
@protocol AMDEngine <L8Export>

/// The main module. (type Module)
@property (strong) L8Value *mainModule;

/// Version number of Andromeda.
@property (readonly) NSNumber *version;

/// An object with version strings of Andromeda and its dependencies.
@property (readonly) NSDictionary *versions;

/**
 * Get a binding for a builtin binding-system.
 *
 * @param builtin Name of the binding.
 * @return The binding object.
 */
L8_EXPORT_AS(binding,
- (L8Value *)bindingForBuiltin:(NSString *)builtin
);

/**
 * Abort the game engine with a message.
 *
 * @param message The abort message.
 */
L8_EXPORT_AS(abort,
- (void)abortWithMessage:(NSString *)message
);

/**
 * Exit the game engine unconditionally.
 */
- (void)exit;

/**
 * Restart the game.
 */
- (void)restart;

/**
 * Put the specified function on the dispatch queue.
 *
 * Use this to assert execution order when mixing
 * sync and async functionality. Or to minimize frame-lag.
 */
- (void)dispatch:(L8Value *)function;

/**
 * Run the garbage collector.
 *
 * @warning This method is blocking, and can take a while (seconds).
 */
- (void)garbageCollect;

@end

/**
 * @brief Information about the process.
 */
@interface AMDEngine : AMDEventEmitter <AMDEngine>

@end
