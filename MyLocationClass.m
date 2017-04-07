//
//  MyLocationClass.m
//  CheckOutIn
//
//  Created by Dario Caric on 18/04/16.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import "MyLocationClass.h"
#import <UIKit/UIKit.h>
#import "Logging.h"

//#define iPhoneConst @"iphone6_"


@interface MyLocationClass ()
{
    
}

@end

@implementation MyLocationClass


/**
 Calculates if given location belongs inside radius around
 referent location

 
 * locationForTest is referent location
 * myLocation is my current location

*/
-(BOOL) checkLocationinsideRadius:(int) maxRadius myLocation:(CLLocation *)localLocation locationForTest:(CLLocation *)testLocation
{
    DLog(@"checkLocationinsideRadius");

    BOOL result = FALSE;
    CLLocationDistance meters = [testLocation distanceFromLocation:localLocation];
    if (meters < maxRadius) {
        result = TRUE;
        DLog(@"INSIDE RADIUS OF %i m= TRUE",maxRadius);
    }
    else
        DLog(@"INSIDE RADIUS OF %i m = FALSE",maxRadius);

    DLog(@"meter=%f",meters);
    return result;
    
}


/**
 Returns date
*/
- (NSString *)getDate:(BOOL)noSeconds
{
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    if (noSeconds)
        [outputFormatter setDateFormat:@"HH:mm"];
    
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *newDateString = [outputFormatter stringFromDate:now];
    DLog(@"newDateString %@", newDateString);
    
    NSDateFormatter *outputFormatterYear = [[NSDateFormatter alloc] init];
    [outputFormatterYear setDateFormat:@"YYYY:MM:dd"];
    NSString *newDateStringYear = [outputFormatterYear stringFromDate:now];
    DLog(@"newDateStringYear %@", newDateStringYear);
    
    NSString *fullDateTime = [NSString stringWithFormat:@"%@%@%@",newDateStringYear,@"-",newDateString];
    
    return fullDateTime;
}



@end
