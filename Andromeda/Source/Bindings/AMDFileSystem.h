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
#import "AMDBinding.h"

@class AMDDirectory, L8Value;

/**
 * @brief A class for manipulating the native file system: JavaScript exports.
 */
@protocol AMDFileSystem <L8Export>

/**
 * @section File System structure operations.
 */

/**
 * Get a list of items at specified path.
 *
 * @param path Path of the directory to look in.
 * @return An array with the names of each item in the directory.
 */
L8_EXPORT_AS(list,
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path
);

/**
 * Create a directory at given path.
 *
 * If the directory already exists, nil will be returned.
 *
 * @param path Path of the new directory.
 * @return An AMDDirectory initialized with the path on
 * success, or nil on failure.
 */
L8_EXPORT_AS(mkdir,
+ (AMDDirectory *)createDirectoryAtPath:(NSString *)path
);

/**
 * Remove an item on the file system.
 *
 * Directories will be removed recursively. This action can't be undone.
 *
 * @param path Path of the item to remove.
 * @return YES on success, NO on failure.
 */
L8_EXPORT_AS(remove,
+ (BOOL)removeItemAtPath:(NSString *)path
);

/**
 * Rename or move an item.
 *
 * @param from The path of the old item.
 * @param to The new path of the item.
 * @return YES on success, NO on failure.
 */
L8_EXPORT_AS(rename,
+ (BOOL)renameItemAtPath:(NSString *)from toPath:(NSString *)to
);

/**
 * Check whether an item at specified path exists.
 *
 * @param path The path to check.
 * @return YES if the item exists, NO otherwise.
 */
L8_EXPORT_AS(exists,
+ (BOOL)itemExistsAtPath:(NSString *)path
);

/**
 * @section File operations.
 */

/**
 * Read a file into memory.
 *
 * @param path Path of the file.
 * @param encoding Encoding of the file. [utf8,utf16,utf16le,utf16be,bin]
 * @return A binary data object if 'bin', a string otherwise.
 */
L8_EXPORT_AS(readFile,
+ (L8Value *)contentsOfFileAtPath:(NSString *)path withEncoding:(NSString *)encoding
);

/**
 * Write to a file, overwriting the contents.
 *
 * @param path Path of the file.
 * @param data Data for the file.
 * @param encoding Encoding for the file. [utf8,utf16,utf16le,utf16be,bin]
 * @return YES on success, NO on failure.
 */
L8_EXPORT_AS(writeFile,
+ (BOOL)writeToFile:(NSString *)path data:(L8Value *)data withEncoding:(NSString *)encoding
);

@end

/**
 * @brief A class for manipulating the native file system.
 */
@interface AMDFileSystem : NSObject <AMDFileSystem, AMDBinding>

@end
