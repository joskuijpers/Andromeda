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

#import "AMDBinding.h"
#import <L8Framework/L8.h>

/**
 * @brief ArrayBuffer utilitiy functions: JavaScript exports.
 */
@protocol AMDArrayBuffer <L8Export>

/**
 * Create a string from an ArrayBuffer.
 *
 * @param arrayBuffer The ArrayBuffer to covert.
 * @param encoding The encoding to use.
 * @return The encoded string.
 */
L8_EXPORT_AS(stringFromArrayBuffer,
+ (NSString *)stringFromArrayBuffer:(L8ArrayBuffer *)arrayBuffer
						   encoding:(NSString *)encoding
							 offset:(NSNumber *)offset
								end:(NSNumber *)end
);

/**
 * Create an ArrayBuffer from a string.
 *
 * @param string The string to covert.
 * @param encoding The encoding to use.
 * @return The encoded string.
 */
L8_EXPORT_AS(arrayBufferFromString,
+ (L8ArrayBuffer *)arrayBufferFromString:(NSString *)string
								encoding:(NSString *)encoding
								  offset:(NSNumber *)offset
									 end:(NSNumber *)end
);

/**
 * Copy bytes from one ArrayBuffer to another ArrayBuffer.
 *
 * @param sourceBuffer Buffer to copy from.
 * @param sourceStart Offset in the source buffer.
 * @param sourceEnd End of the slice to copy.
 * @param targetBuffer Buffer to copy to.
 * @param targetStart Offset in the target buffer.
 * @return The number of bytes copied.
 */
L8_EXPORT_AS(copy,
+ (NSNumber *)copyBytesFromBuffer:(L8ArrayBuffer *)sourceBuffer
						   offset:(NSNumber *)sourceStart
							  end:(NSNumber *)sourceEnd
						 toBuffer:(L8ArrayBuffer *)targetBuffer
						   offset:(NSNumber *)targetStart
);

@end

/**
 * @brief ArrayBuffer utilitiy functions.
 */
@interface AMDArrayBuffer : NSObject <AMDBinding, AMDArrayBuffer>

@end
