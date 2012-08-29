/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBSightingPaginator.h"

@implementation BBSightingPaginator

@synthesize sightings = _sightings;

-(void)setSightings:(NSArray *)sightings
{
    _sightings  = sightings;
}
-(NSArray*)sightings
{
    if(!_sightings)_sightings = [[NSArray alloc]init];
    return _sightings;
}
-(NSUInteger)countOfSightings
{
    return [self.sightings count];
}
-(id)objectInSightingsAtIndex:(NSUInteger)index
{
    return [self.sightings objectAtIndex:index];
}

@end