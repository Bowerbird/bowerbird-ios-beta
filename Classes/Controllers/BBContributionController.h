//
//  BBObservationController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBControllerBase.h"
#import "BBObservationEditController.h"
#import "MGHelpers.h"
#import "BBHelpers.h"
#import "BBSightingEditView.h"
#import "BBSightingEdit.h"
#import "BBContainerView.h"


typedef enum {
    BBContributionCamera,
    BBContributionLibrary,
    BBContributionRecord,
    BBContributionNone
} ContributionType;


@interface BBContributionController : BBControllerBase
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(BBContributionController*)initWithCamera;
-(BBContributionController*)initWithLibrary;
-(BBContributionController*)initWithRecord;

@property (nonatomic) ContributionType contributionType;

@end