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

#import "SPRJSClass.h"

@class SPRByteArray;

/**
 * @brief Typed array for bytes: JavaScript exports.
 */
@protocol SPRByteArray <L8Export>

/// The length of the byte array.
@property (nonatomic,readonly) size_t length;

/**
 * Create a new byte array.
 *
 * @!param size Size of the new byte array. [optional]
 * @!param string String used to create the byte array. [optional]
 * @return A new byte array.
 */
- (instancetype)init;

/**
 * Concatenate with another byte array.
 *
 * @param byteArray The byte array to append.
 * @return A byte array with the other byte array appended.
 */
L8_EXPORT_AS(concat,
- (SPRByteArray *)byteArrayByAppendingByteArray:(SPRByteArray *)byteArray
);

/**
 * Get a sub-byte array with specified range.
 *
 * @param start Start of the range.
 * @param end End of the range.
 * @return A byte array, or nil on failure.
 */
L8_EXPORT_AS(slice,
- (SPRByteArray *)subArrayWithStart:(size_t)start end:(size_t)end
);

/**
 * Get a string representation of the raw data.
 *
 * @return A string, or nil on failure.
 */
- (NSString *)makeString;

/**
 * Create the MD5 hash of the byte array.
 *
 * @return A string with the MD5 hash.
 */
- (NSString *)md5hash;

/**
 * Create the SHA1 hash of the byte array.
 *
 * @return A string with the SHA1 hash.
 */
- (NSString *)sha1hash;

/**
 * Create the SHA256 hash of the byte array.
 *
 * @return A string with the SHA256 hash.
 */
- (NSString *)sha256hash;

@end

/**
 * @brief Typed array for bytes.
 */
@interface SPRByteArray : NSObject <SPRByteArray, SPRJSClass>

/**
 * Create a new byte array with contents.
 *
 * @param data An NSData object.
 * @return A new byte array.
 */
- (instancetype)initWithData:(NSData *)data;

/**
 * Get the raw data in this byte array.
 *
 * @return The raw data in an NSMutableData object.
 */
- (NSMutableData *)data;

@end
