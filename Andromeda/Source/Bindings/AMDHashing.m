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

#import "AMDHashing.h"
#import "NSString+AMDHashing.h"
#import "NSData+AMDHashing.h"
#import "AMDFileHashing.h"

#import <L8Framework/L8.h>

@implementation AMDHashing

+ (L8Value *)setUpBinding
{
	return [L8Value valueWithObject:[AMDHashing class]
						  inContext:[L8Context currentContext]];
}

+ (NSString *)bindingName
{
	return @"hashing";
}

+ (NSString *)dataHashOfData:(L8Value *)data withAlgorithm:(NSString *)algorithm
{
	id dataObject;

	if([data isString])
		dataObject = [data toString];
	else
		@throw @"Not Implemented";

	if([algorithm isEqualToString:@"md5"])
		return [dataObject md5];
	if([algorithm isEqualToString:@"sha1"])
		return [dataObject sha1];
	if([algorithm isEqualToString:@"sha256"])
		return [dataObject sha256];

	return nil;
}

+ (NSString *)fileHashOfFileAtPath:(NSString *)path withAlgorithm:(NSString *)algorithm
{
	path = [path stringByExpandingTildeInPath];

	if([algorithm isEqualToString:@"md5"])
		return [AMDFileHashing md5HashOfFileAtPath:path];
	if([algorithm isEqualToString:@"sha1"])
		return [AMDFileHashing sha1HashOfFileAtPath:path];
	if([algorithm isEqualToString:@"sha256"])
		return [AMDFileHashing sha256HashOfFileAtPath:path];

	return nil;
}

@end
