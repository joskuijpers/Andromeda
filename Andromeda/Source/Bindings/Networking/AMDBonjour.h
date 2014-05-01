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

#import <L8Framework/L8.h>

@class AMDSocket, AMDBonjourPeer;

/**
 * @brief Bonjour networking: JavaScript exports.
 */
@protocol AMDBonjour <L8Export>

/// Type of the service. Defaults to _game._tcp.
@property NSString *type;

/// Domain of the service. Defaults to local.
@property NSString *domain;

/**
 * Create a new Bonjour class
 *
 * @!param type Type to be used in the Bonjour identifier. [optional,default="_game._tcp"]
 * @!param domain Domain to be used in the Bonjour identifier. [optional,default="local"]
 * @return An initialized AMDBonjour object.
 */
- (instancetype)init;

/**
 * Public a Bonjour service.
 *
 * @param port Port on which the service is reachable.
 * @param name Name of the service.
 * @param callback Status callback. Callback parameters are
 * [NSString *status].
 * @return YES when publish-initialization succeeded, NO otherwise.
 */
L8_EXPORT_AS(publish,
- (BOOL)publishWithPort:(uint16_t)port
				   name:(NSString *)name
               callback:(L8Value *)callback
);

/**
 * Discover peers with the same type and domain as this Bonjour object.
 *
 * @param callback Callback used to notify a discovered peer.
 * Callback parameters are [NSString *error, AMDBonjourPeer *peer].
 */
L8_EXPORT_AS(discover,
- (void)discoverPeersWithCallback:(L8Value *)callback
);

/**
 * Resolve the name of a peer to a host and port.
 *
 * @param name Name of the peer.
 * @param callback Callback used to return the peer information.
 * Callback parameters are [NSString *error, NSString *host, uint16_t port].
 */
L8_EXPORT_AS(resolve,
- (void)resolvePeerWithName:(NSString *)name callback:(L8Value *)callback
);

/**
 * Stop the current action.
 *
 * Publishing will be turned of, discovering is stopped,
 * and any unresolved servcices are cancelled.
 */
- (void)stop;

@end

/**
 * @brief A peer host in Bonjour: JavaScript exports.
 */
@protocol AMDBonjourPeer <L8Export>

/// Name of the peer.
@property (nonatomic,readonly) NSString *name;

/**
 * Resolve the peer to a host and port.
 *
 * @param callback Callback used when information is found.
 */
L8_EXPORT_AS(resolve,
- (void)resolveWithCallback:(L8Value *)callback //void (^)(NSString *error, NSString *host, uint16_t port)
);

/**
 * Get a socket for to the peer.
 *
 * @return A socket.
 */
- (AMDSocket *)getSocket;

@end

/**
 * @brief Bonjour networking.
 */
@interface AMDBonjour : NSObject <AMDBonjour>

@end

/**
 * @brief A peer host in Bonjour.
 */
@interface AMDBonjourPeer : NSObject <AMDBonjourPeer>

/// NSNetService of the peer.
@property (readonly) NSNetService *service;

/// Bonjour service that discovered this peer.
@property (readonly) AMDBonjour *bonjour;

/**
 * Create a new Peer object with specified name and service.
 *
 * @param name Name of the peer.
 * @param service Service that discovered the peer.
 * @return An initialized Peer object.
 */
- (instancetype)initWithService:(NSNetService *)service
						bonjour:(AMDBonjour *)bonjour;

@end
