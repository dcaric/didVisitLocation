//
//  MyLocationClass.m
//  WorkHours
//
//  Created by Dario Caric on 18/04/16.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import "MyLocationClass.h"
#import <UIKit/UIKit.h>
#define iPhoneConst @"iphone6_"


@interface MyLocationClass ()
{
    
}

@end

@implementation MyLocationClass



// Calculates if given location belongs inside radius around central location
// central location 0 myLocation
// given location = locationForTest
// output is BOOL: FALSE = location out the circle, TRUE = location inside the circle
-(BOOL) checkLocationinsideRadius:(int) maxRadius myLocation:(CLLocation *)localLocation locationForTest:(CLLocation *)testLocation
{
    NSLog(@"checkLocationinsideRadius");

    BOOL result = FALSE;

    
    CLLocationDistance meters = [testLocation distanceFromLocation:localLocation];
    if (meters < maxRadius) {
        result = TRUE;
        NSLog(@"INSIDE RADIUS OF %i m= TRUE",maxRadius);
    }
    else
        NSLog(@"INSIDE RADIUS OF %i m = FALSE",maxRadius);

    
    NSLog(@"meter=%f",meters);


    
    return result;
    
}

- (int) checkMode
{
    //int mode = 0;
    // read current working mode
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath
                              stringByAppendingPathComponent:@"workingMode.plist"];
    
    NSMutableArray *fileMutable = [NSMutableArray arrayWithContentsOfFile:fullFileName];

    return [fileMutable[0] intValue];
}

- (void) writeMode:(int)localMode
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath
                              stringByAppendingPathComponent:@"workingMode.plist"];
    
    NSMutableArray *array = [[NSMutableArray array] init];
    
    [array addObject:[NSString stringWithFormat:@"%i",localMode]];
    [array writeToFile:fullFileName atomically:TRUE];
    NSLog(@"New workingMode=%i",localMode);
    
}


@end
