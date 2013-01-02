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
#import "BBStreamProtocol.h"
#import "BBStreamView.h"

@interface BBStreamController : BBControllerBase <
     UIGestureRecognizerDelegate
    //,RKObjectLoaderDelegate
    ,RKObjectPaginatorDelegate
    ,UIScrollViewDelegate
>

-(BBStreamController*)initWithUserAndDelegate:(id<BBStreamProtocol>)delegate;
-(BBStreamController*)initWithGroup:(NSString*)groupId andDelegate:(id<BBStreamProtocol>)delegate;
-(BBStreamController*)initWithProjectsAndDelegate:(id<BBStreamProtocol>)delegate;

-(void)displayActivities:(BBActivityPaginator*)activities;
-(void)displaySightings:(BBSightingPaginator*)pagedSightings;
-(void)displayProjects:(BBProjectPaginator*)pagedProjects;

@end