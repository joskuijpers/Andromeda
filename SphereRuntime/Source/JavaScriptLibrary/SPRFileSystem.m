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

#import "SPRFileSystem.h"
#import "SPRDirectory.h"
#import "SPRFile.h"
#import "SPRRawFile.h"
#import "SPRFileHashing.h"

@implementation SPRFileSystem

+ (void)installIntoContext:(L8Context *)context
{
	context[@"FileSystem"] = [SPRFileSystem class];
	context[@"FileSystem"][@"Directory"] = [SPRDirectory class];
	context[@"FileSystem"][@"RawFile"] = [SPRRawFile class];
	context[@"FileSystem"][@"File"] = [SPRFile class];
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

+ (SPRDirectory *)createDirectoryAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;

	fileManager = [NSFileManager defaultManager];

	if(![fileManager createDirectoryAtPath:path // TODO resolve
		   withIntermediateDirectories:YES
							attributes:nil
								 error:&error])
		return nil;

	return [[SPRDirectory alloc] initWithPath:path];
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
	return [SPRFileHashing md5HashOfFileAtPath:path];
}

+ (NSString *)sha1ForFileAtPath:(NSString *)path
{
	// TODO resolve path
	return [SPRFileHashing sha1HashOfFileAtPath:path];
}

+ (NSString *)sha256ForFileAtPath:(NSString *)path
{
	// TODO resolve path
	return [SPRFileHashing sha256HashOfFileAtPath:path];
}

@end
