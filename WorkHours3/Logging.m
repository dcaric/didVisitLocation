//
//  Logging.m
//  CheckOutIn
//
//  Created by Dario Caric on 07/04/2017.
//  Copyright © 2017 Dario Caric. All rights reserved.
//

#import "Logging.h"

@implementation Logging

void DLog(NSString* format, ...)
{
#if DEBUG
    format = [NSString stringWithFormat:@"LOG: %@", format];
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#endif
}

@end
