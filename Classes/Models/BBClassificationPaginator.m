/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassificationPaginator.h"


@implementation BBClassificationPaginator


#pragma mark -
#pragma mark - Member Accessors


@synthesize ranks = _ranks;


-(void)setRanks:(NSArray *)ranks { _ranks = ranks; }
-(NSArray*)ranks {
    if(!_ranks)_ranks = [[NSArray alloc]init];
    return _ranks;
}
-(NSUInteger)countOfRanks { return [_ranks count]; }
-(id)objectInRanksAtIndex:(NSUInteger)index { return [_ranks objectAtIndex:index]; }


@end