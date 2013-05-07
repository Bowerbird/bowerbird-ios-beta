//
//  BBActivityArray.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 6/05/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBActivityArray.h"

@implementation BBActivityArray

@synthesize activities = _activities;

-(void)setActivities:(NSArray *)activities { _activities = activities; }
-(NSArray*)activities {
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities { return [self.activities count]; }
-(id)objectInActivitiesAtIndex:(NSUInteger)index { return [self.activities objectAtIndex:index]; }

@end