//
//  Headers.m
//  Trinity
//
//  Created by Peter Appel on 20/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Headers.h"


@implementation Headers


-(id)init
{
if (self = [super init])
{
		[self setAHeader:@"rechts"];
		[self setBHeader:@"op"];
		[self setCHeader:@"links"];
		[self setDHeader:@"hinten"];
}
return self;
}


-(void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:aHeader forKey:@"aHeader"];
	[coder encodeObject:bHeader forKey:@"bHeader"];
	[coder encodeObject:cHeader forKey:@"cHeader"];
	[coder encodeObject:dHeader forKey:@"dHeader"];
}

-(id)initWithCoder:(NSCoder *)coder
{
	if (self = [super init]) {
		[self setAHeader:[coder decodeObjectForKey:@"aHeader"]];
		[self setBHeader:[coder decodeObjectForKey:@"bHeader"]];
		[self setCHeader:[coder decodeObjectForKey:@"cHeader"]];
		[self setDHeader:[coder decodeObjectForKey:@"dHeader"]];
	}
	return self;
}

- (void)setAHeader:(NSString *)x
{
	x = [x copy];
	[aHeader release];
	aHeader = x;
}

- (void)setBHeader:(NSString *)x
{
	x = [x copy];
	[bHeader release];
	bHeader = x;
}

- (void)setCHeader:(NSString *)x
{
	x = [x copy];
	[cHeader release];
	cHeader = x;
}

- (void)setDHeader:(NSString *)x
{
	x = [x copy];
	[dHeader release];
	dHeader = x;
}

- (NSString *)aHeader
{
	return aHeader;
}

- (NSString *)bHeader
{
	return bHeader;
}

- (NSString *)cHeader
{
	return cHeader;
}

- (NSString *)dHeader
{
	return dHeader;
}


-(void)dealloc
{
[aHeader release];
[bHeader release];
[cHeader release];
[dHeader release];
[super dealloc];
}

@end
