//
//  BBControllers.h
//  BowerBird
//
//  Created by Hamish Crittenden on 11/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBControllerHelper : NSObject

+(id)names;

@property (nonatomic,readonly,strong) NSString* authentication;
@property (nonatomic,readonly,strong) NSString* registration;
@property (nonatomic,readonly,strong) NSString* login;
@property (nonatomic,readonly,strong) NSString* home;
@property (nonatomic,readonly,strong) NSString* menu;
@property (nonatomic,readonly,strong) NSString* action;
@property (nonatomic,readonly,strong) NSString* projects;
@property (nonatomic,readonly,strong) NSString* chat;

@end