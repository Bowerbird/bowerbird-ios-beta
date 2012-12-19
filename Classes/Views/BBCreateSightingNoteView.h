//
//  BBCreateSightingNoteView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSightingNoteEditDelegateProtocol.h"
#import "BBUIControlHelper.h"
#import "MGHelpers.h"
#import "BBClassification.h"
#import "DWTagList.h"

@interface BBCreateSightingNoteView : MGScrollView

@property (nonatomic,weak) id<BBSightingNoteEditDelegateProtocol> controller;

-(BBCreateSightingNoteView*)initWithDelegate:(id<BBSightingNoteEditDelegateProtocol>)delegate
                                     andSize:(CGSize)size;

-(void)displayIdentification:(BBClassification*)classification;

-(void)displayDescriptions;

-(void)displayTags;

@end