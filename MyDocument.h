//
//  MyDocument.h
//  TriPlot
//
//  Created by Peter Appel on 12/09/2007.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

/* MyDocument */

#import <Cocoa/Cocoa.h>
@class DiagramView;
@class Headers;
@class GraphicsArrayController;

@interface MyDocument : NSDocument
{
	NSMutableDictionary *dict;
	NSMutableArray *graphics;
	NSMutableArray *theLoadedSelArray;
//	Headers *loadedHeader;
	Headers *header;
    BOOL containsData;
	float alpha, theta;
	NSString *aLab;
	NSString *bLab;
	NSString *cLab;
	NSString *dLab;

	IBOutlet id mainWindow;
	IBOutlet DiagramView *diagramView;
	IBOutlet NSTableView *dataTable;
	IBOutlet GraphicsArrayController *graphicsController;
	IBOutlet NSButton *connectCheckbox;
	IBOutlet NSButton *showLabelsCheckbox;
	IBOutlet NSButton *updateButton;
	IBOutlet NSButton *showLabelsButton;
	IBOutlet id alphaSlider;
	IBOutlet id thetaSlider;
	IBOutlet id alphaField;
	IBOutlet id thetaField;
	IBOutlet NSTextField *textFieldA;
	IBOutlet NSTextField *textFieldB;
	IBOutlet NSTextField *textFieldC;
	IBOutlet NSTextField *textFieldD;
	IBOutlet NSPopUpButton *popup;
}

- (void)handleNotify:(NSNotification *)n;

-(void)setGraphics:(NSMutableArray *)aGraphics;
-(NSMutableArray *)graphics;

-(unsigned int)countOfGraphics;
-(id)objectInGraphicsAtIndex:(unsigned int)index;
-(void)insertObject:(id)anObject inGraphicsAtIndex:(unsigned int)index;
-(void)removeObjectFromGraphicsAtIndex:(unsigned int)index;
-(void)replaceObjectInGraphicsAtIndex:(unsigned int)index withObject:(id)anObject;
-(void)updateCellHeaders;
-(void)writeRecordsToTextFile:(NSString *)path;
-(void)openPanelDidEnd:(NSOpenPanel *)openPanel returnCode:(int)returnCode contextInfo:(void  *)contextInfo;
-(void) didEnd:(NSSavePanel *)sheet returnCode:(int)code contextInfo: (void *)contextInfo;

-(void)updateUI;

-(IBAction)savePDF:(id)sender;
-(IBAction)importTextFile:(id)sender;
-(IBAction)exportTextFile:(id)sender;
-(IBAction)updateLabels:(id)sender;
-(IBAction)connectPoints:(id)sender;
-(IBAction)showLabels:(id)sender;


@end
