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

#import "SPRNetwork.h"
#import "SPRBonjour.h"
#import "SPRSocket.h"

@implementation SPRNetwork

+ (void)installIntoContext:(L8Context *)context
{
	context[@"Network"] = [SPRNetwork class];
	context[@"Network"][@"Bonjour"] = [SPRBonjour class];
	context[@"Network"][@"Bonjour"][@"Peer"] = [SPRBonjourPeer class];
	context[@"Network"][@"Socket"] = [SPRSocket class];

#if 0
	NSDictionary *property;
	// localName property on Network
	property = @{JSPropertyDescriptorGetKey: ^{
					 return [SPRNetwork localName];
				 }};
	[context[@"Network"] defineProperty:@"localName"
							 descriptor:property];

	// localAddress property on Network
	property = @{JSPropertyDescriptorGetKey: ^{
					 return [SPRNetwork localAddress];
				 }};
	[context[@"Network"] defineProperty:@"localAddress"
							 descriptor:property];
#endif
}

+ (NSString *)localName
{
	// TODO: there are multiple names. Which one to use?
	return [[NSHost currentHost] name];
}

+ (NSString *)localAddress
{
	// TODO: There are multiple addresses, including:
	// local, loopback, ipv4 and ipv6. Which one to use?
	return [[NSHost currentHost] address];
}

+ (BOOL)listenOnPort:(uint16_t)port
{
	NSLog(@"Go listen on port %hu",port);

	return NO;
}

@end
