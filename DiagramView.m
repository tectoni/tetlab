#import "DiagramView.h"
#import"Graphic.h"
#import"SelData.h"
#import"MyDocument.h"

static void *PropertyObservationContext = (void *)1091;
static void *GraphicsObservationContext = (void *)1092;
static void *SelectionIndexesObservationContext = (void *)1093;

NSString *GRAPHICS_BINDING_NAME = @"graphics";
NSString *SELECTIONINDEXES_BINDING_NAME = @"selectionIndexes";


@implementation DiagramView



+ (void)initialize
{
			NSLog(@"DiagramView + (void)initialize");

	[self exposeBinding:GRAPHICS_BINDING_NAME];
	[self exposeBinding:SELECTIONINDEXES_BINDING_NAME];
}


- (id)initWithFrame:(NSRect)frameRect
{
//	float axisLength;
//	axisLength = 400.0;
if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
			selArray = [[NSMutableArray alloc] init];
			
			[self setBoundsOrigin:NSMakePoint(-250.0,-250.0)];
	//		alpha = [angles alpha];
	//		theta = [angles theta];
		
//			connectedSymbolsContainer = [[NSMutableArray alloc] init];
		
			NSLog(@"DiagramView initWithFrame %@", self);
	//		[NSApp setDelegate: self];
			[self setSaveable: YES];
			[self setNeedsDisplay: YES];
	//		[self setShowLabelsYN:connectPointsButton];
			bindingInfo = [[NSMutableDictionary alloc] init];
			[self prepareAttributes];
	//		header = [[Headers alloc]init];

	}
	return self;
}


- (void)awakeFromNib {
	NSLog(@"DiagramView -awakeFromNib %@", self);
    return;
}

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
		NSLog(@"DiagramView -(id)awakeAfterUsingCoder %@", self);

return self;
}

-(id)replacementObjectForCoder:(NSCoder *)aDecoder
{
NSLog(@"DiagramView -(id)replacementObjectForCoder %@", self);
return self;
}




- (NSArray *)exposedBindings
{
	return [NSArray arrayWithObjects:GRAPHICS_BINDING_NAME, @"selectedObjects", nil];
}



-(void)dealloc
{
	[bindingInfo release];
	[oldGraphics release];
	[super dealloc];
}

-(void)setAlpha:(float)newAlpha
{
	alpha = newAlpha * 3.14159265 / 180.0;
		[self setNeedsDisplay:YES];
}

-(float)alpha {return alpha;}

-(void)setTheta:(float)newTheta
{
	theta = newTheta * 3.14159265 / 180.0;
		[self setNeedsDisplay:YES];

}

-(float)theta {return theta;}	
	
	

- (NSMutableArray *)selArray {return selArray;}


