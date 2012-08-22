/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBAuthenticatedUser.h"

@implementation BBAuthenticatedUser

@synthesize     user = _user,
          categories = _categories,
            projects = _projects,
               teams = _teams,
       organisations = _organisations,
        userProjects = _userProjects,
         memberships = _memberships,
      defaultLicence = _defaultLicence;


-(void)setUser:(BBUser *)user
{
    _user = user;
}
-(BBUser*)user
{
    return _user;
}


-(void)setCategories:(NSArray *)categories
{
    _categories = categories;
}
-(NSArray*)categories
{
    if(!_categories)_categories = [[NSArray alloc]init];
    return _categories;
}
-(NSUInteger)countOfCategories
{
    return [self.categories count];
}
-(id)objectInCategoriesAtIndex:(NSUInteger)index
{
    return [self.categories objectAtIndex:index];
}


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


-(void)setTeams:(NSDictionary *)teams
{
    _teams = teams;
}
-(NSDictionary*)teams
{
    if(!_teams)_teams = [[NSDictionary alloc]init];
    return _teams;
}
-(NSUInteger)countOfTeams
{
    return [self.teams count];
}
-(NSEnumerator*)enumeratorOfTeams
{
    return [self.teams objectEnumerator];
}
-(NSString*)memberOfTeams:(NSString *)object
{
    return [self.teams objectForKey:object];
}


-(void)setOrganisations:(NSDictionary *)organisations
{
    _organisations = organisations;
}
-(NSDictionary*)organisations
{
    if(!_organisations)_organisations = [[NSDictionary alloc]init];
    return _organisations;
}
-(NSUInteger)countOfOrganisations
{
    return [self.organisations count];
}
-(NSEnumerator*)enumeratorOfOrganisations
{
    return [self.organisations objectEnumerator];
}
-(NSString*)memberOfOrganisations:(NSString *)object
{
    return [self.organisations objectForKey:object];
}


-(void)setUserProjects:(NSDictionary *)userProjects
{
    _userProjects = userProjects;
}
-(NSDictionary*)userProjects
{
    if(!_userProjects)_userProjects = [[NSDictionary alloc]init];
    return _userProjects;
}
-(NSUInteger)countOfUserProjects
{
    return [self.userProjects count];
}
-(NSEnumerator*)enumeratorOfUserProjects
{
    return [self.projects objectEnumerator];
}
-(NSString*)memberOfUserProjects:(NSString *)object
{
    return [self.userProjects objectForKey:object];
}


-(void)setMemberships:(NSArray *)memberships
{
    _memberships = memberships;
}
-(NSArray*)memberships
{
    if(!_memberships)_memberships = [[NSArray alloc]init];
    return _memberships;
}
-(NSUInteger)countOfMemberships
{
    return [self.memberships count];
}
-(id)objectInMembershipsAtIndex:(NSUInteger)index
{
    return [self.memberships objectAtIndex:index];
}


-(void)setDefaultLicence:(NSString *)defaultLicence
{
    _defaultLicence = defaultLicence;
}
-(NSString*)defaultLicence
{
    return _defaultLicence;
}


@end