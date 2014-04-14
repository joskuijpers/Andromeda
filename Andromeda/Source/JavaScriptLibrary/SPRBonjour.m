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

#import "SPRBonjour.h"
#import "SPRSocket.h"

@interface SPRBonjour () <NSNetServiceDelegate, NSNetServiceBrowserDelegate>
@end

@implementation SPRBonjour {
	NSNetService *_service;
	NSNetServiceBrowser *_browser;

	L8Context *_context;
	L8ManagedValue *_publishCallback;	// NSString *status
	L8ManagedValue *_discoverCallback;	// NSString *error, SPRBonjourPeer *peer
	L8ManagedValue *_resolveCallback;	// NSString *error, NSString *host, uint16_t port
}

@synthesize type=_type, domain=_domain;

- (instancetype)init
{
	self = [super init];
	if(self) {
		NSArray *arguments;

		arguments = [L8Context currentArguments];
		_context = [L8Context currentContext];

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
	if([name isKindOfClass:[L8Value class]] && [(L8Value *)name isUndefined])
		name = @"";

	if(_publishCallback) {
		L8VirtualMachine *vm;

		vm = [_context virtualMachine];
		[vm removeManagedReference:_publishCallback withOwner:self];

		_publishCallback = nil;
	}

	if([callback isFunction])
		_publishCallback = [L8ManagedValue managedValueWithValue:callback
														 andOwner:self];

	_service = [[NSNetService alloc] initWithDomain:_domain
											   type:_type
											   name:name
											   port:port];
	_service.delegate = self;

	[_service publish];

	return YES;
}

- (void)discoverPeersWithCallback:(L8Value *)callback
{
	if(_discoverCallback) {
		L8VirtualMachine *vm;

		vm = [_context virtualMachine];
		[vm removeManagedReference:_discoverCallback withOwner:self];

		_discoverCallback = nil;
	}

	if SPR_LIKELY ([callback isFunction])
		_discoverCallback = [L8ManagedValue managedValueWithValue:callback
														andOwner:self];
	else
		@throw [NSException exceptionWithName:NSInvalidArgumentException
									   reason:@"Argument 0 must be function."
									 userInfo:nil];

	_browser = [[NSNetServiceBrowser alloc] init];
	_browser.delegate = self;

	[_browser searchForServicesOfType:_type inDomain:_domain];
}

- (void)resolvePeerWithName:(NSString *)name callback:(L8Value *)callback
{
	_service = [[NSNetService alloc] initWithDomain:_domain
											   type:_type
											   name:name];
//	_service.delegate = self;
//	[_service resolveWithTimeout:<#(NSTimeInterval)#>];
}

- (void)stop
{
	[_service stop];
}

#pragma mark - NSNetServiceDelegate implementation

- (void)netServiceDidPublish:(NSNetService *)sender
{
	[_context executeBlockInContext:^(L8Context *context) {
		[[_publishCallback value] callWithArguments:@[@"published"]];
	}];
}

- (void)netServiceWillPublish:(NSNetService *)sender
{
	[_context executeBlockInContext:^(L8Context *context) {
		[[_publishCallback value] callWithArguments:@[@"publishing"]];
	}];
}

- (void)netServiceDidStop:(NSNetService *)sender
{
	[_context executeBlockInContext:^(L8Context *context) {
		[[_publishCallback value] callWithArguments:@[@"stopped"]];
	}];
}

#pragma mark - NSNetServiceBrowserDelegate implementation

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	NSLog(@"WillSearch");
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	NSLog(@"Stopped");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
			 didNotSearch:(NSDictionary *)errorDict
{
	NSLog(@"Didnot %@",errorDict);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	NSLog(@"Found %@, more %d",aNetService,moreComing);
	[_context executeBlockInContext:^(L8Context *context) {
		SPRBonjourPeer *peer;

		peer = [[SPRBonjourPeer alloc] initWithService:aNetService
											   bonjour:self];

		[[_discoverCallback value] callWithArguments:@[[NSNull null],peer]];
	}];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	NSLog(@"Removed %@, more %d",aNetService,moreComing);
}

@end

@implementation SPRBonjourPeer

@synthesize name=_name;

- (instancetype)initWithService:(NSNetService *)service bonjour:(SPRBonjour *)bonjour
{
	self = [super init];
	if(self) {
		_name = [service.name copy];
		_service = service;
		_bonjour = bonjour;
	}
	return self;
}

- (void)resolveWithCallback:(L8Value *)callback
{

}

- (SPRSocket *)getSocket
{
	return [[SPRSocket alloc] initWithService:_service];
}

@end