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

#import "NSData+AMDHashing.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (AMDHashing)

- (NSString *)md5
{
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	char hash[2 * sizeof(digest) + 1];

    CC_MD5(self.bytes, (unsigned int)self.length, digest);

	for(size_t i = 0; i < sizeof(digest); ++i)
		snprintf(hash + (2 * i), 3, "%02x", (int)digest[i]);
	hash[2 * sizeof(digest)] = '\0';

	return [NSString stringWithUTF8String:hash];
}

- (NSString *)sha1
{
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];
	char hash[2 * sizeof(digest) + 1];

    CC_SHA1(self.bytes, (unsigned int)self.length, digest);

	for(size_t i = 0; i < sizeof(digest); ++i)
		snprintf(hash + (2 * i), 3, "%02x", (int)digest[i]);
	hash[2 * sizeof(digest)] = '\0';

	return [NSString stringWithUTF8String:hash];
}

- (NSString *)sha256
{
	unsigned char digest[CC_SHA256_DIGEST_LENGTH];
	char hash[2 * sizeof(digest) + 1];

    CC_SHA256(self.bytes, (unsigned int)self.length, digest);

	for(size_t i = 0; i < sizeof(digest); ++i)
		snprintf(hash + (2 * i), 3, "%02x", (int)digest[i]);
	hash[2 * sizeof(digest)] = '\0';

	return [NSString stringWithUTF8String:hash];
}

@end
