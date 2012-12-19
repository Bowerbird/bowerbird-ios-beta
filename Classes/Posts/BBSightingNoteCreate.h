//
//  BBSightingNoteCreate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSightingNoteDescriptionCreate.h"

@interface BBSightingNoteCreate : NSObject

@property (nonatomic, strong) NSString *identifier;
@property BOOL isCustomIdentification;
@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSMutableArray *descriptions;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *taxonomy;

-(void)addDescription:(BBSightingNoteDescriptionCreate*)description;

@end