- (void)setSelArray:(NSMutableArray *)aSelArray
{
    [aSelArray retain];
    if (selArray != aSelArray) {
        [selArray release];
        selArray = [aSelArray mutableCopy];
[selTable reloadData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
    ofObject:(id)object
    change:(NSDictionary *)change
    context:(void *)context
{
	
    if (context == GraphicsObservationContext)
	{
		/*
		 Should be able to use
		 NSArray *oldGraphics = [change objectForKey:NSKeyValueChangeOldKey];
		 etc. but the dictionary doesn't contain old and new arrays.
		 */
		NSArray *newGraphics = [object valueForKeyPath:[self graphicsKeyPath]];
		
		NSMutableArray *onlyNew = [newGraphics mutableCopy];
		[onlyNew removeObjectsInArray:oldGraphics];
		[self startObservingGraphics:onlyNew];
		[onlyNew release];
		
		NSMutableArray *removed = [oldGraphics mutableCopy];
		[removed removeObjectsInArray:newGraphics];
		[self stopObservingGraphics:removed];
		[removed release];
		
		[self setOldGraphics:newGraphics];
		
		// could check drawingBounds of old and new, but...
		[self setNeedsDisplay:YES];
		return;
    }
	
	if (context == PropertyObservationContext)
	{
		/*
		Geht nicht, da kein updateRect ermittelt werden kann. Es ist nicht möglich, die Methode drawingBounds zu 
		implementieren, da dies innerhalb des Modells die Kenntnis der x,y Koordinaten erfordern würde. Die werden
		aber im View bestimmt, da sie abhängig von den Winkeln sind.
		
	NSRect updateRect;
		
		if ([keyPath isEqualToString:@"drawingBounds"])
		{
			NSRect newBounds = [[change objectForKey:NSKeyValueChangeNewKey] rectValue];
			NSRect oldBounds = [[change objectForKey:NSKeyValueChangeOldKey] rectValue];
			updateRect = NSUnionRect(newBounds,oldBounds);
		}
		else
		{
			updateRect = [(NSObject <Graphic> *)object drawingBounds];
		}
		updateRect = NSMakeRect(updateRect.origin.x-1.0,
								updateRect.origin.y-1.0,
								updateRect.size.width+2.0,
								updateRect.size.height+2.0);
		[self setNeedsDisplayInRect:updateRect];
		
		return;
		
		*/
		
		[self setNeedsDisplay:YES];

		return;
	}
	
	if (context == SelectionIndexesObservationContext)
	{
		[self setNeedsDisplay:YES];
		return;
	}
}

- (void)startObservingGraphics:(NSArray *)graphics
{
	if ([graphics isEqual:[NSNull null]])
	{
		return;
	}
	
	/*
	 Register to observe each of the new graphics, and each of their observable properties -- we need old and new values for drawingBounds to figure out what our dirty rect
	 */
	NSEnumerator *graphicsEnumerator = [graphics objectEnumerator];
	
	/*
	 Declare newGraphic as NSObject * to get key value observing methods
	 Add Graphic protocol for drawing
	 */
    NSObject <Graphic> *newGraphic;
	/*
	 Register as observer for all the drawing-related properties
	 */
    while (newGraphic = [graphicsEnumerator nextObject])
	{
	/*
			[newGraphic addObserver:self
					 forKeyPath:GraphicDrawingBoundsKey
						options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
						context:PropertyObservationContext];
		*/
		[newGraphic addObserver:self
					 forKeyPath:GraphicDrawingContentsKey
						options:0
						context:PropertyObservationContext];
	}
}


- (void)stopObservingGraphics:(NSArray *)graphics
{
	if ([graphics isEqual:[NSNull null]])
	{
		return;
	}
	
	NSEnumerator *graphicsEnumerator = [graphics objectEnumerator];
	
    id oldGraphic;
    while (oldGraphic = [graphicsEnumerator nextObject])
	{
	//	[oldGraphic removeObserver:self forKeyPath:GraphicDrawingBoundsKey];
		[oldGraphic removeObserver:self forKeyPath:GraphicDrawingContentsKey];
	}
}


- (void)bind:(NSString *)bindingName
	   toObject:(id)observableObject
	withKeyPath:(NSString *)observableKeyPath
		   options:(NSDictionary *)options
{
	
    if ([bindingName isEqualToString:GRAPHICS_BINDING_NAME])
	{
		if ([bindingInfo objectForKey:GRAPHICS_BINDING_NAME] != nil)
		{
			[self unbind:GRAPHICS_BINDING_NAME];	
		}
		/*
		 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
		 */
		
		NSDictionary *bindingsData = [NSDictionary dictionaryWithObjectsAndKeys:
									  observableObject, NSObservedObjectKey,
									  [[observableKeyPath copy] autorelease], NSObservedKeyPathKey,
									  [[options copy] autorelease], NSOptionsKey, nil];
		[bindingInfo setObject:bindingsData forKey:GRAPHICS_BINDING_NAME];
		
		[observableObject addObserver:self
						   forKeyPath:observableKeyPath
							  options:(NSKeyValueObservingOptionNew |
									   NSKeyValueObservingOptionOld)
							  context:GraphicsObservationContext];
		[self startObservingGraphics:[observableObject valueForKeyPath:observableKeyPath]];
		
    }
	else
		if ([bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME])
		{
			if ([bindingInfo objectForKey:SELECTIONINDEXES_BINDING_NAME] != nil)
			{
				[self unbind:SELECTIONINDEXES_BINDING_NAME];	
			}
			/*
			 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
			 */
			
			NSDictionary *bindingsData = [NSDictionary dictionaryWithObjectsAndKeys:
										  observableObject, NSObservedObjectKey,
										  [[observableKeyPath copy] autorelease], NSObservedKeyPathKey,
										  [[options copy] autorelease], NSOptionsKey, nil];
			[bindingInfo setObject:bindingsData forKey:SELECTIONINDEXES_BINDING_NAME];
			
			
			[observableObject addObserver:self
							   forKeyPath:observableKeyPath
								  options:0
								  context:SelectionIndexesObservationContext];
		}
	else
	{
		/*
		 For every binding except "graphics" and "selectionIndexes" just use NSObject's default implementation. It will start observing the bound-to property. When a KVO notification is sent for the bound-to property, this object will be sent a [self setValue:theNewValue forKey:theBindingName] message, so this class just has to be KVC-compliant for a key that is the same as the binding name.  Also, NSView supports a few simple bindings of its own, and there's no reason to get in the way of those.
		 */
		[super bind:bindingName toObject:observableObject withKeyPath:observableKeyPath options:options];
	}
    [self setNeedsDisplay:YES];
}

- (void)unbind:(NSString *)bindingName
{
	
    if ([bindingName isEqualToString:GRAPHICS_BINDING_NAME])
	{
		id graphicsContainer = [self graphicsContainer];
		NSString *graphicsKeyPath = [self graphicsKeyPath];
		
		[graphicsContainer removeObserver:self forKeyPath:graphicsKeyPath];
		[bindingInfo removeObjectForKey:GRAPHICS_BINDING_NAME];
 		[self setOldGraphics:nil];
	}
	else
		if ([bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME])
		{
			id selectionIndexesContainer = [self selectionIndexesContainer];
			NSString *selectionIndexesKeyPath = [self selectionIndexesKeyPath];
			
			[selectionIndexesContainer removeObserver:self forKeyPath:selectionIndexesKeyPath];
			[bindingInfo removeObjectForKey:SELECTIONINDEXES_BINDING_NAME];
		}
	else
	{
		[super unbind:bindingName];
	}
    [self setNeedsDisplay:YES];
}



-(IBAction)changeAlphaSlider:(id)sender
{
	[self setAlpha:[sender floatValue]];
	[self setNeedsDisplay:YES];
	[controller updateUI];
}
	
-(IBAction)changeThetaSlider:(id)sender
{
	[self setTheta:[sender floatValue]];
	[self setNeedsDisplay:YES];
	[controller updateUI];
}




-(NSPoint)convertBary2Cartesian:(float)a b:(float)b c:(float)c d:(float)d
{
	float tot, X, Y, Z, X2, Y2, Z2, XR, YR, ZR;
	const float eyepointDistance = 1.0;
	const float gamma = 0.0;
	/*
	 From: Spear Am Min 65:1291-1293; Spear Program Tetplot4.f (Fortran Source Code)
	
	 routine to compute cartesian coordinates from 4-component
     barycentric coordinates and then to rotate through angles
     a(alpha), T(theta)
     stereoscopic projection is made with an interpupilary angle
     of G(gamma) and an eyedistance of E
	*/
	tot= a+b+c+d;
	a = a/tot;
	b = b/tot;
	d = d/tot;
	X = ((a - 0.25) + 0.5 * (b-0.25) + 0.5 * (d-.25))/0.8165;
	Y = ((b - 0.25) + 0.333333 * (d-.25))/0.9428;
	Z = d - 0.25;
	X2 = X * cos(alpha) - Y * sin(alpha);
	Y2 = (X * sin(alpha) + Y * cos(alpha)) * cos(theta) + Z * sin(theta);
	Z2 = Z * cos(theta) - sin(theta) * (X * sin(alpha) + Y * cos(alpha));
	//ZR = X2 * sin(gamma/2) + Z2 * cos(gamma/2);
	ZR = 0.0; // Für nicht-stereoskopische Betrachtung
	
	XR = (X2 * cos(gamma/2) - Z2 * sin(gamma/2)) * eyepointDistance / (eyepointDistance - ZR);
	YR = Y2 * eyepointDistance / (eyepointDistance - ZR);

	NSPoint point = NSMakePoint(XR*300.0, YR*300.0);

	return point;
}


-(void)drawRect:(NSRect)rect
{
	NSPoint a, b, c, d;
	NSPoint aPoint, bPoint, cPoint, dPoint;
	//NSLog(@"drawRect rect  %@", NSStringFromRect(rect));

	NSRect bounds = [self bounds];
	bounds.origin = NSMakePoint(150.0, 150.0);
	// rect.origin = NSMakePoint(150.0, 150.0);
	//
	// These are for converting raw data coordinates into
	// display coordinates.
	//
	float axisLength;
	axisLength = 500.0;		
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:bounds];
	[[NSColor blackColor] set];
	
	NSEraseRect(rect);
    NSBezierPath *path = [NSBezierPath bezierPath];
	int i;

// Draw Tetrahedron
//	path = [[NSBezierPath alloc] init];
			[path setLineWidth: 1.0];
			a = [self convertBary2Cartesian:1.0 b:0.0 c:0.0 d:0.0];
			b = [self convertBary2Cartesian:0.0 b:1.0 c:0.0 d:0.0];
			c = [self convertBary2Cartesian:0.0 b:0.0 c:1.0 d:0.0];
			d = [self convertBary2Cartesian:0.0 b:0.0 c:0.0 d:1.0];

			// Draw the Tetrahedron
			
			[path moveToPoint: a];
			[path lineToPoint: b];
			[path lineToPoint: c];
			[path closePath];

			
			[path moveToPoint: a];
			[path lineToPoint: d];
			[path lineToPoint: c];
			
			[path moveToPoint: d];
			[path lineToPoint: b];


	[path stroke];


	/*
	 Draw graphics
	 */
	NSArray *graphicsArray = [self graphics];
	NSEnumerator *graphicsEnumerator = [graphicsArray objectEnumerator];
	NSObject <Graphic> *graphic;
    while (graphic = [graphicsEnumerator nextObject])
	{
//		NSLog(@"DiagramView drawRect sss%@", self);

      //  NSRect graphicDrawingBounds = [graphic drawingBounds];
	NSPoint point = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
	NSRect graphicDrawingBounds = NSMakeRect(point.x-[graphic radius], point.y-[graphic radius], [graphic radius]*2, [graphic radius]*2);
	//NSLog(@"DiagramView 1 graphicDrawingBounds r%@ db %@", NSStringFromRect(rect), NSStringFromRect(graphicDrawingBounds));

        if (NSIntersectsRect(rect, graphicDrawingBounds))
		{
			[graphic drawInView:self withBounds:graphicDrawingBounds];
	//		NSLog(@"DiagramView 1 graphicDrawingBounds r%f  %@", [graphic radius], NSStringFromRect(graphicDrawingBounds));

        }
    }

	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];	 
//	NSIndexSet *currentSelectionIndexes = [[self selectionIndexesContainer] valueForKeyPath:[self selectionIndexesKeyPath]];

	if (currentSelectionIndexes != nil)	//  Draw symbol with selection box
	// hier muss ein Fehler sein. symbol wird nicht mit neuen Werten gezeichnet. graphicDrawingBounds sind aber aktualisiert 
	{
		NSBezierPath *path = [NSBezierPath bezierPath];
//		unsigned int index = [currentSelectionIndexes firstIndex];
        NSUInteger index = [currentSelectionIndexes firstIndex];

		while (index != NSNotFound)
		{
		
			graphic = [graphicsArray objectAtIndex:index];
			NSPoint point = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			NSRect graphicDrawingBounds = NSMakeRect(point.x-[graphic radius], point.y-[graphic radius], [graphic radius]*2, [graphic radius]*2);

			if (NSIntersectsRect(rect, graphicDrawingBounds))
			{
				[path appendBezierPathWithRect:graphicDrawingBounds];
			//	NSLog(@"DiagramView 2 graphicDrawingBounds r%f  %@", [graphic radius], NSStringFromRect(graphicDrawingBounds));

			}
			
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[[NSColor redColor] set];
		[path setLineWidth:1.0];
		[path stroke];
	}

if (connectPointsYN) {

for (i = 0; i < [selArray count]; i++) {
	//		NSIndexSet *selection = [[selArray objectAtIndex:i]sel];

	SelData *aSel = [selArray objectAtIndex:i];
	NSArray *points2Connect = [aSel sel];
		//	NSIndexSet *selection = [symbolController selectionIndexes];
	if ( [points2Connect count] > 1) {
			unsigned int index = 0;
			NSLog(@"first index %u", index);	

			graphic = [points2Connect objectAtIndex:index];
//			index = [selection indexGreaterThanIndex:index];
			NSLog(@"second index no %u", index);	
			NSBezierPath *path = [NSBezierPath bezierPath];		
			[[NSColor blueColor] set];
			[path setLineWidth:0.5];
			NSPoint a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path moveToPoint: a];
	//					NSLog(@"selection count %u", [selection count]);	

		while (index < [points2Connect count])
		{
			graphic = [points2Connect objectAtIndex:index];
			a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path lineToPoint: a];
			index++;
			NSLog(@"index no %u", index);	
		}
		
		[path closePath];

	if ([points2Connect count] > 3) {
		//	index = [selection firstIndex];
			graphic = [points2Connect objectAtIndex:0];
			a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path moveToPoint: a];
	//		index = [selection indexGreaterThanIndex:index];
	//		index = [selection indexGreaterThanIndex:index];

			graphic = [points2Connect objectAtIndex:2];
			a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path lineToPoint: a];

// This procedure should be optimised soon!!!! very quick & dirty

	//		index = [selection lastIndex];
			graphic = [points2Connect objectAtIndex:3];
			a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path moveToPoint: a];

//			index = [selection firstIndex];
//			index = [selection indexGreaterThanIndex:index];

			graphic = [points2Connect objectAtIndex:1];
			a = [self convertBary2Cartesian:[graphic aValue] b:[graphic bValue] c:[graphic cValue] d:[graphic dValue]];
			[path lineToPoint: a];
		}
			[path stroke];
		}
	}


	}	// if (connectPointsYN)
	
	
