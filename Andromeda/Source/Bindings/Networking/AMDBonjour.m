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

#import "AMDBonjour.h"
#import "AMDSocket.h"

#import <L8Framework/L8.h>

@interface AMDBonjour () <NSNetServiceDelegate, NSNetServiceBrowserDelegate>
@end

@implementation AMDBonjour {
	NSNetService *_publishService, *_resolveService;
	NSNetServiceBrowser *_browser;

	L8Value *_publishCallback;	// NSString *status
	L8Value *_discoverCallback;	// NSString *error, AMDBonjourPeer *peer
	L8Value *_resolveCallback;	// NSString *error, NSString *host, uint16_t port
}

@synthesize type=_type, domain=_domain;

- (instancetype)init
{
	self = [super init];
	if(self) {
		NSArray *arguments;

		arguments = [L8Context currentArguments];

		if(arguments.count >= 1)
			_type = [arguments[0] toString];
		else
			_type = @"_game._tcp";

		if(arguments.count >= 2)
			_domain = [arguments[1] toString];
		else
			_domain = @"local";
	}
	return self;
}

- (BOOL)publishWithPort:(uint16_t)port name:(NSString *)name callback:(L8Value *)callback
{
	if(name == nil)
		name = @"";

	if(_publishCallback)
		_publishCallback = nil;

	if([callback isFunction])
		_publishCallback = callback;

	_publishService = [[NSNetService alloc] initWithDomain:_domain
													  type:_type
													  name:name
													  port:port];
	_publishService.delegate = self;

	[_publishService publish];

	return YES;
}

- (void)discoverPeersWithCallback:(L8Value *)callback
{
	if AMD_LIKELY ([callback isFunction])
		_discoverCallback = callback;
	else
		@throw [L8TypeErrorException exceptionWithMessage:@"Callback must be a function"];

	_browser = [[NSNetServiceBrowser alloc] init];
	_browser.delegate = self;

	[_browser searchForServicesOfType:_type inDomain:_domain];
}

- (void)resolvePeerWithName:(NSString *)name callback:(L8Value *)callback
{
	if AMD_LIKELY ([callback isFunction])
		_resolveCallback = callback;
	else
		@throw [L8TypeErrorException exceptionWithMessage:@"Callback must be a function"];


	_resolveService = [[NSNetService alloc] initWithDomain:_domain
													  type:_type
													  name:name];
	_resolveService.delegate = self;

	[_resolveService resolveWithTimeout:10];
}

- (void)stop
{
	[_publishService stop];
	[_resolveService stop];
}

#pragma mark - NSNetServiceDelegate implementation

- (void)netServiceDidPublish:(NSNetService *)sender
{
	[_publishCallback.context executeBlockInContext:^(L8Context *context) {
		[_publishCallback callWithArguments:@[@"published"]];
	}];
}

- (void)netServiceWillPublish:(NSNetService *)sender
{
	[_publishCallback.context executeBlockInContext:^(L8Context *context) {
		[_publishCallback callWithArguments:@[@"publishing"]];
	}];
}

- (void)netServiceDidStop:(NSNetService *)sender
{
	[_publishCallback.context executeBlockInContext:^(L8Context *context) {
		[_publishCallback callWithArguments:@[@"stopped"]];
	}];
	[_resolveCallback.context executeBlockInContext:^(L8Context *context) {
		[_resolveCallback callWithArguments:@[@"stopped"]];
	}];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	[_resolveCallback.context executeBlockInContext:^(L8Context *context) {
		// TODO Put some usable error here
		[_resolveCallback callWithArguments:@[errorDict]];
	}];

	_resolveCallback = nil;
	[_resolveService stop];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	[_resolveCallback.context executeBlockInContext:^(L8Context *context) {
		[_resolveCallback callWithArguments:@[[NSNull null], sender.hostName, @(sender.port)]];
	}];

	_resolveCallback = nil;
	[_resolveService stop];
}

#pragma mark - NSNetServiceBrowserDelegate implementation

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
			 didNotSearch:(NSDictionary *)errorDict
{
	[_discoverCallback.context executeBlockInContext:^(L8Context *context) {
		// TODO Put some usable error here
		[_discoverCallback callWithArguments:@[errorDict]];
	}];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	[_discoverCallback.context executeBlockInContext:^(L8Context *context) {
		AMDBonjourPeer *peer;

		peer = [[AMDBonjourPeer alloc] initWithService:aNetService
											   bonjour:self];

		[_discoverCallback callWithArguments:@[[NSNull null],peer]];
	}];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	// TODO handle this.
	NSLog(@"Removed %@",aNetService);
}

@end

@implementation AMDBonjourPeer

@synthesize name=_name;

- (instancetype)initWithService:(NSNetService *)service bonjour:(AMDBonjour *)bonjour
{
	self = [super init];
	if(self) {
		_name = service.name;
		_service = service;
		_bonjour = bonjour;
	}
	return self;
}

- (void)resolveWithCallback:(L8Value *)callback
{
	[_bonjour resolvePeerWithName:_service.name callback:callback];
}

- (AMDSocket *)getSocket
{
	return [[AMDSocket alloc] initWithService:_service];
}

@end
