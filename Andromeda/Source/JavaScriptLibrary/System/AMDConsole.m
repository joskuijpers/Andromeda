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

#import "AMDConsole.h"
#import <L8Framework/L8.h>

@implementation AMDConsole

- (void)log:(NSString *)string
{
	NSArray *arguments;

	arguments = [L8Context currentArguments];
	if([arguments count] == 0)
		return;

	// If the string does not contain any formatting elements,
	// assume the function just received a variable number of objects to log
	if([(L8Value *)arguments[0] isString]
	   && [[arguments[0] toString] rangeOfString:@"%"].location != NSNotFound) {
		NSLog(@"To Implement: printf-like formatting!");
		fprintf(stdout,"[LOG ] %s\n",[[arguments[0] toString] UTF8String]);
	} else {
		// TODO Concat. with spaces instead
		for(L8Value *arg in arguments)
			fprintf(stdout,"[LOG ] %s\n",[[arg toString] UTF8String]);
	}
}

- (void)error:(NSString *)string
{
	fprintf(stderr,"[ERR ] %s\n",[string UTF8String]);
}

@end
