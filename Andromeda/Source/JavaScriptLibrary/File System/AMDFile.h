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

#import "AMDJSClass.h"

@class AMDFile;

/**
 * @brief A key-value coding file: JavaScript exports.
 */
@protocol AMDFile <L8Export>

/// Number of entries in the file
@property (nonatomic,readonly) size_t size;

/// Path of the file
@property (readonly) NSString *path;

/// Get all the keys in the file.
@property (readonly) NSString *keys;

/**
 * Open a file.
 *
 * @!param path Path of the file.
 * @return An initialized AMDFile object or nil on failure.
 */
- (instancetype)init;

/**
 * Get the value for specified key, or the default value
 * if the value is not found.
 *
 * @param key The key to look for.
 * @param def The value used when no key is found.
 * @return The value for given key, or the default.
 */
L8_EXPORT_AS(read,
- (NSString *)readKey:(NSString *)key withDefault:(NSString *)def
);

/**
 * Set a key-value combination.
 *
 * @param key The key.
 * @param value The value.
 */
L8_EXPORT_AS(write,
- (void)writeKey:(NSString *)key value:(NSString *)value
);

/**
 * Get whether the file contains specified key.
 * 
 * @param key The key to look for.
 * @return YES when the key is in the file, NO otherwise.
 */
- (BOOL)hasKey:(NSString *)key;

/**
 * Create the MD5 hash of the file
 *
 * @return A string with the MD5 hash.
 */
- (NSString *)md5hash;

/**
 * Create the SHA1 hash of the file
 *
 * @return A string with the SHA1 hash.
 */
- (NSString *)sha1hash;

/**
 * Create the SHA256 hash of the file
 *
 * @return A string with the SHA256 hash.
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

/**
 * Rename or move the file.
 *
 * @param newName The new path of the file.
 * @return YES on success, NO on failure.
 */
L8_EXPORT_AS(rename,
- (BOOL)renameTo:(NSString *)newName
);

/**
 * Remove the file from the file system.
 *
 * @return YES on success, NO on failure.
 */
- (BOOL)remove;

@end

/**
 * @brief A key-value coding file.
 */
@interface AMDFile : NSObject <AMDFile, AMDJSClass>

/**
 * Open a file.
 *
 * @param path Path of the file.
 * @return An initialized AMDFile object or nil on failure.
 */
- (instancetype)initWithPath:(NSString *)path AMD_DESIGNATED_INITIALIZER;

@end
