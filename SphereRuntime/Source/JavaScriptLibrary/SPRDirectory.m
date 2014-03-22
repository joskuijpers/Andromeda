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

#import "SPRDirectory.h"
#import "SPRFileSystem.h"

@implementation SPRDirectory

@synthesize path=_path;

- (instancetype)init
{
	NSArray *arguments = [L8Context currentArguments];

	if(arguments.count < 1)
		return nil;

	return [self initWithPath:[(L8Value *)arguments[0] toString]];
}

- (instancetype)initWithPath:(NSString *)path
{
	self = [super init];
	if(self) {
		_path = [path copy];

		// TODO: use some resource manager to find the correct path
	}
	return self;
}

- (NSArray *)contents
{
	return [SPRFileSystem contentsOfDirectoryAtPath:_path];
}

- (BOOL)renameTo:(NSString *)newName
{
	if SPR_LIKELY ([SPRFileSystem renameItemAtPath:_path
											toPath:newName]) {
		_path = newName;
		return YES;
	}

	return NO;
}

- (BOOL)remove
{
	return [SPRFileSystem removeItemAtPath:_path];
}

@end

