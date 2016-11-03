//
//  LocationShareModel.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreData/CoreData.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationManager : NSObject

@property (nonatomic) CLLocationManager * anotherLocationManager;

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
@property (nonatomic) NSString *place;

@property (nonatomic) NSMutableDictionary *myLocationDictInPlist;
@property (nonatomic) NSMutableArray *myLocationArrayInPlist;

@property (nonatomic) BOOL afterResume;


@property (strong) NSManagedObject *device;


+ (id)sharedManager;

- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)startMonitoringLocationFrequently;
- (void) stopMonitorigLocation;
- (void) registerForMonitorLocation;


- (void)saveInBaseDate:(CLLocation *)locationLast;

@end
