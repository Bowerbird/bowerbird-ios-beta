//
//  GuidGenerator.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//


// This code was pulled from: http://blog.ablepear.com/2010/09/creating-guid-or-uuid-in-objective-c.html

#import "GuidGenerator.h"

@implementation GuidGenerator

// return a new autoreleased UUID string
+(NSString *)generateGuid
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

@end
