//
//  CookieCutter.h
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookieCutter : NSObject

+ (void) dumpCookies:(NSString *)msgOrNil;

+ (NSString *) cookieDescription:(NSHTTPCookie *)cookie;

@end
