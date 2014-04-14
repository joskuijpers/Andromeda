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

/**
 * @brief A directory in the native file system: JavaScript exports.
 */
@protocol SPRDirectory <L8Export>

/// Path of the directory.
@property (readonly) NSString *path;

/**
 * Open a directory.
 *
 * @!param path Path of the directory.
 * @return An initialized SPRDirectory object or nil on failure.
 */
- (instancetype)init;

/**
 * Get a list of items in the directory.
 *
 * @return An array with the names of each item in the directory.
 */
L8_EXPORT_AS_NO_ARGS(list,
- (NSArray *)contents
);

/**
 * Rename or move the directory.
 *
 * @param newName The new path of the directory.
 * @return YES on success, NO on failure.
 */
L8_EXPORT_AS(rename,
- (BOOL)renameTo:(NSString *)newName
);

/**
 * Remove the directory and its contents from the file system.
 *
 * @return YES on success, NO on failure.
 */
- (BOOL)remove;

@end

/**
 * @brief A directory in the native file system.
 */
@interface SPRDirectory : NSObject <SPRDirectory,SPRJSClass>

/**
 * Open a directory.
 *
 * @param path Path of the directory.
 * @return An initialized SPRDirectory object or nil on failure.
 */
- (instancetype)initWithPath:(NSString *)path;

@end
