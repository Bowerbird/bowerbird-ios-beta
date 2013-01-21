//
//  BBSightingNoteEdit.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

// this is the object which is created in the interface, but not posted to the server
@interface BBSightingNoteEdit : NSObject

-(BBSightingNoteEdit*)initWithSightingId:(NSString*)sightingId;

@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSString *taxonomy;
@property (nonatomic,strong) NSMutableDictionary *descriptions;
@property (nonatomic,strong) NSMutableSet *tags;

@end