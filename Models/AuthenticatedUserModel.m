/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "AuthenticatedUserModel.h"


@interface AuthenticatedUserModel()

@property (nonatomic, weak) id<AuthenticatedUserLoaded> authenticatedUserLoaded;
@property (nonatomic, strong) AuthenticatedUserModel* authenticatedUserModel;

@end


@implementation AuthenticatedUserModel

@synthesize networkQueue;
@synthesize authenticatedUserModel = _authenticatedUserModel;
@synthesize user = _user;
@synthesize categories = _categories;
@synthesize projects = _projects;
@synthesize teams = _teams;
@synthesize organisations = _organisations;
@synthesize userProjects = _userProjects;
@synthesize memberships = _memberships;
@synthesize defaultLicence = _defaultLicence;


#pragma mark - Class methods for iterating JSON blobs.

-(id)initWithJson:(NSDictionary *)dictionary
{
    self.defaultLicence = [dictionary objectForKey:@"DefaultLicence"];
    self.categories = [[dictionary objectForKey:@"AppRoot"] objectForKey:@"Categories"];
    self.user = [[UserModel alloc]initWithJson:([dictionary objectForKey:@"User"])];
    
    // drill down to AuthenticatedUser.Memberships
    NSArray* membershipsArray = [dictionary objectForKey:@"Memberships"];
    NSMutableArray* membershipModels = [[NSMutableArray alloc]init];
    for(id memberDictionary in membershipsArray)
    {
        MembershipModel* newMembership = [[MembershipModel alloc]initWithJson:memberDictionary];
        if(newMembership){
            [membershipModels addObject:(newMembership)];
        }
    }
    self.memberships = [[NSArray alloc]initWithArray:membershipModels];
    
    // drill down to AuthenticatedUser.Projects
    NSArray* projectsArray = [dictionary objectForKey:@"Projects"];
    NSMutableDictionary* projectModelsDictionary = [[NSMutableDictionary alloc]init];
    for(id projectDictionary in projectsArray)
    {
        ProjectModel* newProject = [[ProjectModel alloc]initWithJson:projectDictionary];
        if(newProject){
            [projectModelsDictionary setObject:newProject forKey:newProject.identifier];
        }
    }
    self.projects = [[NSDictionary alloc]initWithDictionary:projectModelsDictionary];   
    
    return self;
}


#pragma mark - Network methods for loading Projects

// this method uses blocks behind the scenes to do run an asynchronous, non blocking thread
- (void)doGetRequest:(NSURL *)withUrl
{
	[[self networkQueue] cancelAllOperations];
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
  
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:withUrl];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    [[self networkQueue] addOperation:request];
	[[self networkQueue] go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Request Finished");
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}
    
    SBJSON *parser = [[SBJSON alloc] init];
    id jsonObject = [parser objectWithString:request.responseString error:nil];
    NSDictionary* jsonBlob = [[jsonObject objectForKey:@"Model"] objectForKey:@"AuthenticatedUser"];
    
    self.authenticatedUserModel = [self initWithJson:jsonBlob];
}
            
- (void)requestFailed:(ASIHTTPRequest *)request
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate

// call network opertaions to load projects and set caller delegate
- (void)loadAndNotifyDelegate:(id)delegate
{
    self.authenticatedUserLoaded = delegate;
    
	[self doGetRequest:[BowerBirdConstants AuthenticatedUserProfileUrl]];
}

@end
