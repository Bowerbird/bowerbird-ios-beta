//
//  BBHomeController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 16/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBStreamProtocol.h"
#import "BBMenuController.h"
#import "BBActionController.h"
#import "BBHeaderController.h"
#import "BBStreamController.h"
#import "BBHomeView.h"
#import "MGHelpers.h"
#import "SVProgressHUD.h"

@interface BBHomeController : BBControllerBase <
     RKObjectLoaderDelegate
    ,UIGestureRecognizerDelegate
    ,BBStreamProtocol
>

@property (nonatomic,retain) BBMenuController *menuController;
@property (nonatomic,retain) BBActionController *actionController;
@property (nonatomic,retain) BBHeaderController *headerController;
@property (nonatomic,retain) BBStreamController *streamController;
@property (nonatomic,weak) id stream;

@end