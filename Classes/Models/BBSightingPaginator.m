/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBSightingPaginator.h"

@implementation BBSightingPaginator

@synthesize activities = _activities;

-(void)setActivities:(NSArray *)activities
{
    _activities  = activities;
}
-(NSArray*)activities
{
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities
{
    return [_activities count];
}
-(id)objectInActivitiesAtIndex:(NSUInteger)index
{
    return [_activities objectAtIndex:index];
}

@end