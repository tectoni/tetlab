//
//  Headers.h
//  Trinity
//
//  Created by Peter Appel on 20/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Headers : NSObject <NSCoding> {
	NSString *aHeader;
	NSString *bHeader;
	NSString *cHeader;
	NSString *dHeader;

}

-(NSString *)aHeader;
-(void)setAHeader:(NSString *)aAHeader;

-(NSString *)bHeader;
-(void)setBHeader:(NSString *)aBHeader;

-(NSString *)cHeader;
-(void)setCHeader:(NSString *)aCHeader;

-(NSString *)dHeader;
-(void)setDHeader:(NSString *)aDHeader;

@end
