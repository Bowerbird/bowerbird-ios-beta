//
//  BBIdentification.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBIdentification : NSObject

@property BOOL isCustomIdentification;
@property (nonatomic,strong) NSString* category;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* rankName;
@property (nonatomic,strong) NSString* rankType;
@property (nonatomic,strong) NSArray* commonGroupNames;
@property (nonatomic,strong) NSArray* commonNames;
@property (nonatomic,strong) NSString* taxonomy;
@property (nonatomic,strong) NSArray* taxonomicRanks;
@property (nonatomic,strong) NSArray* synonyms;
@property (nonatomic,strong) NSString* allCommonNames;

@end