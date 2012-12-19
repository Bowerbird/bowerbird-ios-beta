//
//  BBSightingNoteEdit.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSightingNoteEdit : NSObject

-(BBSightingNoteEdit*)initWithSightingId:(NSString*)sightingId;

@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSString *taxonomy;
@property (nonatomic,strong) NSMutableDictionary *descriptions;
@property (nonatomic,strong) NSMutableSet *tags;

@end