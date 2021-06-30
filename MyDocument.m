//
//  MyDocument.m
//  Trinity
//
//  Created by Peter Appel on 12/09/2007.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

#import "MyDocument.h"
#import "DiagramView.h"
#import "Headers.h"
#import "MyDocument_Pasteboard.h"

@implementation MyDocument

- (id)init
{

    self = [super init];
    if (self) {
		graphics =[[NSMutableArray alloc] init];
        containsData = NO;
        }

    NSLog(@"MyDocument - (id)init %@", self);
	
   return self;
}

- (void)awakeFromNib
{
	int k, count;

    /**** Add the title of your new demo to the END of this array. ****/
    NSArray *titles = [NSArray arrayWithObjects:	NSLocalizedString(@"Circle", @"Circle"),
													NSLocalizedString(@"Dot", @"Dot"),
													NSLocalizedString(@"Square", @"Square"),
													NSLocalizedString(@"FilledSquare", @"Filled Square"),
													nil];
	
    /* Zero out the menu. */
 	NSLog(@"MyDocument - (void)awakeFromNib %@", self);
	 	NSLog(@"MyDocument diagramView %@", diagramView);

   [popup removeAllItems];
    [self updateUI];
	[diagramView setShowLabelsYN:[showLabelsCheckbox state]];
	[diagramView setConnectPointsYN:[connectCheckbox state]];
	[self updateLabels:self];

	
	NSNotificationCenter *notify;
    notify =[NSNotificationCenter defaultCenter];
    [notify addObserver:self selector:@selector(handleNotify:) name:@"selectionAdded" object:nil];
	[notify addObserver:self selector:@selector(handleNotify:) name:@"selectionRemoved" object:nil];
	
	
	
    count = [titles count];
    for (k = 0; k < count; k++)
        [popup addItemWithTitle:[titles objectAtIndex:k]];
		
}



- (void)handleNotify:(NSNotification *)n
{
	NSString *notificationName = [n name];
	// Add the inverse of this operation to the undo stack
	if ([notificationName isEqualToString:@"selectionAdded"])
	{
		NSLog(@"selectionAdded ");
		[[self undoManager] registerUndoWithTarget:self selector:nil object:nil];
		
	}
	else if ([notificationName isEqualToString:@"selectionRemoved"])
	{
		NSLog(@"selectionRemoved");
		
		[[self undoManager] registerUndoWithTarget:self selector:nil object:nil];
		
	}
}




-(NSMutableArray *)graphics {return graphics;}

-(void)setGraphics:(NSMutableArray *)aGraphics
{
    if (graphics != aGraphics) {
        [graphics release];
        graphics = [aGraphics mutableCopy];
    }
}



-(unsigned int)countOfGraphics { return [graphics count];}


- (id)objectInGraphicsAtIndex:(unsigned int)index  {return [graphics objectAtIndex:index];}

- (void)insertObject:(id)anObject inGraphicsAtIndex:(unsigned int)index 
{
	[[self undoManager] registerUndoWithTarget:self selector:nil object:nil];
    [graphics insertObject:anObject atIndex:index];
}

- (void)removeObjectFromGraphicsAtIndex:(unsigned int)index 
{
	[[self undoManager] registerUndoWithTarget:self selector:nil object:nil];
	[graphics removeObjectAtIndex:index];	
//	[diagramView removeSelectionContainingIndex:index];

}

- (void)replaceObjectInGraphicsAtIndex:(unsigned int)index withObject:(id)anObject 
{
    [graphics replaceObjectAtIndex:index withObject:anObject];
}


- (void)dealloc
{
	[graphics release];
	//[self setGraphics:nil];
	[super dealloc];
}



