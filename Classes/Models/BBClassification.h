//
//  BBClassification.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 3/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBClassification : NSObject

@property (nonatomic,strong) NSString* taxonomy;
@property (nonatomic,strong) NSString* name;
@property int rankPosition;
@property (nonatomic,strong) NSString* rankName;
@property (nonatomic,strong) NSString* rankType;
@property (nonatomic,strong) NSString* parentRankName;
@property (nonatomic,strong) NSArray* ranks;
@property (nonatomic,strong) NSString* category;
@property int speciesCount;
@property (nonatomic,strong) NSArray* commonGroupNames;
@property (nonatomic,strong) NSArray* commonNames;
@property (nonatomic,strong) NSArray* synonyms;
@property (nonatomic,strong) NSString* allCommonNames;

@end