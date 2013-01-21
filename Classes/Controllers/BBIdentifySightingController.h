//
//  BBIdentifySightingController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBControllerBase.h"
#import "BBIdentifySightingEdit.h"
#import "BBIdentifySightingView.h"
#import "BBIdentifySightingProtocol.h"
#import "BBClassificationSearchController.h"
#import "BBClassificationBrowseController.h"
#import "BBClassificationCreateController.h"

@interface BBIdentifySightingController : BBControllerBase <
    BBIdentifySightingProtocol
>

@property (nonatomic,strong) BBIdentifySightingEdit *identifySighting;

-(BBIdentifySightingController*)initWithSightingId:(NSString*)sightingId;

@end