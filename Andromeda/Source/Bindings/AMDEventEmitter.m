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

#import "AMDEventEmitter.h"

#import <L8Framework/L8.h>

@implementation AMDEventEmitter {
	NSMutableDictionary *_eventCallbacks;
}

+ (L8Value *)setUpBinding
{
	L8Value *wrapper;

	wrapper = [L8Value valueWithNewObjectInContext:[L8Context currentContext]];
	wrapper[@"EventEmitter"] = [AMDEventEmitter class];

	return wrapper;
}

+ (NSString *)bindingName
{
	return @"event";
}

- (id)init
{
    self = [super init];
    if AMD_LIKELY(self) {
		_eventCallbacks = [[NSMutableDictionary alloc] init];
	}

    return self;
}

- (void)triggerEvent:(NSString *)event withArguments:(NSArray *)arguments
{
	NSArray *listeners;

	listeners = _eventCallbacks[event];
	if AMD_UNLIKELY(listeners == nil)
		return;

	for(L8Value *function in listeners) {
		if(![function isFunction])
			continue;

		dispatch_async(dispatch_get_main_queue(), ^{
			[function.context executeBlockInContext:^(L8Context *context) {
				@try {
					[function callWithArguments:arguments];
				} @catch(id exc) {
					fprintf(stderr,"[EXC ] %s\n",[[exc description] UTF8String]);
				}
			}];
		});
	}
}

- (void)addEventListener:(NSString *)event function:(L8Value *)function
{
	NSMutableArray *listeners;

	if AMD_UNLIKELY(![function isFunction])
		return;

	listeners = _eventCallbacks[event];
	if(listeners == nil) {
		listeners = [NSMutableArray arrayWithCapacity:1];
		_eventCallbacks[event] = listeners;
	}

	[listeners addObject:function];
}

- (void)removeEventListener:(NSString *)event function:(L8Value *)function
{
	NSMutableArray *listeners;

	if AMD_UNLIKELY(![function isFunction])
		return;

	listeners = _eventCallbacks[event];
	[listeners removeObject:function];
}

- (void)removeAllEventListeners:(NSString *)event
{
	NSMutableArray *listeners;

	if(event != nil) {
		listeners = _eventCallbacks[event];
		[listeners removeAllObjects];
	} else
		[_eventCallbacks removeAllObjects];
}

@end
