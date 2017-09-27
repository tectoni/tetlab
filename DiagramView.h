/* DiagramView */

#import <Cocoa/Cocoa.h>
@class Symbol;
@class Headers;
@class SelData;

@interface DiagramView : NSView
{	
	NSMutableArray *selArray;
	float alpha, theta;
	NSArray *oldGraphics;

	BOOL saveable;
	BOOL connectPointsYN;
	BOOL showLabelsYN;
	
	NSMutableDictionary *bindingInfo;
    NSMutableDictionary *attributes;
	NSString *aString;
	NSString *bString;
	NSString *cString;
	NSString *dString;
	
	NSPoint lastPoint;
	NSPoint position;

	IBOutlet NSWindow *window;
	IBOutlet NSMenu *zoomMenu;
	IBOutlet id controller;
	IBOutlet NSArrayController *symbolController;
	IBOutlet NSTableView *selTable;
}

-(IBAction)createSel:(id)sender;
-(IBAction)deleteSelectedSel:(id)sender;
-(IBAction)zoomLevel:(id)sender;
-(IBAction)changeThetaSlider:(id)sender;
-(IBAction)changeAlphaSlider:(id)sender;


- (void)broadcastSelAdd;
- (void)broadcastSelRemoved;


// Getter & Setter Methods
-(void)setAlpha:(float)newAlpha;
-(float)alpha;
-(void)setTheta:(float)newTheta;
-(float)theta;
-(void)setaString:(NSString *)x;
-(NSString *)aString;
-(void)setbString:(NSString *)x;
-(NSString *)bString;
-(void)setcString:(NSString *)x;
-(NSString *)cString;
-(void)setdString:(NSString *)x;
-(NSString *)dString;
-(void)setShowLabelsYN:(BOOL)sender;
-(BOOL)showLabelsYN;
-(void)setConnectPointsYN:(BOOL)sender;


-(BOOL)connectPointsYN;
-(void)setSelArray:(NSMutableArray *)aSelArray;
-(NSMutableArray *)selArray;
-(void)setPosition:(NSPoint)value;
-(NSPoint)position;
- (BOOL)saveable;
- (void)setSaveable:(BOOL)yn;

-(void)broadcast;
-(void)drawRect:(NSRect)rect;
-(void)tableViewSelectionDidChange:(NSNotification *)aNotification;
-(void)updateSel;
-(NSPoint)convertBary2Cartesian:(float)a b:(float)b c:(float)c d:(float)d;
- (void)prepareAttributes;
- (NSArray *)oldGraphics;
- (void)setOldGraphics:(NSArray *)anOldGraphics;

//-(void)removeSelectionContainingIndex:(unsigned int)index;

// bindings-related -- infoForBinding and convenience methods
- (NSDictionary *)infoForBinding:(NSString *)bindingName;
- (id)graphicsContainer;
- (NSString *)graphicsKeyPath;
- (id)selectionIndexesContainer;
- (void)startObservingGraphics:(NSArray *)graphics;
- (void)stopObservingGraphics:(NSArray *)graphics;

-(NSString *)selectionIndexesKeyPath;
-(NSArray *)graphics;

-(NSIndexSet *)selectionIndexes;


@end
