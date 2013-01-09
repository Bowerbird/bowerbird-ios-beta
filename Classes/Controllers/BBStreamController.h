//
//  BBStreamController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBMediaResource.h"
#import "MGHelpers.h"
#import "PhotoBox.h"
#import "BBSightingDetailController.h"
#import "PhotoBox.h"
#import "BBUIControlHelper.h"
#import "BBAppDelegate.h"
#import "BBStreamView.h"
#import "BBArrowView.h"

@interface BBStreamController : BBControllerBase <
     UIGestureRecognizerDelegate // for swiping
    ,RKObjectLoaderDelegate // for posting on click
    ,RKObjectPaginatorDelegate // for pagination
    ,UIScrollViewDelegate // for scroll view
>

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate;
-(BBStreamController*)initWithGroup:(NSString*)groupId andDelegate:(id<BBStreamProtocol>)delegate;
-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate;

@end