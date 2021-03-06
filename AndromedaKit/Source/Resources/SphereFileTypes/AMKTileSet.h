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

#import "AMKFile.h"

@class AMKImage, AMKObstructionMap;

/**
 * @brief A tile set. Also the representation of .rts files.
 */
@interface AMKTileSet : AMKFile

/// Size of a single tile
@property (readonly) NSSize tileSize;

/// An array of AMKTiles
@property (readonly) NSArray *tiles;

@end

/**
 * @brief Representation of a tile in a tileset.
 */
@interface AMKTile : NSObject

/// Image of the tile
@property (strong) AMKImage *image;

/// Name of the tile
@property (copy) NSString *name;

/// Whether the tile is animated
@property (assign) BOOL animated;

/// The next tile in the animation
@property (assign) int nextTile;

/// The tile-delay in the animation, given in frames
@property (assign) int delay;

/// The obstruction map for the tile. nil if no obstruction.
@property (strong) AMKObstructionMap *obstructionMap;

@end
