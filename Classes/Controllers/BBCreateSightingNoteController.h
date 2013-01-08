//
//  BBIdentificationController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 4/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <RestKit/RKRequestSerialization.h>
#import "BBControllerBase.h"
#import "BBClassificationBrowseController.h"
#import "BBClassificationSearchController.h"
#import "BBUIControlHelper.h"
#import "BBStyles.h"
#import "MGHelpers.h"
#import "BBModels.h"
#import "BBCreateSightingNoteView.h"
#import "BBSightingNoteEditDelegateProtocol.h"
#import "DWTagList.h"
#import "BBSightingNoteAddDescriptionController.h"
#import "BBSightingNoteEditDescriptionController.h"
#import "BBSightingNoteDescriptionCreate.h"
#import "BBSightingNoteTagController.h"

@interface BBCreateSightingNoteController : BBControllerBase <
     RKObjectLoaderDelegate
    ,BBSightingNoteEditDelegateProtocol
>

@property (nonatomic,strong) BBSightingNoteEdit *sightingNote;

-(BBCreateSightingNoteController*)initWithSightingId:(NSString*)sightingId;

@end