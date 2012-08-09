//
//  CookieCutter.m
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "CookieCutter.h"

@implementation CookieCutter


+ (void) dumpCookies:(NSString *)msgOrNil {
    NSMutableString *cookieDescs    = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        [cookieDescs appendString:[CookieCutter cookieDescription:cookie]];
    }
    NSLog(@"------ [Cookie Dump: %@] ---------\n%@", msgOrNil, cookieDescs);
    NSLog(@"----------------------------------");
}

+ (NSString *) cookieDescription:(NSHTTPCookie *)cookie {
    
    NSMutableString *cDesc      = [[NSMutableString alloc] init];
    [cDesc appendString:@"[NSHTTPCookie]\n"];
    [cDesc appendFormat:@"  name            = %@\n",            [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cDesc appendFormat:@"  value           = %@\n",            [[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cDesc appendFormat:@"  domain          = %@\n",            [cookie domain]];
    [cDesc appendFormat:@"  path            = %@\n",            [cookie path]];
    [cDesc appendFormat:@"  expiresDate     = %@\n",            [cookie expiresDate]];
    [cDesc appendFormat:@"  sessionOnly     = %d\n",            [cookie isSessionOnly]];
    [cDesc appendFormat:@"  secure          = %d\n",            [cookie isSecure]];
    [cDesc appendFormat:@"  comment         = %@\n",            [cookie comment]];
    [cDesc appendFormat:@"  commentURL      = %@\n",            [cookie commentURL]];
    
    //  [cDesc appendFormat:@"  portList        = %@\n",            [cookie portList]];
    //  [cDesc appendFormat:@"  properties      = %@\n",            [cookie properties]];
    
    return cDesc;
}

@end
