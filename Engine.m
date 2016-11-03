//
//  Engine.m
//  CroatiaFerry
//
//  Created by Dario Caric on 7/16/10.
//  Copyright 2010 DC. All rights reserved.
//

#import "Engine.h"



@implementation Engine

static Engine *_sharedInstance;

- (id) init
{
	if (self = [super init])
	{
		// custom initialization
		memset(state, 0, sizeof(state));
	}
	return self;
}

+ (Engine *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[Engine alloc] init];
	}
	
	return _sharedInstance;
}

- (NSUInteger) getFieldValueAtPos:(NSUInteger)x
{
	return state[x];
}

- (void) setFieldValueAtPos:(NSUInteger)x ToValue:(NSUInteger)newVal
{
	state[x] = newVal;
}

@end