/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBActivityPaginator.h"

@implementation BBActivityPaginator {
    int currentOffset;
    int perPage;
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
    NSMutableDictionary* d = [[*mappableData objectForKey: @"d"] mutableCopy];
    
    NSString* next = [d objectForKey: @"Page"];
    
    if(!next) {
        currentOffset = 0;
    }
    else {
        NSDictionary* params = [next queryParameters];
        perPage = [[params objectForKey: @"PageSize"] intValue];
        currentOffset = [[params objectForKey: @"Page"] intValue];
    }
}

@end