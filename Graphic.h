//
//  Graphic.h
//  DrPlot
//
//  Created by Peter Appel on 19/12/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


//extern NSString *GraphicDrawingBoundsKey;
extern NSString *GraphicDrawingContentsKey;

/*
 Graphic protocol to define methods all graphics objects must implement
 */

@protocol Graphic
//+ (NSSet *)keysForValuesAffectingDrawingBounds;
+ (NSSet *)keysForValuesAffectingDrawingContents;
//- (NSRect)drawingBounds; Methode ist bei dieser Implementierung redundant, da die Koordinaten im Modell nicht bekannt sind.
-(void)drawInView:(NSView *)aView withBounds:(NSRect)symbolRect;
/* - (float)xLoc;
- (void)setXLoc:(float)aXLoc;
- (float)yLoc;
- (void)setYLoc:(float)aYLoc;
 */

-(float)radius;
-(void)setRadius:(float)aRadius;


-(float)aValue;
-(void)setaValue:(float)aAValue;

-(float)bValue;
-(void)setbValue:(float)aBValue;

-(float)cValue;
-(void)setcValue:(float)aCValue;

-(float)dValue;
-(void)setdValue:(float)aDValue;


- (BOOL)hitTest:(NSPoint)point isSelected:(BOOL)isSelected;

@end
