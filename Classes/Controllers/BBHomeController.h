//
//  BBHomeController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 16/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBMenuController.h"
#import "BBActionController.h"
#import "BBHeaderController.h"
#import "BBStreamController.h"
#import "BBHomeView.h"

@interface BBHomeController : BBControllerBase <RKObjectLoaderDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,retain) BBMenuController *menuController;
@property (nonatomic,retain) BBActionController *actionController;
@property (nonatomic,retain) BBHeaderController *headerController;
@property (nonatomic,retain) BBStreamController *streamController;

@end