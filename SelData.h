//
//  SelData.h
//  DynamicSelections
//
//  Created by Peter Appel on 03/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SelData : NSObject <NSCoding>
{
	NSArray *sel;
//	NSIndexSet *sel;
	NSInteger countOfSel;
    NSInteger noOfPoints;
}

- (NSInteger)noOfPoints;
- (void)setNoOfPoints:(NSInteger)aNoOfPoints;

- (NSInteger)countOfSel;
- (void)setCountOfSel:(NSInteger)aCountOfSel;


- (NSArray *)sel;
-(void)setSel:(NSArray *)aSel;


// - (NSIndexSet *)sel;
// -(void)setSel:(NSIndexSet *)aSel;


@end
