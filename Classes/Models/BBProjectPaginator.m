/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBProjectPaginator.h"

@implementation BBProjectPaginator

@synthesize projects = _projects;

-(void)setProjects:(NSArray *)projects
{
    _projects = projects;
}
-(NSArray*)projects
{
    if(!_projects)_projects = [[NSArray alloc]init];
    return _projects;
}
-(NSUInteger)countOfProjects
{
    return [self.projects count];
}
-(id)objectInProjectsAtIndex:(NSUInteger)index
{
    return [self.projects objectAtIndex:index];
}

@end