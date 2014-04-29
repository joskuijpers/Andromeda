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

#import "AMDEngine.h"
#import "AMDBinding.h"

#import <L8Framework/L8.h>
#include <objc/runtime.h>

@implementation AMDEngine {
	NSMutableDictionary *_bindingCache;
	NSDictionary *_bindings;
}

@synthesize mainModule=_mainModule, version=_version, versions=_versions;

- (instancetype)init
{
	self = [super init];
	if AMD_LIKELY(self) {
		_bindingCache = [[NSMutableDictionary alloc] init];
		_bindings = [self findAllBindings];

		// _extensions = @{@"sqlite":[[AMDEXTSQLite alloc] init]};
		_version = @(10000); // TODO get from some build setting
		_versions = @{@"node" : @"1.0.0",
					  @"pegasus" : @"0.1",
					  @"L8Framework" : @"0.1",
					  @"v8" : @"3.24.40"};
	}
	return self;
}

#pragma mark - Bindings

- (NSDictionary *)findAllBindings
{
	Class *classes;
	unsigned int count;
	NSMutableDictionary *result;

	result = [NSMutableDictionary dictionary];

	classes = objc_copyClassList(&count);
	for(unsigned int i = 0; i < count; i++) {
		if(!class_conformsToProtocol(classes[i], @protocol(AMDBinding)))
			continue;

		result[[classes[i] bindingName]] = classes[i];
	}

	free(classes);

	return result;
}

- (L8Value *)bindingForBuiltin:(NSString *)builtin
{
	L8Value *binding;

	binding = _bindingCache[builtin];
	if(binding != nil)
		return binding;

	if(_bindings[builtin]) {
		Class<AMDBinding> bindingClass;

		bindingClass = _bindings[builtin];

		binding = [bindingClass setUpBinding];

		_bindingCache[builtin] = binding;

		return binding;
	} else
		[[L8Value valueWithNewErrorFromMessage:[NSString stringWithFormat:@"No such binding '%@'",builtin]
									 inContext:[L8Context currentContext]] throwValue];

	return nil;
}

#pragma mark - Exiting the process

- (void)abortWithMessage:(NSString *)message
{

}

- (void)exit
{
	[[NSApplication sharedApplication] terminate:nil];
}

- (void)restart
{

}

#pragma mark - Utilities

- (void)dispatch:(L8Value *)function
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[function.context executeBlockInContext:^(L8Context *context) {
			@try {
				[function callWithArguments:@[]];
			} @catch(id exc) {
				fprintf(stderr,"[EXC ] %s\n",[[exc description] UTF8String]);
			}
		}];
	});
}

#pragma mark - Debugging

- (void)garbageCollect
{
	[[[L8Context currentContext] virtualMachine] runGarbageCollector];
}

@end
