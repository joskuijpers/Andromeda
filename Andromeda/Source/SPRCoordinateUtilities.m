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

#import "SPRCoordinateUtilities.h"

/*
 * I need to explain this, before you kill me.
 *
 * The engine allows only one (1) window and thus one (1)
 * content view, and it never changes. So the pointer never
 * changes. Now why would I store it? Because it is faster to
 * use a pointer than to run [[NSApp mainWindow] contentView] for
 * every translation. This is still assuming the size of the game-window
 * can change at any point.
 * When I implement that it can't so easily change, the window-size
 * can be retrieved from somewhere else.
 */
static __weak NSView *g_mainView = nil;

NSPoint spr_coord_translate_p(NSPoint coord)
{
	if SPR_UNLIKELY(g_mainView == nil)
		g_mainView = [[NSApp mainWindow] contentView];

	return NSMakePoint(coord.x, g_mainView.frame.size.height - coord.y - 1);
}

float spr_coord_translate_f(float coord)
{
	if SPR_UNLIKELY(g_mainView == nil)
		g_mainView = [[NSApp mainWindow] contentView];

	return g_mainView.frame.size.height - coord - 1;
}

NSPoint spr_coord_translate_screen(NSPoint location)
{
	NSRect frame;

	if SPR_UNLIKELY(g_mainView == nil)
		g_mainView = [[NSApp mainWindow] contentView];

	frame = g_mainView.frame;

	if(location.x < 0.0 || location.x > frame.size.width
	   || location.y < 0.0 || location.y > frame.size.height)
		return NSZeroPoint;

	return NSMakePoint(location.x,frame.size.height - location.y - 1);
}

