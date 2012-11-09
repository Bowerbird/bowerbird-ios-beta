//
//  BBStreamController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBStreamView.h"
#import "BBMediaResource.h"
#import "MGHelpers.h"
#import "PhotoBox.h"
#import "BBSightingDetailController.h"
#import "PhotoBox.h"

@interface BBStreamController : BBControllerBase <UIGestureRecognizerDelegate>

-(void)displayActivities:(BBActivityPaginator*)activities;

-(void)displaySightings:(BBSightingPaginator*)pagedSightings;

@property (nonatomic, weak) IBOutlet MGScrollView *scroller;

@end