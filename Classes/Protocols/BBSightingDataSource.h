//
//  BBSightingCreateProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBModels.h"

@protocol BBSightingDataSource <NSObject>

@optional

-(void)changeTitle:(NSString*)title;
-(NSString*)title;

-(void)addMedia:(BBMediaEdit*)media;
-(void)removeMedia:(BBMediaEdit*)media;
-(NSArray*)media;

-(void)changeLocation:(CGPoint)location;
-(CGPoint)location;

-(void)changeAddress:(NSString*)address;
-(NSString*)address;

-(void)addProject:(NSString*)projectId;
-(void)removeProject:(NSString*)projectId;
-(NSArray*)projects;

-(void)changeCategory:(NSString*)category;
-(NSString*)category;

-(void)changeDate:(NSDate*)date;
-(NSDate*)createdOn;

@end