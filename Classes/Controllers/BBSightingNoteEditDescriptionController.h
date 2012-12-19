//
//  BBSightingNoteEditDescriptionController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 12/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBSightingNoteDescription.h"
#import "BBModels.h"
#import "BBCollectionHelper.h"

@interface BBSightingNoteEditDescriptionController : BBControllerBase <
    UITextFieldDelegate
>

-(BBSightingNoteEditDescriptionController *)initWithDescription:(BBSightingNoteDescription*)description;

@end