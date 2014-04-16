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

#import "AMDProcess.h"

#import <L8Framework/L8.h>

@implementation AMDProcess

@synthesize mainModule=_mainModule;

- (L8Value *)runInThisContext:(NSString *)code withOptions:(NSDictionary *)options
{
	L8Context *context;
	L8Value *result;
	NSString *filename;

	filename = options[@"filename"];
	if(filename == nil)
		filename = @"";

	context = [L8Context currentContext];
	result = [context evaluateScript:code withName:filename];

	return result;
}

- (L8Value *)bindingForBuiltin:(NSString *)builtin
{
	return nil;
}

- (NSString *)contentsOfFileAtPath:(NSString *)path
{
	NSString *xPath = [[NSBundle mainBundle] pathForResource:[[path lastPathComponent] stringByDeletingPathExtension]
													  ofType:[path pathExtension]];

	return [NSString stringWithContentsOfFile:xPath encoding:NSUTF8StringEncoding error:NULL];
}

@end
