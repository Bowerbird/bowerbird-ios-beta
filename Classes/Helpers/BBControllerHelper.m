//
//  BBControllers.m
//  BowerBird
//
//  Created by Hamish Crittenden on 11/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBControllerHelper.h"

@implementation BBControllerHelper

static BBControllerHelper* controllers = nil;

+(BBControllerHelper*)names
{
    if(controllers == nil)
    {
        controllers = [[super allocWithZone:NULL]init];
    }
    
    return controllers;
}

-(NSString*)authentication { return @"Authentication"; }
-(NSString*)registration { return @"Registration"; }
-(NSString*)login { return @"Login"; }
-(NSString*)home { return @"Home"; }
-(NSString*)menu { return @"Menu"; }
-(NSString*)action { return @"Action"; }
-(NSString*)projects { return @"Projects"; }
-(NSString*)chat { return @"Chat"; }

@end