-(void)updateCellHeaders
{
    NSTableHeaderCell *headerACell = [[NSTableHeaderCell alloc] init] ;
    [headerACell setStringValue:[textFieldA stringValue]];
    [headerACell setAlignment:NSTextAlignmentCenter];
    [[dataTable tableColumnWithIdentifier:@"aValue"] setHeaderCell:headerACell];
    [headerACell release];
    
    NSTableHeaderCell *headerBCell = [[NSTableHeaderCell alloc] init] ;
    [headerBCell setStringValue:[textFieldB stringValue]];
    [headerBCell setAlignment:NSTextAlignmentCenter];
    [[dataTable tableColumnWithIdentifier:@"bValue"] setHeaderCell:headerBCell];
    [headerBCell release];
    
    NSTableHeaderCell *headerCCell = [[NSTableHeaderCell alloc] init] ;
    [headerCCell setStringValue:[textFieldC stringValue]];
    [headerCCell setAlignment:NSTextAlignmentCenter];
    [[dataTable tableColumnWithIdentifier:@"cValue"] setHeaderCell:headerCCell];
    [headerCCell release];
    
    NSTableHeaderCell *headerDCell = [[NSTableHeaderCell alloc] init];
    [headerDCell setStringValue:[textFieldD stringValue]];
    [headerDCell setAlignment:NSTextAlignmentCenter];
    [[dataTable tableColumnWithIdentifier:@"dValue"] setHeaderCell:headerDCell];
    [headerDCell release];
    
}

- (void)updateUI
{
    [dataTable reloadData];
	[thetaField setFloatValue:([diagramView theta ])/3.14159265*180.0];
	[thetaSlider setFloatValue:([diagramView theta ])/3.14159265*180.0];
	
	[alphaField setFloatValue:([diagramView alpha])/3.14159265*180.0];
	[alphaSlider setFloatValue:([diagramView alpha ])/3.14159265*180.0];
NSLog(@"updateUI %@ %f", diagramView, [diagramView alpha]);
NSLog(@"updateUI %@ %f", diagramView, [diagramView theta]);

}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerWillLoadNib:(NSWindowController *)aController
{
	
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	[diagramView bind: @"graphics" toObject: graphicsController
		  withKeyPath:@"arrangedObjects" options:nil];
	[diagramView bind: @"selectionIndexes" toObject: graphicsController
		  withKeyPath:@"selectionIndexes" options:nil];
	if (containsData)
	{
		[diagramView setTheta:theta/3.14159265*180.0];
		[diagramView setAlpha:alpha/3.14159265*180.0];
		[thetaField setFloatValue:theta/3.14159265*180.0];
		[alphaField setFloatValue:alpha/3.14159265*180.0];
		[alphaSlider setFloatValue:alpha/3.14159265*180.0];
		[thetaSlider setFloatValue:theta/3.14159265*180.0];
	//	[diagramView setSelArray:theLoadedSelArray];
//		[self setHeader:loadedHeader];
		[header setAHeader:aLab];
		[header setBHeader:bLab];
		[header setCHeader:cLab];
		[header setDHeader:dLab];

		[textFieldA setStringValue:aLab];
		[textFieldB setStringValue:bLab];
		[textFieldC setStringValue:cLab];
		[textFieldD setStringValue:dLab];

// old implementatin - does not work any more		[textFieldD setStringValue:[NSString stringWithString:[header dHeader]]];
		[self updateLabels:self];
		[self updateUI];
	}
	
}

/*
- (BOOL)windowShouldClose:(id)sender
{
	int res = NSRunAlertPanel(		NSLocalizedString(@"Attention", @"Attention"),
									NSLocalizedString(@"ReallyClose", @"Do you really want to close this window?"),
									NSLocalizedString(@"Yes", @"No"),
									NSLocalizedString(@"No", @"Yes"),
									nil);
	
	
	if (1 ==res) { return YES;}
	else
	{ return NO; }
}

*/


/**************************************
IB ACTION METHODS
***************************************/

-(IBAction)updateLabels:(id)sender
{
	
	//[myView setaString:string];			alternativ möglich
	//[diagramView setaString:stringA];
	[header setAHeader:[textFieldA stringValue]];
	[header setBHeader:[textFieldB stringValue]];
	[header setCHeader:[textFieldC stringValue]];
	[header setDHeader:[textFieldD stringValue]];

	[diagramView setaString:[textFieldA stringValue]];
	[diagramView setbString:[textFieldB stringValue]];
	[diagramView setcString:[textFieldC stringValue]];
	[diagramView setdString:[textFieldD stringValue]];

//	[diagramView setValue:[textFieldA stringValue] forKey:@"aString"];
//	[diagramView setValue:[textFieldB stringValue] forKey:@"bString"];
//	[diagramView setValue:[textFieldC stringValue] forKey:@"cString"];
//	[diagramView setValue:[textFieldD stringValue] forKey:@"dString"];
	
	[diagramView setNeedsDisplay:YES]; //wird benötigt mit setValue: forKey
	
	[self updateCellHeaders];
	
}


