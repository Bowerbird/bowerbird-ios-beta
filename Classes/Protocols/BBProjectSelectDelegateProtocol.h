//
//  BBProjectSelectDelegateProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBProjectSelectDelegateProtocol <NSObject>

@optional
-(void)addSightingProject:(NSString*)projectId;
-(void)removeSightingProject:(NSString*)projectId;
-(NSArray*)getSightingProjects;
-(NSArray*)getUsersProjects;
-(void)stopAddingProjects;

@end