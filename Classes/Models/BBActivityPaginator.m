/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBActivityPaginator.h"

@implementation BBActivityPaginator

@synthesize activities = _activities;

-(void)setActivities:(NSArray *)activities
{
    _activities = activities;
}
-(NSArray*)projects
{
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities
{
    return [self.projects count];
}
-(id)objectInActivitiesAtIndex:(NSUInteger)index
{
    return [_activities objectAtIndex:index];
}

@end
