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

#import "AMDAppDelegate.h"

#import "AMDJSClass.h"
#import "AMDConsole.h"
#import "AMDGraphicsView.h"

void load_bundle_script(L8Context *context, NSString *name);

@implementation AMDAppDelegate {
	L8Context *_javaScriptContext;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_javaScriptContext = [[L8Context alloc] init];

	[_javaScriptContext executeBlockInContext:^(L8Context *context) {
		context[@"console"] = [[AMDConsole alloc] init];
		
		spr_install_js_lib(context);

		load_bundle_script(context, @"test");

		if(![context.globalObject hasProperty:@"Game"])
			NSLog(@"No game found.");
		else {
			L8Value *game = context[@"Game"];

			[game invokeMethod:@"init" withArguments:@[]];

			[NSTimer scheduledTimerWithTimeInterval:1.0/2.0
											 target:self
										   selector:@selector(doLoop:)
										   userInfo:context
											repeats:YES];
		}
	}];
}

- (void)doLoop:(NSTimer *)timer
{
	L8Context *context = timer.userInfo;

	[context executeBlockInContext:^(L8Context *context) {
		[context[@"Game"] invokeMethod:@"loop" withArguments:@[]];
	}];
}

@end

void load_bundle_script(L8Context *context, NSString *name)
{
	@try {
		[context loadScriptAtPath:[[NSBundle mainBundle] pathForResource:name ofType:@"js"]];
	} @catch(id ex) {
		printf("[EXC ] %s\n",[[ex toString] UTF8String]);
	}
}

@interface L8Exception (Ext)
- (NSString *)toString;
@end

@implementation L8Exception (Ext)

- (NSString *)toString
{
	return [self description];
}

@end