if (showLabelsYN) {
	aPoint = [self convertBary2Cartesian:1.0 b:-0.05 c:0 d:0];
	aPoint.x = aPoint.x-[aString sizeWithAttributes:attributes].width/2;
	[aString drawAtPoint:aPoint withAttributes:attributes]; 	

	bPoint = [self convertBary2Cartesian:0 b:1 c:0 d:-0.05];
	bPoint.x = bPoint.x-[bString sizeWithAttributes:attributes].width/2;
	[bString drawAtPoint:bPoint withAttributes:attributes]; 	

	cPoint = [self convertBary2Cartesian:0 b:-0.05 c:1 d:0];
	cPoint.x = cPoint.x-[cString sizeWithAttributes:attributes].width/2;
	[cString drawAtPoint:cPoint withAttributes:attributes]; 	

	dPoint = [self convertBary2Cartesian:0 b:-0.05 c:0 d:1];
	dPoint.x = dPoint.x-[dString sizeWithAttributes:attributes].width/2;
	[dString drawAtPoint:dPoint withAttributes:attributes]; 	
	}
	
//NSLog(@"drawRect %@", self);
[self retain];
}




- (void)prepareAttributes
{
    attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:[NSFont fontWithName:@"Helvetica" size:14]
                   forKey:NSFontAttributeName];
    
    [attributes setObject:[NSColor blackColor]
                   forKey:NSForegroundColorAttributeName];
}



