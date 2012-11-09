//
//  BBProjectSelectController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBProjectSelectDelegateProtocol.h"
#import "BBLog.h"
#import "BBStyles.h"
#import "BBControllerBase.h"
#import "BBProjectSelectView.h"
#import "BBCollectionHelper.h"
#import "BBUIControlHelper.h"

@interface BBProjectSelectController : BBControllerBase <BBProjectSelectDelegateProtocol>

-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate;

@property (nonatomic,retain) id controller; // parent controller
@property (nonatomic,strong) BBProjectSelectView *projectSelectView; // da view
@property (nonatomic,strong) NSArray *projects;

-(NSArray*)getUsersProjects;
-(NSArray*)usersProjectsNotSelected;
-(NSArray*)getSightingProjects;
-(void)addSightingProject:(NSString*)projectId;
-(void)removeSightingProject:(NSString*)projectId;

@end