/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBActivityPaginator.h"

@implementation BBActivityPaginator {

}

@synthesize activities = _activities;

-(void)setActivities:(NSArray *)activities
{
    _activities = activities;
}
-(NSArray*)activities
{
    if(!_activities)_activities = [[NSArray alloc]init];
    return _activities;
}
-(NSUInteger)countOfActivities
{
    return [self.activities count];
}
-(id)objectInActivitiesAtIndex:(NSUInteger)index
{
    return [self.activities objectAtIndex:index];
}

- (void) objectLoader:(RKObjectLoader *)loader willMapData:(inout __autoreleasing id *)mappableData {
    NSMutableDictionary* model = [[*mappableData objectForKey: @"Model"] mutableCopy];
    NSDictionary* pagedResult = [model objectForKey:@"Activities"];

    self.perPage = [[pagedResult objectForKey: @"PageSize"] intValue];
    self.pageCount = ([[pagedResult objectForKey: @"TotalResultCount"] intValue] / [[pagedResult objectForKey: @"PageSize"] intValue]) + 1;
    self.currentPage = [[pagedResult objectForKey: @"Page"] intValue];
}

@end