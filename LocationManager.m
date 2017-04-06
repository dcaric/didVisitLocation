//
//  LocationShareModel.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import "MyLocationClass.h"
#import "CheckOutIn-Swift.h"
#include <os/log.h>

#import "Constants.h"

#define iPhoneConst @"iphone6_"
@interface LocationManager () <CLLocationManagerDelegate>
{
    
}
@end


@implementation LocationManager

static const double DEFAULT_DISTANCE_FILTER = 50.00;


//Class method to make sure the share model is synch across the app
+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


#pragma mark - CLLocationManager
// BEGIN LOCATION MANAGER *****************************************************************************
- (void) registerForMonitorLocation {
    NSLog(@"registerForMonitorLocation");
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // If status is not determined, then we should ask for authorization.
        [_anotherLocationManager requestAlwaysAuthorization];
        NSLog(@"requestAlwaysAuthorization");
        
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        // If authorization has been denied previously, inform the user.
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services" message:@"Location services were previously denied by the user. Please enable location services for this app in settings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        
    }
}

- (void)startMonitoringLocation {
    if (_anotherLocationManager)
        [_anotherLocationManager stopMonitoringVisits];
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    [_anotherLocationManager startMonitoringVisits];
    
}


- (void)restartMonitoringLocation {
    NSLog(@"restartMonitoringLocation startMonitoringVisits");
    
    [_anotherLocationManager stopMonitoringVisits];
    [_anotherLocationManager stopUpdatingLocation];
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    if (IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    [_anotherLocationManager startMonitoringVisits];
    
}


- (void) stopMonitorigLocation {
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    [_anotherLocationManager stopUpdatingLocation];
}

- (void) startMonitoringLocationFrequently {
    NSLog(@"startMonitoringLocationFrequently: stopMonitoringSignificantLocationChanges");
    
    if (_anotherLocationManager) {
        [_anotherLocationManager stopUpdatingLocation];
        [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    }
    
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    _anotherLocationManager.distanceFilter = DEFAULT_DISTANCE_FILTER;
    
    
    if(IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    //[_anotherLocationManager startUpdatingLocation];
    
    NSLog(@"startMonitoringLocationFrequently");
}



#pragma mark - CLLocationManager Delegate


// When the user has granted authorization, start the standard location service.
-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"didChangeAuthorizationStatus");
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        // Start the standard location service.
        [_anotherLocationManager startUpdatingLocation];
    }
}

// A core location error occurred.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}


- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    NSLog(@"didVisit BEGIN:");
    
    CLLocation *locationLast = [[CLLocation alloc] initWithLatitude:visit.coordinate.latitude longitude:visit.coordinate.longitude];
    
    NSTimeInterval locationAge = -[locationLast.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (locationLast.horizontalAccuracy < 0) return;
    
    NSLog(@"didVisit END:");
    [self saveInBaseDate:locationLast];
    
}




- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"locationManager1:");
    
    CLLocation *locationLast = [locations lastObject];
    
    NSTimeInterval locationAge = -[locationLast.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (locationLast.horizontalAccuracy < 0) return;
    
    [self saveInBaseDate:(CLLocation *)locationLast];
}
// END LOCATION MANAGER *****************************************************************************



