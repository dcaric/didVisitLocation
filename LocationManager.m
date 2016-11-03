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
//#import "ViewController.h"
#import "WorkHours3-Swift.h"
#import "Engine.h"

#define iPhoneConst @"iphone6_"
@interface LocationManager () <CLLocationManagerDelegate>
{
    BOOL AtWork;
}
@end


@implementation LocationManager

static const double DEFAULT_DISTANCE_FILTER = 50.00;

/*
- (NSManagedObjectContext *)managedObjectContext {

    NSManagedObjectContext *context = nil;

    id delegate = [[UIApplication sharedApplication] delegate];

    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
*/

//Class method to make sure the share model is synch across the app
+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


- (NSString *)returnDate
{
    NSString *strDate;
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    
    NSDateFormatter *outputFormatterYear = [[NSDateFormatter alloc] init];
    [outputFormatterYear setDateFormat:@"YYYY:MM:dd"];
    NSString *newDateStringYear = [outputFormatterYear stringFromDate:now];
    NSLog(@"newDateStringYear %@", newDateStringYear);
    
    strDate = [NSString stringWithFormat:@"%@%@%@",newDateStringYear,@"-",newDateString];
    
    return strDate;
}


#pragma mark - CLLocationManager



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
    NSLog(@"didVisit:");

    CLLocation *locationLast = [[CLLocation alloc] initWithLatitude:visit.coordinate.latitude longitude:visit.coordinate.longitude];
    
    NSTimeInterval locationAge = -[locationLast.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (locationLast.horizontalAccuracy < 0) return;
    
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



- (void)saveInBaseDate:(CLLocation *)locationLast
{
    
    NSLog(@"saveInBaseDate");
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];

    NSNumber *myLatitude = [NSNumber numberWithDouble:locationLast.coordinate.latitude];
    NSNumber *myLongitude = [NSNumber numberWithDouble:locationLast.coordinate.longitude];
    
    NSString *modeHome;
    if ([self checkPlaceIfInside:locationLast] == 0) {
        modeHome = @"OUT_OF_WORK";
    }
    else {
        modeHome = @"WORK";
    }
    
    
    NSString *strMode = @"0";
    NSString *home;
    bool postOnServer = FALSE;
    if (([modeHome isEqualToString:@"OUT_OF_WORK"]) && ([myLocationObj checkMode] == 1)) {
        // chage from WORK to OUT_OF_WORK
        [myLocationObj writeMode:0];
        postOnServer = TRUE;
        home = @"Out of WORK";
    }
    
    if (([modeHome isEqualToString:@"WORK"]) && ([myLocationObj checkMode] == 0)) {
        // chage from OUT_OF_WORK to WORK
        [myLocationObj writeMode:1];
        strMode = @"1";
        postOnServer = TRUE;
        home = @"WORK";
    }
    
    NotificationLocal *myNotifObj = [[NotificationLocal alloc] init];
    [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"%@_%d",home,[myLocationObj checkMode]]];

    NSLog(@"before postOnServer strMode=%@",strMode);

    if (postOnServer) {
        
        [myNotifObj triggerNotificationWithTitle:@"INFO" body:[NSString stringWithFormat:@"Post on server %@_%d",home,[myLocationObj checkMode]]];

        NSString *dateAndMode = [NSString stringWithFormat:@"%@ - %@",[self returnDate],modeHome];
        
        // Save in coredata
        CoreDataWorker *myCoreWorker = [[CoreDataWorker alloc] init];
        [myCoreWorker storeTranscriptionWithDate:dateAndMode latitude:[myLatitude stringValue] longitude:[myLongitude stringValue]];
        NSLog(@"after CoreDataWorker strMode=%@",strMode);

        // Send on server
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self postForTestNew:locationLast place:[NSString stringWithFormat:@"%@_%@",modeHome,strMode]];
        });
        

    }

}


- (int)checkPlaceIfInside:(CLLocation *)locationLocal
{
    NSLog(@"checkPlaceIfInside");
    
    
    MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];
    
    CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:43.5084 longitude:16.4719];
    // jelsa 43.161120, 16.693168
    // split 43.512678, 16.461408
    // Work 43.5084, 16.4719
    

    
    int result = 0;
    
    if ([myLocationObj checkLocationinsideRadius:100 myLocation:homeLocation locationForTest:locationLocal])
        result = 1;

    
    return result;
}

- (void) postForTestNew:(CLLocation *) locationLocal place:(NSString *)strPlace
{
    //MyLocationClass *myLocationObj = [[MyLocationClass alloc] init];

    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    
    NSDateFormatter *outputFormatterYear = [[NSDateFormatter alloc] init];
    [outputFormatterYear setDateFormat:@"YYYY:MM:dd"];
    NSString *newDateStringYear = [outputFormatterYear stringFromDate:now];
    NSLog(@"newDateStringYear %@", newDateStringYear);
    
    NSString *fullDateTime = [NSString stringWithFormat:@"%@%@%@",newDateStringYear,@"-",newDateString];
    
    //strPlace = [NSString stringWithFormat:@"%@%@%i",strPlace,@"_",[myLocationObj checkMode]];
    
        NSString *urlStr = [NSString stringWithFormat:@"https://www.dariocaric.net/wh/postForTest1.php?date=%@&latitude=%@&longitude=%@&place=%@",fullDateTime, @(locationLocal.coordinate.latitude), @(locationLocal.coordinate.longitude), strPlace];
    
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
                    
                    
                }] resume];
}


@end
