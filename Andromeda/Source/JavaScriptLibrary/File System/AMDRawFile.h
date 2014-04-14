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

@class AMDRawFile, AMDByteArray;

/**
 * @brief A file with raw data: JavaScript exports.
 */
@protocol AMDRawFile <L8Export>

/// Path of the file
@property (readonly) NSString *path;

/// Size of the file
@property (nonatomic,readonly) size_t size;

/// Seek position within the file
@property (nonatomic,assign) size_t position;

/// Whether the file is writeable
@property (readonly,getter=isWriteable) BOOL writable;

/**
 * Opens a file.
 *
 * @!param path Path of the file.
 * @!param writeable Boolean containing the writeability of the file:
 * YES to open writeable, NO to open in read-only mode.
 * @return An initialized AMDRawFile object or nil on failure.
 */
- (instancetype)init;

/**
 * Read data from the file.
 *
 * @param len Length of the data to read.
 * @return A byte array containing the data.
 */
L8_EXPORT_AS(read,
- (AMDByteArray *)readBytes:(size_t)len
);

/**
 * Write data to the file at current seek position.
 *
 * @param byteArray The data to write.
 */
L8_EXPORT_AS(write,
- (void)writeByteArray:(AMDByteArray *)byteArray
);

/**
 * Write all data to the output
 */
- (void)flush;

/**
 * Close the file handle
 */
- (void)close;

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
 * @brief A file with raw data.
 */
@interface AMDRawFile : NSObject <AMDRawFile, AMDJSClass>

/**
 * Opens a file.
 *
 * @param path Path of the file.
 * @param writeable Boolean containing the writeability of the file:
 * YES to open writeable, NO to open in read-only mode.
 * @return An initialized AMDRawFile object or nil on failure.
 */
- (instancetype)initWithPath:(NSString *)path
				   writeable:(BOOL)writeable;

@end