-(IBAction)connectPoints:(id)sender
{
	NSLog(@"connectPoints");
	[diagramView setConnectPointsYN:[connectCheckbox state]];
	[diagramView setNeedsDisplay:YES];
}

-(IBAction)showLabels:(id)sender
{
	NSLog(@"showLabels");
	[diagramView setShowLabelsYN:[showLabelsCheckbox state]];
	[diagramView setNeedsDisplay:YES];
}


//
// The action for saving to PDF file. Just do a save panel and
// use -didEnd to handle results.
//
-(IBAction) savePDF:(id)sender
{
	NSSavePanel * panel = [NSSavePanel savePanel];
//	NSLog(@"savePDF",self);
	[panel setRequiredFileType: @"pdf"];
	[panel beginSheetForDirectory: nil
							 file: nil
				   modalForWindow: mainWindow
					modalDelegate: self
				   didEndSelector: @selector(didEnd:returnCode:contextInfo:)
					  contextInfo: nil];
}


//
// Do this after the PDF file target has been set.
//
-(void) didEnd: (NSSavePanel *)sheet returnCode:(int)code 
   contextInfo: (void *)contextInfo
{
	if(code == NSModalResponseOK)
	{
//		NSLog(@"didEnd called for %@", self);
		NSRect r = [diagramView bounds];
		NSData *data = [diagramView dataWithPDFInsideRect: r];
		[data writeToFile: [sheet.URL absoluteString] atomically: YES];
	}
}




/************************** Methods for TextFile Import **************************/

- (IBAction)importTextFile:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt:@"Choose File"];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];

    NSLog(@"importTextFile");
    
    //  [panel setNameFieldStringValue:nil];
    [panel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result)
    {
        if (result == NSModalResponseOK)
        {
            NSArray* urls = [panel URLs];
            NSString*    textFilePath = [[urls objectAtIndex: 0 ] absoluteString];
//            [graphicsController createRecordsFromTextFile:textFilePath];
        }
    }];
    
}

/************************** old Methods for TextFile Import ************************

- (IBAction)importTextFile:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSLog(@"importTextFile");
    [panel beginSheetForDirectory:nil
                             file:nil
                            types:nil
                   modalForWindow:mainWindow
                    modalDelegate:self
                   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
                      contextInfo:nil];
    [panel setCanChooseDirectories:NO];
    [panel setPrompt:@"Choose File"];
}


- (void)openPanelDidEnd:(NSOpenPanel *)openPanel returnCode:(int)returnCode contextInfo:(void  *)contextInfo
{
    NSString *textFilePath;
    NSLog(@"openPanelDidEnd");
    if (returnCode == NSOKButton) {
        textFilePath = [openPanel filename];
        [graphicsController createRecordsFromTextFile:textFilePath];
    }
}
*/

/************************** Methods for Writing data to Text File **************************/

- (IBAction)exportTextFile:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
//	NSLog(@"exportTextFile");	
	[panel setRequiredFileType:@"txt"];
    [panel beginSheetForDirectory:nil 
							 file:nil 
				   modalForWindow:mainWindow
					modalDelegate:self 
				   didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) 
					  contextInfo:nil];
    [panel setCanCreateDirectories:NO];
    [panel setPrompt:@"Save Text File"];
}



/************************** Archiving Methods **************************/



- (void)savePanelDidEnd:(NSSavePanel *)savePanel returnCode:(int)returnCode contextInfo:(void  *)contextInfo
{
    NSString *textFilePath;
    NSLog(@"savePanelDidEnd");
    if (returnCode == NSModalResponseOK) {
        textFilePath = [savePanel.URL absoluteString];
        [self writeRecordsToTextFile:textFilePath];
    }
}


