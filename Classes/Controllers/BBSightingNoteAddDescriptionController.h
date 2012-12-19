//
//  BBSightingNoteAddDescriptionControllerViewController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 12/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "MGHelpers.h"
#import "BBUIControlHelper.h"
#import "BBCollectionHelper.h"
#import "BBModels.h"
#import "BBSightingNoteEditDescriptionController.h"

@interface BBSightingNoteAddDescriptionController : BBControllerBase

@property (nonatomic,strong) NSArray* descriptionsNotSelected;

-(BBSightingNoteAddDescriptionController *)initWithDescriptions:(NSArray*)descriptions;

@end