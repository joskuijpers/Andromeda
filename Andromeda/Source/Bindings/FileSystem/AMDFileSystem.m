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

@implementation AMDFileSystem

+ (L8Value *)setUpBinding
{
	return [L8Value valueWithObject:[AMDFileSystem class]
						  inContext:[L8Context currentContext]];
}

+ (NSString *)bindingName
{
	return @"fs";
}

+ (NSStringEncoding)stringEncodingForEncoding:(NSString *)encoding
{
	if([encoding isEqualToString:@"utf8"])
		return NSUTF8StringEncoding;
	if([encoding isEqualToString:@"utf16"])
		return NSUTF16StringEncoding;
	if([encoding isEqualToString:@"utf16le"])
		return NSUTF16LittleEndianStringEncoding;
	if([encoding isEqualToString:@"utf16be"])
		return NSUTF16BigEndianStringEncoding;
	if([encoding isEqualToString:@"ascii"])
		return NSASCIIStringEncoding;
	if([encoding isEqualToString:@"utf32"])
		return NSUTF32StringEncoding;
	if([encoding isEqualToString:@"utf32le"])
		return NSUTF32LittleEndianStringEncoding;
	if([encoding isEqualToString:@"utd32be"])
		return NSUTF32BigEndianStringEncoding;
	return 0;
}

#pragma mark - File System structure operations

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;
	NSArray *contents;

	fileManager = [NSFileManager defaultManager];
	path = [path stringByExpandingTildeInPath];

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
	path = [path stringByExpandingTildeInPath];

	if(![fileManager createDirectoryAtPath:path // TODO resolve
		   withIntermediateDirectories:YES
							attributes:nil
								 error:&error])
		return nil;

//	return [[AMDDirectory alloc] initWithPath:path];
	return nil;
}

+ (BOOL)removeItemAtPath:(NSString *)path
{
	NSFileManager *fileManager;
	NSError *error = NULL;

	fileManager = [NSFileManager defaultManager];
	path = [path stringByExpandingTildeInPath];

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
	from = [from stringByExpandingTildeInPath];
	to = [to stringByExpandingTildeInPath];

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
	path = [path stringByExpandingTildeInPath];

	return [fileManager fileExistsAtPath:path];
}

#pragma mark - File operations

+ (L8Value *)contentsOfFileAtPath:(NSString *)path withEncoding:(NSString *)encoding
{
	NSError *error;
	id data;

	path = [path stringByExpandingTildeInPath];
	if(![path hasPrefix:@"/"]) {
		NSString *ext = [path pathExtension];
		path = [[path lastPathComponent] stringByDeletingPathExtension];
		path = [[NSBundle mainBundle] pathForResource:path ofType:ext];
	}

	if([encoding isEqualToString:@"bin"]) {
		data = [NSData dataWithContentsOfFile:path
									  options:NSDataReadingUncached
										error:&error];
	} else {
		data = [NSString stringWithContentsOfFile:path
										 encoding:[self stringEncodingForEncoding:encoding]
											error:&error];
	}

	if(error)
		return [L8Value valueWithNullInContext:[L8Context currentContext]];

	return [L8Value valueWithObject:data inContext:[L8Context currentContext]];
}

+ (BOOL)writeToFile:(NSString *)path data:(L8Value *)data withEncoding:(NSString *)encoding
{
	// TODO
	return NO;
}

@end
