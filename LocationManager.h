//
//  LocationShareModel.h
//  CheckOutIn
//
//  Created by Dario Caric on 29/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreData/CoreData.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationManager : NSObject


//+ (id)sharedManager;

- (void) startMonitoringLocation;
- (void) stopMonitorigLocation;
- (void) restartMonitoringLocation;
- (void) startMonitoringLocationFrequently;

@end
