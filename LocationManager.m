//
//  LocationShareModel.m
//  CheckOutIn
//
//  Created by Dario Caric on 29/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import "MyLocationClass.h"
#import "CheckOutIn-Swift.h"
#include <os/log.h>
#import "Constants.h"
#import "Logging.h"

//#define iPhoneConst @"iphone6_"
@interface LocationManager () <CLLocationManagerDelegate>
{
    
}
@property (nonatomic) CLLocationManager *anotherLocationManager;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) NSString *place;

@end


@implementation LocationManager


//Class method to make sure the share model is synch across the app
//+ (id)sharedManager {
//    static id sharedMyModel = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        sharedMyModel = [[self alloc] init];
//    });
//    
//    return sharedMyModel;
//}


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
    DLog(@"restartMonitoringLocation startMonitoringVisits");
    
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
    DLog(@"startMonitoringLocationFrequently: stopMonitoringSignificantLocationChanges");
    
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
    
    DLog(@"startMonitoringLocationFrequently");
}



#pragma mark - CLLocationManager Delegate

/**
 When the user has granted authorization, start the standard location service.
*/
 -(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DLog(@"didChangeAuthorizationStatus");
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        // Start the standard location service.
        [_anotherLocationManager startUpdatingLocation];
    }
}

/*
 A core location error delegate handler
*/
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"didFailWithError: %@", error);
}


/*
 This is core method for this APP. This method secures that iOS
 notifies APP about any location change detected by WiFi or 3G/LTE
 changes. After that it also helps with GPS but it mostly relies
 on WiFi and 3G/LTE changes which is energy efficient enought to
 be turned all the time.
*/
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    DLog(@"didVisit");
    
    CLLocation *locationLast = [[CLLocation alloc] initWithLatitude:visit.coordinate.latitude longitude:visit.coordinate.longitude];
    NSTimeInterval locationAge = -[locationLast.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    if (locationLast.horizontalAccuracy < 0) return;
    [self saveInBase:locationLast];
}



