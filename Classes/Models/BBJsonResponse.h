//
//  BBJsonResponse.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 16/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBJsonResponse : NSObject

@property (nonatomic,retain) NSString *success;
@property (nonatomic,retain) NSString *action;

@end