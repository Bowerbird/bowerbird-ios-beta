//
//  BBSightingDelegate.h
//  BowerBird
//
//  Created by Hamish Crittenden on 24/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBSightingDelegate <NSObject>

@optional
-(NSArray*)getUserProjects;
-(NSArray*)getLicences;
-(NSString*)getDefaultLicence;
-(NSArray*)getCategories;
-(void)addMedia;
-(void)editMedia;
-(void)editCreatedOnDate;
-(void)updateCreatedOnDate:(NSDate*)createdOn;
-(void)save;
-(void)cancel;
-(void)editingDone;

@end