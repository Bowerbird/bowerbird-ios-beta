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
@synthesize action = _action;

-(NSString*)success {
    return _success;
}
-(void)setSuccess:(NSString *)success {
    _success = success;
}

-(NSString*)action {
    return _action;
}
-(void)setAction:(NSString *)action {
    _action = action;
}

@end