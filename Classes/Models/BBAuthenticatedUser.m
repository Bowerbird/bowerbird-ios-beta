/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBAuthenticatedUser.h"
#import "BBUser.h"
#import "BBHelpers.h"


@implementation BBAuthenticatedUser


#pragma mark -
#pragma mark - Member Accessors


@synthesize     user = _user,
                categories = _categories,
                projects = _projects,
                organisations = _organisations,
                userProjects = _userProjects,
                memberships = _memberships,
                defaultLicence = _defaultLicence;


-(void)setUser:(BBUser *)user { _user = user; }
-(BBUser*)user { return _user; }
-(void)setCategories:(NSArray *)categories { _categories = categories; }
-(NSArray*)categories {
    if(!_categories)_categories = [[NSArray alloc]init];
    return _categories;
}
-(NSUInteger)countOfCategories { return [self.categories count]; }
-(id)objectInCategoriesAtIndex:(NSUInteger)index { return [self.categories objectAtIndex:index]; }
-(void)setProjects:(NSArray *)projects { _projects = projects; }
-(NSArray*)projects {
    if(!_projects)_projects = [[NSArray alloc]init];
    return _projects;
}
-(NSUInteger)countOfProjects { return [self.projects count]; }
-(id)objectInProjectsAtIndex:(NSUInteger)index { return [self.projects objectAtIndex:index]; }
-(void)setOrganisations:(NSArray *)organisations { _organisations = organisations; }
-(NSArray*)organisations {
    if(!_organisations)_organisations = [[NSArray alloc]init];
    return _organisations;
}
-(NSUInteger)countOfOrganisations { return [self.organisations count]; }
-(id)objectInOrganisationsAtIndex:(NSUInteger)index { return [self.organisations objectAtIndex:index]; }
-(void)setUserProjects:(NSArray *)userProjects { _userProjects = userProjects; }
-(NSArray*)userProjects {
    if(!_userProjects)_userProjects = [[NSArray alloc]init];
    return _userProjects;
}
-(NSUInteger)countOfUserProjects { return [self.userProjects count]; }
-(id)objectInUserProjectsAtIndex:(NSUInteger)index { return [self.userProjects objectAtIndex:index]; }
-(void)setMemberships:(NSArray *)memberships { _memberships = memberships; }
-(NSArray*)memberships {
    if(!_memberships)_memberships = [[NSArray alloc]init];
    return _memberships;
}
-(NSUInteger)countOfMemberships { return [self.memberships count]; }
-(id)objectInMembershipsAtIndex:(NSUInteger)index { return [self.memberships objectAtIndex:index]; }
-(void)setDefaultLicence:(NSString *)defaultLicence { _defaultLicence = defaultLicence; }
-(NSString*)defaultLicence { return _defaultLicence; }


@end