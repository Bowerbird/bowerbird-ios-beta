//
//  BBJsonResponse.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 16/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBJsonResponse.h"

@implementation BBJsonResponse

@synthesize success = _success;

-(NSString*)success {
    return _success;
}
-(void)setSuccess:(NSString *)success {
    _success = success;
}

@end