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

#import "AMDGraphicsView.h"
#import "AMDGraphicsEngine.h"

@import OpenGL;
#import <OpenGL/gl3.h>

static CVReturn amd_display_link_callback(CVDisplayLinkRef displayLink,
										  const CVTimeStamp *now,
										  const CVTimeStamp *outputTime,
										  CVOptionFlags flagsIn,
										  CVOptionFlags *flagsOut,
										  void *displayLinkContext);

@implementation AMDGraphicsView {
	CVDisplayLinkRef _displayLink;
}

- (void)awakeFromNib
{
	NSOpenGLPixelFormat *pixelFormat;
	NSOpenGLContext *context;

	NSOpenGLPixelFormatAttribute attrs[] =
	{
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAOpenGLProfile,
		NSOpenGLProfileVersion3_2Core,
		0
	};

	pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	if(!pixelFormat)
		NSLog(@"No OpenGL pixel format");

    context = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];

#ifdef DEBUG
	CGLEnable([context CGLContextObj], kCGLCECrashOnRemovedFunctions);
#endif

    [self setPixelFormat:pixelFormat];
    [self setOpenGLContext:context];

    [self setWantsBestResolutionOpenGLSurface:YES];
}

- (void)dealloc
{
	CVDisplayLinkStop(_displayLink);
	CVDisplayLinkRelease(_displayLink);
}

- (void)prepareOpenGL
{
	[super prepareOpenGL];

	CGLContextObj cglContext;
	CGLPixelFormatObj cglPixelFormat;
	GLint swapInt;

	// Synchronize buffer swaps with screen refresh rate
	swapInt = 1;
	[self.openGLContext setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];

	CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
	CVDisplayLinkSetOutputCallback(_displayLink, &amd_display_link_callback, (__bridge void *)self);

	cglContext = [self.openGLContext CGLContextObj];
	cglPixelFormat = [self.pixelFormat CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);

	CVDisplayLinkStart(_displayLink);

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowWillClose:)
												 name:NSWindowWillCloseNotification
											   object:self.window];
}

#pragma mark - Actions

- (void)reshape
{
	NSRect viewRectPoints, viewRectPixels;

	[super reshape];
	CGLLockContext([self.openGLContext CGLContextObj]);

	viewRectPoints = self.bounds;
	viewRectPixels = [self convertRectToBacking:viewRectPoints];

	[_engine setViewportRect:viewRectPixels];

	CGLUnlockContext([self.openGLContext CGLContextObj]);
}

- (void)windowWillClose:(NSNotification*)notification
{
	CVDisplayLinkStop(_displayLink);
}

- (void)renewGState
{
	[self.window disableScreenUpdatesUntilFlush];
	[super renewGState];
}

#pragma mark - Drawing

- (CVReturn)getFrameForTime:(const CVTimeStamp *)outputTime
{
	@autoreleasepool {
		[self drawView];
	}

    return kCVReturnSuccess;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self drawView];
}

- (void)drawView
{
	[self.openGLContext makeCurrentContext];

	CGLLockContext([self.openGLContext CGLContextObj]);

    [_engine render];

	CGLFlushDrawable([self.openGLContext CGLContextObj]);
	CGLUnlockContext([self.openGLContext CGLContextObj]);
}

@end

static CVReturn amd_display_link_callback(CVDisplayLinkRef displayLink,
										  const CVTimeStamp *now,
										  const CVTimeStamp *outputTime,
										  CVOptionFlags flagsIn,
										  CVOptionFlags *flagsOut,
										  void *displayLinkContext)
{
	CVReturn result;

	result = [(__bridge AMDGraphicsView *)displayLinkContext getFrameForTime:outputTime];

	return result;
}
