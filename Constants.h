//
//  Constants.h
//  CheckOutIn
//
//  Created by Dario Caric on 07/11/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MARKIN @"WORK"
#define MARKOUT @"OUT_OF_WORK"

// this is only template and it is not working 
#define URLCONST @"https://www.domain.com/phpscript.php?counter=%i&date=%@&latitude=%@&longitude=%@&place=%@"


#define DEFAULT_DISTANCE_FILTER 50.00;

// Input arguments
// Latitude and longitude for the location for which you want that app works
// App is creating timestamps when you arrive on this location and
// when you leave location
// It is also important range radius set in meters
#define latitudeConst 43.5084
#define longitudeConst 16.4719
#define RANGERADIUS 200


@interface Constants : NSObject

@end
