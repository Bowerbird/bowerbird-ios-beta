//
//  BBSightingNoteTagController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 17/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBModels.h"
#import "BBCollectionHelper.h"
#import "MGHelpers.h"
#import "DWTagList.h"

@interface BBSightingNoteTagController : BBControllerBase <
     UITextFieldDelegate
    ,DWTagListDelegate
>

-(BBSightingNoteTagController*)initWithDelegate:(id<BBSightingNoteEditDelegateProtocol>)delegate;

@property (nonatomic,weak) id<BBSightingNoteEditDelegateProtocol> controller;

@end