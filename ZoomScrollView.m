// Methoden entnommen "Objective-C und Cocoa", seite 259 ff

#import "ZoomScrollView.h"




@implementation ZoomScrollView
-(void)awakeFromNib
{
	NSPopUpButton *zoomButton;
	if (!zoomMenu) 
	{
	return;
	}
	zoomButton =[[[NSPopUpButton alloc] init] autorelease];
	[zoomButton setTag:'ZOOM'];
	[zoomButton setMenu:zoomMenu];
	[zoomButton selectItem:[zoomMenu itemWithTag:100]];
	NSButtonCell* zoomCell = [zoomButton cell];
	[zoomCell setControlSize:NSMiniControlSize];
	[zoomCell setAlignment:NSRightTextAlignment];
	[zoomCell setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]]];
	[zoomCell setBordered:YES];
	[zoomCell setBezeled:YES];
	[zoomCell setBezelStyle:NSSmallSquareBezelStyle];
	[zoomButton setAction:@selector(receiveZoomLevelFrom:)];
	[zoomButton setTarget:self];
	[self addSubview:zoomButton];
	[self setAutohidesScrollers:NO];
}

-(void)tile
{
NSRect zoomRect, scrollerRect;
[super tile];
scrollerRect = [[self horizontalScroller]frame];
NSDivideRect(scrollerRect, &zoomRect, &scrollerRect, 55.0, NSMinXEdge);
[[self viewWithTag:'ZOOM'] setFrame:zoomRect];
[[self horizontalScroller] setFrame:scrollerRect];
}

-(void)receiveZoomLevelFrom:(id)sender
{
	NSView *documentView = [self documentView];
	
	if ([sender isMemberOfClass:[NSPopUpButton class]])
		{
		
		NSRect bounds = [documentView bounds];
		NSSize frameSize = [documentView frame].size;
		frameSize.width = bounds.size.width * ((float)[[sender selectedItem]tag]) / 100.0;
		frameSize.height = bounds.size.height * ((float)[[sender selectedItem]tag]) / 100.0;
		[documentView setFrameSize:frameSize];
		[documentView setBounds:bounds];
		[[self contentView] setNeedsDisplay:YES];
		}
}

@end