/*
 This method is regular locatin manager method and
 it is called if APP is in foreground to get better
 location accuracy since it uses GPS
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    DLog(@"locationManager");

    CLLocation *locationLast = [locations lastObject];
    NSTimeInterval locationAge = -[locationLast.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    if (locationLast.horizontalAccuracy < 0) return;
    [self saveInBase:(CLLocation *)locationLast];
}


/**
 Saves location and date in core data

*/
- (void)saveInBase:(CLLocation *)locationLast
{
    
    DLog(@"saveInBase");
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    CoreDataWorker *myCoreDataObj = [[CoreDataWorker alloc] init];
    

    NSString *modeHome;
    if ([self checkPlaceIfInside:locationLast] == 0) {
        modeHome = MARKOUT;
    }
    else {
        modeHome = MARKIN;
    }
    
    NSString *strMode = @"0";
    NSString *marker = MARKOUT;
    bool postOnServer = FALSE;
    // chage from INSIDE_RAGE to OUT_OF_RANGE
    if (([modeHome isEqualToString:MARKOUT]) && ([myCoreDataObj getLocationModeWithKeyVal:@"mode"] == 1)) {
        DLog(@"chage from INSIDE_RAGE to OUT_OF_RANGE");
        [myCoreDataObj changeLocationModeWithModeKey:@"mode" modeVal:0];
        postOnServer = TRUE;
    }
    
    // chage from OUT_OF_RANGE to INSIDE_RAGE
    if (([modeHome isEqualToString:MARKIN]) && ([myCoreDataObj getLocationModeWithKeyVal:@"mode"] == 0)) {
        DLog(@"chage from OUT_OF_RANGE to INSIDE_RAGE");
        [myCoreDataObj changeLocationModeWithModeKey:@"mode" modeVal:1];
        strMode = @"1";
        postOnServer = TRUE;
        marker = MARKIN;
    }
    
    NotificationLocal *myNotifObj = [[NotificationLocal alloc] init];
    
    // check if timestamp exists in database
    NSString *currentTimeStamp = [myLocationObj getDate:false];
    DLog(@"Current date = %@",currentTimeStamp);
    
    if (!postOnServer) {

#if DEBUG
        // Notification just for testing purposes
        [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"Before postOnServer [%ld] [%@]",(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"], currentTimeStamp]];
#endif

    }
    if (postOnServer) {

#if DEBUG
        /// Notification just for testing purposes
        [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"Post on server [%@_%ld]",marker,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]]];
#endif

        
        // Get a new value for main counter
        int mainCounter = [myCoreDataObj getLocationModeWithKeyVal:@"lastId"] + 1;
        DLog(@"before mainCounter=%i",[myCoreDataObj getLocationModeWithKeyVal:@"lastId"]);
        [myCoreDataObj changeLocationModeWithModeKey:@"lastId" modeVal:mainCounter];
        DLog(@"after mainCounter=%i",[myCoreDataObj getLocationModeWithKeyVal:@"lastId"]);
        
        
        // Save date, latitute and lungitude in coredata
        CoreDataWorker *myCoreDataObj = [[CoreDataWorker alloc] init];
        NSString *strLatitude = [NSString stringWithFormat:@"%f",locationLast.coordinate.latitude];
        NSString *strLongitude = [NSString stringWithFormat:@"%f",locationLast.coordinate.longitude];
        [myCoreDataObj storeTranscriptionWithDate:[NSString stringWithFormat:@"%@ - %@",currentTimeStamp, [NSString stringWithFormat:@"%@_%ld",modeHome,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]]] latitude:strLatitude longitude:strLongitude server:FALSE counter:mainCounter];
        
        
        // Send date, latitute and lungitude on server
        // commented for now, has to add valid domain + php script or some other way to post
        // on your server
//        dispatch_queue_attr_t lowPriorityAttr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND,-1);
//        dispatch_queue_t myQueueSerial = dispatch_queue_create ("dariocaric.net",lowPriorityAttr);
//        dispatch_async(myQueueSerial, ^{
//            [self postOnServer:locationLast currentTime:currentTimeStamp place:[NSString stringWithFormat:@"%@_%ld",modeHome,(long)[myCoreDataObj getLocationModeWithKeyVal:@"mode"]] counter:mainCounter];
//            
//        });

    }
}



/**
 Check if place is inside given range

 Returns:

    1 - if location is inside range

    0 - if location is out of range

*/
- (int)checkPlaceIfInside:(CLLocation *)locationLocal
{
    DLog(@"checkPlaceIfInside");
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:latitudeConst longitude:longitudeConst];
    int result = 0;
    if ([myLocationObj checkLocationinsideRadius:RANGERADIUS myLocation:homeLocation locationForTest:locationLocal])
        result = 1;
    
    return result;
}



/**

 Posts on server timestamp

*/
// method is fine but it is not active since it has to be designed
// own php or some other script to post on server
// this is just for the demo purpose to show that even if app was killed, not active
// and in background it can post on server in this small period of time
// when iOS wakes it to inform about location update
// - (void) postOnServer:(CLLocation *) locationLocal currentTime:(NSString *)currentTimeStamp place:(NSString *)strPlace counter:(int)counterVal
//{
//
//    NSString *urlStr = [NSString stringWithFormat:URLCONST,counterVal,currentTimeStamp, @(locationLocal.coordinate.latitude), @(locationLocal.coordinate.longitude), strPlace];
//    
//    DLog(@"urlStr=%@",urlStr);
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
//    
//    
//    [[session dataTaskWithRequest:request
//                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                    
//                    // handle response
//                    DLog(@"postForTest:response=%@     error=%@",response,error);
//                    if (error == nil) {
//                        // make update in CoreData
//                        DLog(@"Posted on server with counter=%i",counterVal);
//                        
//                    }
//                    
//                }
//      
//      
//      ] resume];
//}


@end
