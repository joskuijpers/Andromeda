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

/**
 * @brief A runtime extension representation: JavaScript exports.
 */
@protocol AMDSystemExtension <L8Export>

/// Name of the extension.
@property (readonly) NSString *name;

/// Version of the extension.
@property (readonly) NSNumber *version;

/// Version of the extension in a readable form.
@property (readonly) NSString *versionString;

/// Extension-specific description of functionality.
@property (readonly) NSDictionary *functionalityDescription;

@end

/**
 * @brief A runtime extension representation.
 */
@interface AMDSystemExtension : NSObject <AMDSystemExtension, AMDJSClass>

/**
 * Initialize the extension info.
 *
 * @param name Name of the extension.
 * @param version Version number.
 * @param versionString Human readable version.
 * @param description Custom functionality description.
 * @return self.
 */
- (instancetype)initWithName:(NSString *)name
					 version:(NSNumber *)version
			   versionString:(NSString *)versionString
				 description:(NSDictionary *)description;

@end
