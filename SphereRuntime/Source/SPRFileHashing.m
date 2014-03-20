/*
 * Copyright (c) 2010-2014 Joel Lopes Da Silva. All rights reserved.
 * Changed to fit style by Jos Kuijpers, 2014.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SPRFileHashing.h"
#import <CommonCrypto/CommonDigest.h>


typedef int (*spr_hash_init_func_t)   (uint8_t *hashObjectPointer[]);
typedef int (*spr_hash_update_func_t) (uint8_t *hashObjectPointer[], const void *data, CC_LONG len);
typedef int (*spr_hash_final_func_t)  (unsigned char *md, uint8_t *hashObjectPointer[]);

typedef struct {
    spr_hash_init_func_t init_function;
    spr_hash_update_func_t update_function;
    spr_hash_final_func_t final_function;
    size_t digest_length;
    uint8_t **hash_object_pointer;
} spr_file_hash_computation_context_t;

#define FileHashComputationContextInitialize(context, algorithm_name)						\
	CC_##algorithm_name##_CTX hashObject;													\
	context.init_function       = (spr_hash_init_func_t)&CC_##algorithm_name##_Init;		\
	context.update_function     = (spr_hash_update_func_t)&CC_##algorithm_name##_Update;	\
	context.final_function      = (spr_hash_final_func_t)&CC_##algorithm_name##_Final;		\
	context.digest_length       = CC_##algorithm_name##_DIGEST_LENGTH;						\
	context.hash_object_pointer = (uint8_t **)&hashObject;

@implementation SPRFileHashing

+ (NSString *)hashOfFileAtPath:(NSString *)filePath
		withComputationContext:(spr_file_hash_computation_context_t *)context
{
	NSString *result = nil;
	CFURLRef fileURL;
	CFReadStreamRef readStream;
	BOOL didSucceed;

	fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
											(CFStringRef)filePath,
											kCFURLPOSIXPathStyle,
											false);

	readStream = fileURL?CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL):NULL;
	didSucceed = readStream?CFReadStreamOpen(readStream):NO;

	if(didSucceed) {
		size_t chunkSizeForReadingData;
		BOOL hasMoreData;
		unsigned char digest[context->digest_length];

		// Use default value for the chunk size for reading data.
		chunkSizeForReadingData = 4096;

		// Initialize the hash object
		(*context->init_function)(context->hash_object_pointer);

		// Feed the data to the hash object.
		hasMoreData = YES;
		while (hasMoreData) {
			uint8_t buffer[chunkSizeForReadingData];
			CFIndex readBytesCount;

			readBytesCount = CFReadStreamRead(readStream, buffer, sizeof(buffer));
			if (readBytesCount == -1)
				break;
			else if (readBytesCount == 0)
				hasMoreData = NO;
			else
				(*context->update_function)(context->hash_object_pointer,
											(const void *)buffer,
											(CC_LONG)readBytesCount);
		}

		// Compute the hash digest
		(*context->final_function)(digest, context->hash_object_pointer);

		// Close the read stream.
		CFReadStreamClose(readStream);

		// Proceed if the read operation succeeded.
		if(!hasMoreData) {
			char hash[2 * sizeof(digest) + 1];
			for(size_t i = 0; i < sizeof(digest); ++i)
				snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
			hash[2 * sizeof(digest)] = '\0';
			result = [NSString stringWithUTF8String:hash];
		}

	}

	if(readStream)
		CFRelease(readStream);
	if(fileURL)
		CFRelease(fileURL);

	return result;
}

+ (NSString *)md5HashOfFileAtPath:(NSString *)path
{
	spr_file_hash_computation_context_t context;
    FileHashComputationContextInitialize(context, MD5);

    return [self hashOfFileAtPath:path
		   withComputationContext:&context];
}

+ (NSString *)sha1HashOfFileAtPath:(NSString *)path
{
	spr_file_hash_computation_context_t context;
    FileHashComputationContextInitialize(context, SHA1);

    return [self hashOfFileAtPath:path
		   withComputationContext:&context];
}

+ (NSString *)sha256HashOfFileAtPath:(NSString *)path
{
	spr_file_hash_computation_context_t context;
    FileHashComputationContextInitialize(context, SHA256);

    return [self hashOfFileAtPath:path
		   withComputationContext:&context];
}


@end