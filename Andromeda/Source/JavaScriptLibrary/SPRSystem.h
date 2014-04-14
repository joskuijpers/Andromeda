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

/**
 * @brief The System class: JavaScript exports.
 */
@protocol SPRSystem <L8Export>

/**
 * Abort the game engine with a message.
 *
 * @param message The abort message.
 */
L8_EXPORT_AS(abort,
+ (void)abortWithMessage:(NSString *)message
);

/**
 * Exit the game engine unconditionally.
 */
+ (void)exit;

/**
 * Restart the game.
 */
+ (void)restart;

@end

/**
 * @brief Debugging the system withing JavaScript: JavaScript exports.
 */
@protocol SPRSystemDebug <L8Export>

/**
 * Run the garbage collector.
 *
 * @warning This method is blocking, and can take a while (seconds).
 */
+ (void)garbageCollect;

@end

/**
 * @brief The System class.
 */
@interface SPRSystem : NSObject <SPRSystem, SPRJSClass>

@end

/**
 * @brief Debugging the system withing JavaScript.
 */
@interface SPRSystemDebug : NSObject <SPRSystemDebug, SPRJSClass>

@end
