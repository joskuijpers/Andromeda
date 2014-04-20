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

#import "AMDFileSystem.h"
#import "AMDDirectory.h"
#import "AMDFile.h"
#import "AMDRawFile.h"
#import "AMDFileHashing.h"

@implementation AMDFileSystem

+ (void)installIntoContext:(L8Context *)context
{
	context[@"FileSystem"] = [AMDFileSystem class];
	context[@"FileSystem"][@"Directory"] = [AMDDirectory class];
	context[@"FileSystem"][@"RawFile"] = [AMDRawFile class];
	context[@"FileSystem"][@"File"] = [AMDFile class];
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;
	NSArray *contents;

	fileManager = [NSFileManager defaultManager];

	contents = [fileManager contentsOfDirectoryAtPath:path // TODO resolve
									 error:&error];
	if(contents == nil)
		return @[];

	return contents;
}

+ (AMDDirectory *)createDirectoryAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;

	fileManager = [NSFileManager defaultManager];

	if(![fileManager createDirectoryAtPath:path // TODO resolve
		   withIntermediateDirectories:YES
							attributes:nil
								 error:&error])
		return nil;

	return [[AMDDirectory alloc] initWithPath:path];
}

+ (BOOL)removeItemAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;

	fileManager = [NSFileManager defaultManager];

	if(![fileManager removeItemAtPath:path // TODO resolve
							error:&error])
		return NO;

	return YES;
}

+ (BOOL)renameItemAtPath:(NSString *)from toPath:(NSString *)to
{
	NSFileManager *fileManager;
	NSError *error = NULL;

	fileManager = [NSFileManager defaultManager];

	if(![fileManager moveItemAtPath:from // TODO resolve
							 toPath:to // TODO resolve
								error:&error])
		return NO;

	return YES;
}

+ (BOOL)itemExistsAtPath:(NSString *)path
{
	NSFileManager *fileManager;

	fileManager = [NSFileManager defaultManager];

	return [fileManager fileExistsAtPath:path]; // TODO resolve
}

+ (NSString *)md5ForFileAtPath:(NSString *)path
{
	// TODO resolve path
	return [AMDFileHashing md5HashOfFileAtPath:path];
}

+ (NSString *)sha1ForFileAtPath:(NSString *)path
{
	// TODO resolve path
	return [AMDFileHashing sha1HashOfFileAtPath:path];
}

+ (NSString *)sha256ForFileAtPath:(NSString *)path
{
	// TODO resolve path
	return [AMDFileHashing sha256HashOfFileAtPath:path];
}

////////////////////////////

+ (L8Value *)setUpBinding
{
	return [L8Value valueWithObject:[AMDFileSystem class]
						  inContext:[L8Context currentContext]];
}

+ (NSString *)bindingName
{
	return @"fs";
}

+ (NSString *)contentsOfFileAtPath:(NSString *)path
{
	NSError *error;
	NSString *xPath, *data;

	xPath = [[NSBundle mainBundle] pathForResource:[[path lastPathComponent] stringByDeletingPathExtension]
													  ofType:[path pathExtension]];

	data = [NSString stringWithContentsOfFile:xPath
									 encoding:NSUTF8StringEncoding
										error:&error];

	if(error)
		return (NSString *)[NSNull null];

	return data;
}

@end
