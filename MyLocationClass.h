//
//  MyLocationClass.h
//  WorkHours
//
//  Created by Dario Caric on 18/04/16.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MyLocationClass : NSObject


- (BOOL) checkLocationinsideRadius:(int) maxRadius myLocation:(CLLocation *)localLocation locationForTest:(CLLocation *)testLocation;
- (int) checkMode;
- (void) writeMode:(int)localMode;
- (NSString *)getDate:(BOOL)noSeconds;

@end
