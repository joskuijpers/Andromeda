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

#import "AMDArrayBuffer.h"
#import "AMDFileSystem.h"
#import "NSData+AMDAdditions.h"

@implementation AMDArrayBuffer

+ (L8Value *)setUpBinding
{
	return [L8Value valueWithObject:[AMDArrayBuffer class]
						  inContext:[L8Context currentContext]];
}

+ (NSString *)bindingName
{
	return @"arraybuffer";
}

+ (NSString *)stringFromArrayBuffer:(L8ArrayBuffer *)arrayBuffer
						   encoding:(NSString *)encoding
							 offset:(NSNumber *)offset
								end:(NSNumber *)end
{
	NSData *data;
	size_t loffset, lend;
	NSStringEncoding eEncoding;

	loffset = offset.longLongValue;
	lend = end == nil ? arrayBuffer.length : end.unsignedLongValue;

	if(loffset > arrayBuffer.length)
		return nil;
	if(lend > arrayBuffer.length)
		return nil;

	data = [NSData dataWithBytesNoCopy:(uint8_t *)arrayBuffer.buffer + loffset
								length:lend - loffset + 1
						  freeWhenDone:NO];

	eEncoding = [AMDFileSystem stringEncodingForEncoding:encoding];
	if(eEncoding == 0) {
		// Custom encodings
		if([encoding isEqualToString:@"base64"]) {
			return [data base64EncodedStringWithOptions:0];
		} else if([encoding isEqualToString:@"hex"]) {
			return [data hexadecimalString];
		} else
			@throw [L8TypeErrorException exceptionWithMessage:@"No such encoding."];
	}

	return [[NSString alloc] initWithData:data
								 encoding:eEncoding];
}

+ (L8ArrayBuffer *)arrayBufferFromString:(NSString *)string
								encoding:(NSString *)encoding
								  offset:(NSNumber *)offset
									 end:(NSNumber *)end
{
	NSData *data;
	NSStringEncoding eEncoding;

	eEncoding = [AMDFileSystem stringEncodingForEncoding:encoding];
	if(eEncoding == 0) {
		// Custom encodings
		if([encoding isEqualToString:@"base64"]) {
			data = [NSData alloc];
			data = 	[data initWithBase64EncodedString:string
											  options:NSDataBase64DecodingIgnoreUnknownCharacters];
		} else if([encoding isEqualToString:@"hex"]) {
			// TODO hex encoding
			return nil;
		} else
			@throw [L8TypeErrorException exceptionWithMessage:@"No such encoding."];
	} else
		data = [string dataUsingEncoding:eEncoding];

	return [[L8ArrayBuffer alloc] initWithData:data];
}

+ (NSNumber *)copyBytesFromBuffer:(L8ArrayBuffer *)sourceBuffer
						   offset:(NSNumber *)sourceStart
							  end:(NSNumber *)sourceEnd
						 toBuffer:(L8ArrayBuffer *)targetBuffer
						   offset:(NSNumber *)targetStart
{
	size_t targetLength = targetBuffer.length;

	size_t toCopy = MIN(MIN(sourceEnd.unsignedLongValue - sourceStart.unsignedLongValue,
							targetLength - targetStart.unsignedLongValue),
						sourceBuffer.length - sourceStart.unsignedLongValue);

	memmove(targetBuffer.buffer + targetStart.unsignedLongValue,
			sourceBuffer.buffer + sourceStart.unsignedLongValue,
			toCopy);

	return @(toCopy);
}

@end
