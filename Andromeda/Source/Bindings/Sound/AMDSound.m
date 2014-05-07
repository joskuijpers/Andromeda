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

#import "AMDSound.h"
#import <L8Framework/L8.h>
#import <AVFoundation/AVFoundation.h>

@interface AMDSound () <AVAudioPlayerDelegate>
@end

@implementation AMDSound {
	AVAudioPlayer *_audioPlayer;
}

@synthesize path=_path;

- (instancetype)init
{
	NSArray *arguments;

	arguments = [L8Context currentArguments];
	if(arguments.count < 1 || ![arguments[0] isString])
		@throw [L8TypeErrorException exceptionWithMessage:@"First argument must be a String."];

	return [self initWithPath:[arguments[0] toString]];
}

- (instancetype)initWithPath:(NSString *)path
{
	self = [super init];
	if(self) {
		NSURL *url;
		NSError *error;

		_path = path;
		url = [NSURL fileURLWithPath:path];
		if(!url)
			return nil;

		_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
															  error:&error];
		if(!_audioPlayer)
			return nil;

		_audioPlayer.delegate = self;
		[_audioPlayer prepareToPlay];
	}
	return self;
}

#pragma mark - Actions

- (void)play
{
	[_audioPlayer play];
}

- (void)pause
{
	[_audioPlayer pause];
}

- (void)stop
{
	[_audioPlayer stop];
}

#pragma mark - Properties

- (BOOL)playing
{
	return _audioPlayer.playing;
}

- (float)volume
{
	return _audioPlayer.volume;
}

- (void)setVolume:(float)volume
{
	_audioPlayer.volume = volume;
}

- (float)pan
{
	return _audioPlayer.pan;
}

- (void)setPan:(float)pan
{
	_audioPlayer.pan = pan;
}

- (double)length
{
	return (double)_audioPlayer.duration;
}

- (double)position
{
	return (double)_audioPlayer.currentTime;
}

- (void)setPosition:(double)position
{
	if(position >= 0.0 && position <= _audioPlayer.duration)
		_audioPlayer.currentTime = position;
}

#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[self triggerEvent:@"finished" withArguments:nil];
}

@end
