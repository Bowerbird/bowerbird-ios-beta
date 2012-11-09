//
//  BBCategory.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCategory : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* taxonomy;

@end