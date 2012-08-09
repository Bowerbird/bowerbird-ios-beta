//
//  NSNumber+NSNumber_ConvertMethods.m
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "NSNumber+ConvertMethods.h"

@implementation NSNumber (ConvertMethods)

+(NSNumber *)ConvertFromString: (NSString *)stringNumber
{
    return [NSNumber numberWithInteger:[stringNumber integerValue]];
}

@end