// BEGIN LOCATION MANAGER *****************************************************************************
- (void)saveInBaseDate:(CLLocation *)locationLast
{
    
    NSLog(@"saveInBaseDate");
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    CoreDataWorker *myCoreDataObj = [[CoreDataWorker alloc] init];
    
    //NSNumber *myLatitude = [NSNumber numberWithDouble:locationLast.coordinate.latitude];
    //NSNumber *myLongitude = [NSNumber numberWithDouble:locationLast.coordinate.longitude];
    
    NSString *modeHome;
    if ([self checkPlaceIfInside:locationLast] == 0) {
        modeHome = MARKOUT;
    }
    else {
        modeHome = MARKIN;
    }
    
    NSString *strMode = @"0";
    NSString *home = @"";
    bool postOnServer = FALSE;
    if (([modeHome isEqualToString:MARKOUT]) && ([myCoreDataObj getLocationModeWithKeyVal:@"mode"] == 1)) {
        // chage from WORK to OUT_OF_WORK
        NSLog(@"chage from WORK to OUT_OF_WORK");
        [myCoreDataObj changeLocationModeWithModeKey:@"mode" modeVal:0];
        postOnServer = TRUE;
        home = MARKOUT;
    }
    
    if (([modeHome isEqualToString:MARKIN]) && ([myCoreDataObj getLocationModeWithKeyVal:@"mode"] == 0)) {
        // chage from OUT_OF_WORK to WORK
        NSLog(@"chage from OUT_OF_WORK to WORK");
        [myCoreDataObj changeLocationModeWithModeKey:@"mode" modeVal:1];
        strMode = @"1";
        postOnServer = TRUE;
        home = MARKIN;
    }
    
    NotificationLocal *myNotifObj = [[NotificationLocal alloc] init];
    
    // check if timestamp exists in database
    
    NSString *currentTimeStamp = [myLocationObj getDate:false];
    
    NSLog(@"date(false) = %@",currentTimeStamp);
    
    NSLog(@"QQQ from NSLog");
    os_log(OS_LOG_DEFAULT, "QQQ from os_log");
    
    if (!postOnServer) {
        
        [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"Before postOnServer [%ld] [%@]",(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"], currentTimeStamp]];
        
        NSLog(@"before postOnServer strMode=%ld",(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]);
        
    }
    if (postOnServer) {
        
        // Notify
        [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"Post on server [%@_%ld]",home,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]]];
        
        
        // Get a new value for main counter
        int mainCounter = [myCoreDataObj getLocationModeWithKeyVal:@"lastId"] + 1;
        NSLog(@"before mainCounter=%i",[myCoreDataObj getLocationModeWithKeyVal:@"lastId"]);
        [myCoreDataObj changeLocationModeWithModeKey:@"lastId" modeVal:mainCounter];
        NSLog(@"after mainCounter=%i",[myCoreDataObj getLocationModeWithKeyVal:@"lastId"]);
        
        
        // Save date, latitute and lungitude in coredata
        CoreDataWorker *myCoreDataObj = [[CoreDataWorker alloc] init];
        NSString *strLatitude = [NSString stringWithFormat:@"%f",locationLast.coordinate.latitude];
        NSString *strLongitude = [NSString stringWithFormat:@"%f",locationLast.coordinate.longitude];
        [myCoreDataObj storeTranscriptionWithDate:[NSString stringWithFormat:@"%@ - %@",currentTimeStamp, [NSString stringWithFormat:@"%@_%ld",modeHome,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]]] latitude:strLatitude longitude:strLongitude server:FALSE counter:mainCounter];
        
        
        // Send date, latitute and lungitude on server
        dispatch_queue_attr_t lowPriorityAttr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND,-1);
        dispatch_queue_t myQueueSerial = dispatch_queue_create ("dariocaric.net",lowPriorityAttr);
        dispatch_async(myQueueSerial, ^{
            [self postForTestNew:locationLast currentTime:currentTimeStamp place:[NSString stringWithFormat:@"%@_%ld",modeHome,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]] counter:mainCounter];
            
        });
        
    }
}

// Check if place is inside range
- (int)checkPlaceIfInside:(CLLocation *)locationLocal
{
    NSLog(@"checkPlaceIfInside");
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:latitudeConst longitude:longitudeConst];
    int result = 0;
    if ([myLocationObj checkLocationinsideRadius:RANGERADIUS myLocation:homeLocation locationForTest:locationLocal])
        result = 1;
    
    return result;
}


// Post on server
- (void) postForTestNew:(CLLocation *) locationLocal currentTime:(NSString *)currentTimeStamp place:(NSString *)strPlace counter:(int)counterVal
{
    //MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:URLCONST,counterVal,currentTimeStamp, @(locationLocal.coordinate.latitude), @(locationLocal.coordinate.longitude), strPlace];
    
    NSLog(@"urlStr=%@",urlStr);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    // handle response
                    NSLog(@"postForTest:response=%@     error=%@",response,error);
                    if (error == nil) {
                        // make update in CoreData
                        NSLog(@"Posted on server with counter=%i",counterVal);
                        
                    }
                    
                }
      
      
      ] resume];
    

    // here implement part for storing in CoreData, information about data stored on server
    // on that way APP will know what is missing on server
    // CoreData extend with <server=0/1>
    
}


@end
