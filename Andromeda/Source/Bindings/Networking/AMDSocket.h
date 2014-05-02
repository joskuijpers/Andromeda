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

/**
 * @brief Network communication using a TCP socket: JavaScript exports.
 */
@protocol AMDSocket <L8Export>

/// Whether the socket is (still) connected.
@property (readonly,getter=isConnected) BOOL connected;

/// Bytes remaining to be read currently.
@property (readonly) size_t pendingReadSize;

- (instancetype)init;

/**
 * Read a number of bytes from the stream.
 *
 * @param size Number of bytes.
 * @return ArrayBuffer containing the data. The size of the buffer
 * can be smaller than size, when no more bytes were available.
 */
L8_EXPORT_AS(read,
- (L8ArrayBuffer *)readBytes:(size_t)size
);

/**
 * Write data (ArrayBuffer) to the stream.
 *
 * @param data The data to write.
 */
L8_EXPORT_AS(write,
- (void)writeBytes:(L8ArrayBuffer *)data
);

/**
 * Closes current connection
 */
- (void)close;

@end

/**
 * @brief Network communication using a TCP socket.
 */
@interface AMDSocket : NSObject <AMDSocket>

/**
 * Create a socket with given address and port.
 *
 * @param address The remote address.
 * @param port The remote port.
 * @return self
 */
- (instancetype)initWithAddress:(NSString *)address
						   port:(uint16_t)port;

/**
 * Create a socket with a service.
 *
 * @param service The remote service.
 * @return self
 */
- (instancetype)initWithService:(NSNetService *)service;

@end
