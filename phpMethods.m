//
//  phpMethods.m
//  WorkHours
//
//  Created by Dario Caric on 11/04/16.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "phpMethods.h"

@interface phpMethods ()
{
    
}
@end


@implementation phpMethods


- (BOOL) checkIfAccountIsActive {
    
    BOOL result = false;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fileAccountpath = [documentsDirectoryPath
                                 stringByAppendingPathComponent:@"tableName.txt"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSLog(@"tableName.txt %@", [fm fileExistsAtPath:fileAccountpath] ? @"exists" : @"doesn't exist");
    if (![fm fileExistsAtPath:fileAccountpath]) {
        NSLog(@"tabelName.txt do not exists");
        result = FALSE;
        
        NSString *userMail = @"dcaric@me.com";
        NSString *urlStr = [NSString stringWithFormat:@"https://www.dariocaric.net/wh/readtablename1.php?mail=%@",userMail];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        
                        // handle response
                        NSLog(@"response=%@     error=%@",response,error);
                        
                        //NSString *updatePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hashKey.txt"];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
                        NSString *updatePath = [documentsDirectoryPath
                                                stringByAppendingPathComponent:@"tableName.txt"];
                        [data writeToFile:updatePath atomically:YES];
                        NSString *tableName = [NSString stringWithContentsOfFile:updatePath encoding:NSUTF8StringEncoding error:nil];
                        NSLog(@"tableName=%@",tableName);
                        
                    }] resume];
        
        
    }
    
    else
        result = TRUE;
    
    
    return result;
    
}


- (NSString *) getTableName {
    
     NSString *tableName = @"";
    
    //NSString *updatePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hashKey.txt"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fileAccountpath = [documentsDirectoryPath
                            stringByAppendingPathComponent:@"tableName.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileAccountpath])
        tableName = [NSString stringWithContentsOfFile:fileAccountpath encoding:NSUTF8StringEncoding error:nil];
    
    return tableName;
}


-(void) testMethod1
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // NETWORK ACTIONS
    });
    

    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI UPDATION
    });
    
    
}

@end