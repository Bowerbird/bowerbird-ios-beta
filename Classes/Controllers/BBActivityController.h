//
//  BBActivityController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 30/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBHelpers.h"
#import "BBModels.h"
#import "BBSightingActivityController.h"
#import "BBSightingNoteActivityController.h"
#import "BBIdentificationActivityController.h"
#import "BBPostActivityController.h"

@interface BBActivityController : BBControllerBase

-(id)initWithActivity:(BBActivity*)activity;

@end