- (void)setSaveable:(BOOL)yn
{
	saveable = yn;
}


- (BOOL)saveable
{
	return saveable;
}

- (void) setShowLabelsYN:(BOOL)yn
{ 
	showLabelsYN = yn;
//	[self setNeedsDisplay:YES];
//	NSLog(@"DiagramView setTicks %@", self);
}

-(BOOL)showLabelsYN {return showLabelsYN;}

-(void)setConnectPointsYN:(BOOL)yn
{
	connectPointsYN = yn;
}

-(BOOL)connectPointsYN { return connectPointsYN; }

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	NSString *selectorString;
	selectorString = NSStringFromSelector([menuItem action]);
	NSLog(@"validateCalled for %@", selectorString);
	
	// By using the action instead of the title, we do not
	// have to worry about whether the menu item is localized
	if ([menuItem action] == @selector(savePDF:)) {
		return saveable;
	} else {
		return YES;
	}
}




- (NSArray *)oldGraphics
{
	return oldGraphics;
}

- (void)setOldGraphics:(NSArray *)anOldGraphics
{
    if (oldGraphics != anOldGraphics) {
        [oldGraphics release];
        oldGraphics = [anOldGraphics mutableCopy];
    }
}


// bindings-related -- infoForBinding and convenience methods

- (NSDictionary *)infoForBinding:(NSString *)bindingName
{
	NSDictionary *info = [bindingInfo objectForKey:bindingName];
	if (info == nil) {
		info = [super infoForBinding:bindingName];
	}
	return info;
}

