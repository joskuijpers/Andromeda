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

/// An edge of the map. Used in the edge script.
typedef enum {
	AMKMapEdgeNorth = 0,
	AMKMapEdgeEast = 1,
	AMKMapEdgeSouth = 2,
	AMKMapEdgeWest = 3
} AMKMapEdge;

@class AMKObstructionMap, AMKTileSet, AMKImage;

/**
 * @brief A map. Also the representation of .rmp files
 */
@interface AMKMap : AMKFile

/// Location of the player when entering the map
@property (readonly) NSPoint startLocation;

/// The layer where the player starts in. (The player-layer affects collision and touch)
@property (readonly) uint8_t startLayer;

/// Start direction of the player spriteset
@property (readonly) int startDirection;

/// Whether the map repeats in all directions
@property (readonly,getter=isRepeating) BOOL repeating;

/// The filename of the background music. Must be relative to /sounds
@property (readonly) NSString *musicFilename;

/// The script executed on entry of the map by the player
@property (readonly) NSString *entryScript;

/// The script executed on exit of the map by the player
@property (readonly) NSString *exitScript;

/// A list of scripts, each an NSString
@property (readonly) NSArray *edgeScripts;

/// A list of layers of class AMKMapLayer
@property (readonly) NSArray *layers;

/// A list of entities of class AMKMapEntity
@property (readonly) NSArray *entities;

/// A list of zones of class AMKMapZone
@property (readonly) NSArray *zones;

/// Tile set of this map
@property (readonly) AMKTileSet *tileSet;

/**
 * Create an image containing the initial setup of the map.
 * Useful for testing purposes.
 *
 * @return An AMKImage
 */
- (AMKImage *)overviewRender;

@end

/**
 * @brief Layer in a Map.
 */
@interface AMKMapLayer : NSObject

@property (assign) NSSize size;
@property (copy) NSString *name;
@property (assign) BOOL hasParallax;
@property (assign) NSPoint parallax;
@property (assign) NSPoint scrolling;
@property (assign,getter=isVisible) BOOL visible;
@property (assign,getter=isReflective) BOOL reflective;
@property (readonly) AMKObstructionMap *obstructionMap;

- (unsigned int)tileIndexAtPoint:(NSPoint)point;

@end

/**
 * @brief Zone in a map.
 */
@interface AMKMapZone : NSObject

@property (assign) NSRect area;
@property (assign) int layer;
@property (assign) int reactivation_steps;
@property (strong) NSString *script;

@end

/**
 * @brief Entity in map.
 */
@interface AMKMapEntity : NSObject

@property (assign) NSPoint location;
@property (assign) int layer;

@end

/**
 * @brief Person entity in a map.
 */
@interface AMKMapPerson : AMKMapEntity

@property (copy) NSString *name;
@property (copy) NSString *spriteSetFilename;

@property (strong) NSString *createScript;
@property (strong) NSString *destroyScript;
@property (strong) NSString *activateTouchScript;
@property (strong) NSString *activateTalkScript;
@property (strong) NSString *generateCommandsScript;

@end

/**
 * @brief Trigger entity in a map.
 */
@interface AMKMapTrigger : AMKMapEntity

@property (strong) NSString *script;

@end
