//
//  BBSightingNoteDescription.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCreateSightingNoteView.h"

@interface BBSightingNoteDescription : NSObject

-(BBSightingNoteDescription*)initWithProperties:(NSString*)descriptionId
                                          group:(NSString*)descriptionGroup
                                     groupLabel:(NSString*)descriptionGroupLabel
                                           name:(NSString*)descriptionName
                                    description:(NSString*)descriptionDescription;

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* group;
@property (nonatomic,strong) NSString* label;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* text;

+(NSArray*)getSightingNoteDescriptions;

+(BBSightingNoteDescription*)getDescriptionByIdentifier:(NSString*)identifier;

@end