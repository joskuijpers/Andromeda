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

@class SPRFile;

/**
 * A key-value coding file
 */
@protocol SPRFile <L8Export>

/// Number of entries in the file
@property (nonatomic,readonly) size_t size;

/// Path of the file
@property (readonly) NSString *path;

- (instancetype)init;

L8_EXPORT_AS(read,
- (NSString *)readKey:(NSString *)key withDefault:(NSString *)def
);

L8_EXPORT_AS(write,
- (void)writeKey:(NSString *)key value:(NSString *)value
);

- (NSArray *)keys;

/**
 * Creates an MD5 hash from the file
 */
- (NSString *)md5hash;

/**
 * Creates an SHA1 hash from the file
 */
- (NSString *)sha1hash;

/**
 * Creates an SHA256 hash from the file
 */
- (NSString *)sha256hash;

/**
 * Writes all data to the output
 */
- (void)flush;

/**
 * Closes the file handle
 */
- (void)close;

L8_EXPORT_AS(rename,
- (void)renameTo:(NSString *)newName
);

- (void)remove;

@end

/**
 * A key-value coding file
 */
@interface SPRFile : NSObject <SPRFile, SPRJSClass>

- (instancetype)initWithPath:(NSString *)path;

@end
