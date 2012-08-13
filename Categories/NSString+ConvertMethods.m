//
//  NSString+ConvertMethods.m
//  BowerBird
//
//  Created by Hamish Crittenden on 13/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "NSString+ConvertMethods.h"

@implementation NSString (ConvertMethods)

+(NSString *)ConvertFromArrayContents: (NSArray *)arrayOfStrings
{
    NSString* stringFromArrayContents = [[NSString alloc]init];
    
    for(NSString* str in arrayOfStrings)
    {
        stringFromArrayContents = [NSString stringWithFormat:@"%@%@", stringFromArrayContents, str];
    }
    
    return stringFromArrayContents;
}

@end