- (id)graphicsContainer
{
	return [[self infoForBinding:GRAPHICS_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)graphicsKeyPath {
	return [[self infoForBinding:GRAPHICS_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}

- (id)selectionIndexesContainer
{
	return [[self infoForBinding:SELECTIONINDEXES_BINDING_NAME] objectForKey:NSObservedObjectKey];
}

- (NSString *)selectionIndexesKeyPath {
	return [[self infoForBinding:SELECTIONINDEXES_BINDING_NAME] objectForKey:NSObservedKeyPathKey];
}

- (NSArray *)graphics
{	
    return [[self graphicsContainer] valueForKeyPath:[self graphicsKeyPath]];	
}

- (NSIndexSet *)selectionIndexes
{
	return [[self selectionIndexesContainer] valueForKeyPath:[self selectionIndexesKeyPath]];
}



- (void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[super viewWillMoveToSuperview:newSuperview];
	if (newSuperview == nil)
	{
		[self stopObservingGraphics:[self graphics]];
		[self unbind:GRAPHICS_BINDING_NAME];
		[self unbind:SELECTIONINDEXES_BINDING_NAME];
	}
}


- (void)setaString:(NSString *)x
{
	
	NSUndoManager *undo;
	undo = [self undoManager];
	[undo registerUndoWithTarget: self selector:@selector(setaString:) object:aString];
	[aString release];
	x = [x copy];
	aString = x;
	[self setNeedsDisplay:YES];
}

- (NSString *)aString {return aString;}

- (void)setbString:(NSString *)x
{	
	NSUndoManager *undo;
	undo = [self undoManager];
	[undo registerUndoWithTarget: self selector:@selector(setbString:) object:bString];
	[bString release];
	x = [x copy];
	bString = x;
	[self setNeedsDisplay:YES];
}

- (NSString *)bString {return bString;}

- (void)setcString:(NSString *)x
{	
	NSUndoManager *undo;
	undo = [self undoManager];
	[undo registerUndoWithTarget: self selector:@selector(setcString:) object:cString];
	[cString release];
	x = [x copy];
	cString = x;
	[self setNeedsDisplay:YES];
}

- (NSString *)cString {return cString;}

- (void)setdString:(NSString *)x
{	
	NSUndoManager *undo;
	undo = [self undoManager];
	[undo registerUndoWithTarget: self selector:@selector(setdString:) object:dString];
	[dString release];
	x = [x copy];
	dString = x;
	[self setNeedsDisplay:YES];
}

- (NSString *)dString {return dString;}



- (void)mouseDown:(NSEvent *)event
{
	[self mouseDragged:event];  
}


- (void)broadcast
{
    NSNotificationCenter *notify;
    notify =[NSNotificationCenter defaultCenter];
    [notify postNotificationName:@"transformChanged" object:nil];
}



// there is a much better method also dealing with colors in "Color Sampler" sample code
-(void)mouseDragged:(NSEvent *)event
{


//    NSPoint p = [event locationInWindow];
//    lastPoint = [self convertPoint:p fromView:self];
	NSPoint pos = [self convertPoint:[event locationInWindow] fromView:nil];

    if (!([event modifierFlags] & NSEventModifierFlagCommand))
    {
		NSLog(@"mouseDragged: %@", event);
        [self setPosition:pos];
        [self broadcast];
        [self setNeedsDisplay:YES];
    }
	/* from color sampler

	NSPoint pos = [self convertPoint:[event locationInWindow] fromView:nil];
	
	
	
	[self lockFocus];
	int pixelValue = NSReadPixel(pos);
	[self unlockFocus];
	[reportText setStringValue:[NSString stringWithFormat:@"At: (%.0f,%.0f) V = %.2f", pos.x, pos.y, pixelValue]];
*/
}



- (void) mouseUp:(NSEvent *) theEvent 
{ 
	NSLog(@"mouseUp:");
}

- (NSPoint)position { return position; }

- (void)setPosition:(NSPoint)value;
{
    position = value;
}




// Delegate methods
- (int)numberOfRowsInTableView:(NSTableView *)aTable
{
	 return [selArray count];
}




- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	NSString *columnKey = [aTableColumn identifier];
	SelData *aSel = [selArray objectAtIndex:rowIndex];
	return 	[aSel valueForKey:columnKey];
}


- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(int)rowIndex
{
	NSString *columnKey = [aTableColumn identifier];
	SelData *aSel = [selArray objectAtIndex:rowIndex];
	[aSel setValue:anObject forKey:columnKey];
}
/*
-(void)removeSelectionContainingIndex:(unsigned int)index
{
	unsigned int i;
NSLog(@"name %i",  index  );
int c = [selArray count];
NSLog(@"selArray items:%i",  c);
NSMutableIndexSet *selectionIndexesToBeRemoved = [NSMutableIndexSet indexSet];

	for (i = 0; i < c; i++) {
		
		SelData *aSel = [selArray objectAtIndex:i];
		NSArray *selection = [aSel sel];
	//	NSIndexSet *selection = [[selArray objectAtIndex:i]sel];
//			NSLog(@"selLastIndex:%i index-1:%i  i:%i  sel:%@",  [selection lastIndex], index-1, i, selection);
//			NSLog(@" comp: %@", ([selection lastIndex] > (index-1)));
			if ((int)[selection lastIndex] > (int)(index-1)) 
			{
				NSLog(@"TRUE selLastIndex:%i index-1:%i  i:%i  sel:%@",  [selection lastIndex], index-1, i, selection);
				[selectionIndexesToBeRemoved addIndex:i];
				}
	}
	if (selectionIndexesToBeRemoved != nil)
	{
		NSLog(@"selectionIndexesToBeRemoved %@", selectionIndexesToBeRemoved);
		[selArray removeObjectsAtIndexes:selectionIndexesToBeRemoved];
		[self setNeedsDisplay:YES];
		[selTable reloadData];
	}
	NSLog(@"selectionIndexesToBeRemoved %@", selectionIndexesToBeRemoved);

}
*/
- (void)broadcastSelAdd
{
    NSNotificationCenter *notify;
    notify =[NSNotificationCenter defaultCenter];
    [notify postNotificationName:@"selectionAdded" object:nil];
}

- (void)broadcastSelRemoved
{
    NSNotificationCenter *notify;
    notify =[NSNotificationCenter defaultCenter];
    [notify postNotificationName:@"selectionRemoved" object:nil];
}

-(IBAction)createSel:(id)sender
{
	[self broadcastSelAdd];

	SelData *newSel = [[SelData alloc] init]; 
	[newSel setCountOfSel:[selArray count]+1];
	[newSel setNoOfPoints:[[symbolController selectionIndexes] count]];
	[newSel setSel:[symbolController selectedObjects]];
//	NSLog(@"name %@",  [newSel countOfSel] );

	[selArray addObject:newSel];
	[newSel release];
	[self setNeedsDisplay:YES];
	[selTable reloadData];
}

-(IBAction)deleteSelectedSel:(id)sender
{
	[self broadcastSelRemoved];

	NSIndexSet *rows = [selTable selectedRowIndexes];
	
	if ([rows count] > 0) {
		unsigned int row = [rows lastIndex];
		
		while (row != NSNotFound) {
			[selArray removeObjectAtIndex:row];
			row = [rows indexLessThanIndex:row];
		}
		[self setNeedsDisplay:YES];
		[selTable reloadData];
	} else {
		NSBeep();
	}
}




- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
{
	if ([aNotification object] == selTable) {

		[self updateSel];}
		
		else {
			[selTable deselectAll:nil];
		}	
}

-(void)updateSel
{
	unsigned selectedRow = [selTable selectedRow];
	NSLog(@"vgfr %i",  selectedRow );

	if (selectedRow == -1)
		{
		// fill code to handle null selection
		}
	else		
	{
		[symbolController setSelectedObjects:[[selArray objectAtIndex:selectedRow] sel] ];
		[selTable selectRowIndexes:[NSIndexSet indexSetWithIndex: selectedRow] byExtendingSelection:NO];
        NSLog(@"selextion %lu,  %i", (unsigned long)[[[selArray objectAtIndex:selectedRow] sel] count], selectedRow );

	}
}	




@end
