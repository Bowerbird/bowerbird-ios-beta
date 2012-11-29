//
//  NSString+helpers.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 29/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "NSString+helpers.h"

@implementation NSString (helpers)

-(NSString*)capitalizeFirstLetter{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                         withString:[[self  substringToIndex:1] capitalizedString]];
}

@end