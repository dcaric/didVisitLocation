//
//  Engine.h
//  CroatiaFerry
//
//  Created by Dario Caric on 7/16/10.
//  Copyright 2010 DC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Engine : NSObject {
	NSUInteger state[10];  // c-style array
}

+ (Engine *) sharedInstance;

- (NSUInteger) getFieldValueAtPos:(NSUInteger)x;
- (void) setFieldValueAtPos:(NSUInteger)x ToValue:(NSUInteger)newVal;

@end
