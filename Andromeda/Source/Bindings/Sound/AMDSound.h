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

/**
 * @brief A sound to be played: JavaScript exports.
 */
@protocol AMDSound <L8Export>

/// Path of the sound.
@property (readonly) NSString *path;

/// Whether the sound is playing.
@property (readonly) BOOL playing;

/// Volume.
@property (assign) float volume;

/// Panning.
@property (assign) float pan;

/// Length of the sound, in seconds.
@property (readonly) double length;

/// Seek position in the sound.
@property (assign) double position;

/**
 * Initialize a new sound.
 *
 * @!param path Path of the sound.
 * @return self
 */
- (instancetype)init;

/**
 * Start playback.
 */
- (void)play;

/**
 * Pause playback
 */
- (void)pause;

/**
 * Stop playback.
 */
- (void)stop;

L8_EXPORT_AS(on,
- (void)addEventListener:(NSString *)event function:(L8Value *)function
);

@end

/**
 * @brief A sound to be played.
 */
@interface AMDSound : AMDEventEmitter <AMDSound>

/**
 * Initialize a new sound.
 *
 * @param path Path of the sound.
 * @return self
 */
- (instancetype)initWithPath:(NSString *)path;

@end
