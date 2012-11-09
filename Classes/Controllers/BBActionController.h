//
//  BBActionController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BBControllerBase.h"
#import "BBDeviceUIProtocol.h"
#import "MGHelpers.h"

@interface BBActionController : BBControllerBase <UIGestureRecognizerDelegate>

@property(nonatomic, assign) id<UINavigationControllerDelegate> delegate;

@end