- (void)writeRecordsToTextFile:(NSString *)path
{
    NSError *error = nil;
    NSMutableString *csvString = [NSMutableString string];
    NSEnumerator *pointEnum = [graphics objectEnumerator];
    id point;
    while ( point = [pointEnum nextObject] ) {
		NSString *string = [point valueForKey:@"identificator"];
        NSNumber *aV = [point valueForKey:@"aValue"];
        NSNumber *bV = [point valueForKey:@"bValue"];
		NSNumber *cV = [point valueForKey:@"cValue"];
		NSNumber *dV = [point valueForKey:@"dValue"];
        [csvString appendString:[NSString stringWithFormat:@"%@\t%@\t%@\t%@\t%@\n", string, aV, bV, cV, dV]]; // Tab delimited data
    }
    [csvString writeToFile:path atomically:YES encoding: NSASCIIStringEncoding error:&error];
}


/************************** Archiving Methods **************************/

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  
	// You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
	[graphicsController commitEditing];
	NSMutableData *data = [NSMutableData data];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	dict = [NSMutableDictionary dictionaryWithObject:graphics forKey: @"graphics"];
	[archiver encodeObject:dict forKey:@"mainDict"];
	[archiver encodeFloat:[diagramView alpha] forKey:@"winkelAlpha"];
	[archiver encodeFloat:[diagramView theta] forKey:@"winkelTheta"];
	[archiver encodeObject:[diagramView selArray] forKey:@"auswahl"];
//	[archiver encodeObject:header forKey:@"dieLabels"];

	[archiver encodeObject:[textFieldA stringValue] forKey:@"ersteLabel"];
	[archiver encodeObject:[textFieldB stringValue] forKey:@"zweiteLabel"];
	[archiver encodeObject:[textFieldC stringValue] forKey:@"dritteLabel"];
	[archiver encodeObject:[textFieldD stringValue] forKey:@"vierteLabel"];
	[archiver finishEncoding];
	[archiver release];
	return data;
	
    // For applications targeted for Tiger or later systems, you should use the new 
	// Tiger API -dataOfType:error:.  In this case you can also choose to override 
	// -writeToURL:ofType:error:, -fileWrapperOfType:error:, 
	// or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
}


- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
//    NSLog(@"About to read data of type %@", aType);
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    dict = [[unarchiver decodeObjectForKey:@"mainDict"] retain];
	alpha = [unarchiver decodeFloatForKey:@"winkelAlpha"];
	theta = [unarchiver decodeFloatForKey:@"winkelTheta"];
	theLoadedSelArray = [unarchiver decodeObjectForKey:@"auswahl"];

	aLab = [NSString stringWithString:[unarchiver decodeObjectForKey:@"ersteLabel"]];
	bLab = [NSString stringWithString:[unarchiver decodeObjectForKey:@"zweiteLabel"]];
	cLab = [NSString stringWithString:[unarchiver decodeObjectForKey:@"dritteLabel"]];
	dLab = [NSString stringWithString:[unarchiver decodeObjectForKey:@"vierteLabel"]];

	[unarchiver finishDecoding];
    [unarchiver release];

	if (dict == nil) {
		return NO;
	} else {
    [self setGraphics:[dict objectForKey:@"graphics"]];
		NSLog(@"label a %@", bLab);
		NSLog(@"alpha  %f", alpha);


	// For applications targeted for Tiger or later systems, you should use the new Tiger API 
	// readFromData:ofType:error:.  In this case you can also choose to override 
	// -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
	
		containsData=YES;
		return YES;
	}
}

/***************************************************************************
PRINT METHODS
***************************************************************************/

- (void)printShowingPrintPanel:(BOOL)flag 
{ 
     NSPrintOperation *printOp; 
	[[self printInfo] setHorizontalPagination:NSFitPagination];
    [[self printInfo] setHorizontallyCentered:YES];
    [[self printInfo] setVerticallyCentered:YES];
    
     printOp=[NSPrintOperation printOperationWithView:diagramView 
                                            printInfo:[self printInfo]]; 
     [printOp setShowPanels:flag]; 
     [self runModalPrintOperation:printOp 
                         delegate:nil 
                   didRunSelector:NULL 
                      contextInfo:NULL]; 
} 


/***************************************************************************
TABLE METHODS
***************************************************************************/

// Delegate methods
- (int)numberOfRowsInTableView:(NSTableView *)aTable
{
	if (aTable == dataTable)
    {return [graphics count];}
    else return 0;
}



@end
