/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "AuthenticatedUser.h"


@interface AuthenticatedUser()

@property (nonatomic, weak) id<AuthenticatedUserLoaded> authenticatedUserLoaded;
@property (nonatomic, strong) AuthenticatedUser* authenticatedUser;
@property (nonatomic, strong) Project* project;

@end


@implementation AuthenticatedUser

@synthesize networkQueue;
@synthesize authenticatedUser = _authenticatedUser;
@synthesize user = _user;
@synthesize categories = _categories;
@synthesize projects = _projects;
@synthesize teams = _teams;
@synthesize organisations = _organisations;
@synthesize userProjects = _userProjects;
@synthesize memberships = _memberships;
@synthesize defaultLicence = _defaultLicence;
@synthesize project = _project;


#pragma mark - Class methods for iterating JSON blobs.

-(id)initWithJson:(NSDictionary *)dictionary
{
    self = [self init];
    
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.initWithJson:");
    
    self.defaultLicence = [dictionary objectForKey:@"DefaultLicence"];
    self.categories = [[dictionary objectForKey:@"AppRoot"] objectForKey:@"Categories"];
    self.user = [[User alloc]initWithJson:([dictionary objectForKey:@"User"]) andNotifyProjectLoaded:self];
    self.memberships = [Membership loadTheseMembershipsFromJson:[dictionary objectForKey:@"Memberships"]];
    
    self.project = [[Project alloc]init];
    [self.project loadTheseProjects:[dictionary objectForKey:@"Projects"] andNotifyDelegate:self];
    self.projects = self.project.projects;
    
    return self;
}


#pragma mark - Network methods for loading Projects

// this method uses blocks behind the scenes to do run an asynchronous, non blocking thread
- (void)doGetRequest:(NSURL *)withUrl
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.doGetRequest:");
    
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
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.requestFinished:");
    
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}
    
    SBJSON *parser = [[SBJSON alloc] init];
    id jsonObject = [parser objectWithString:request.responseString error:nil];
    NSDictionary* jsonBlob = [[jsonObject objectForKey:@"Model"] objectForKey:@"AuthenticatedUser"];
    
    self.authenticatedUser = [self initWithJson:jsonBlob];

    if([self.authenticatedUserLoaded respondsToSelector:@selector(authenticatedUserLoaded:)])
    {
        [self.authenticatedUserLoaded authenticatedUserLoaded:self];
    }
}
            
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.requestFailed:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    
	if([BowerBirdConstants Trace]) NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.queueFinished:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate

// call network opertaions to load projects and set caller delegate
- (void)loadAndNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.loadAndNotifyDelegate:");
    
    self.authenticatedUserLoaded = delegate;
    
	[self doGetRequest:[BowerBirdConstants AuthenticatedUserProfileUrl]];
}

// delegate method, called on completion of project loading by ProjectModel
-(void)ProjectHasFinishedLoading:(Project*)project
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.ProjectHasFinishedLoading:");
    
    NSMutableDictionary* projects = [[NSMutableDictionary alloc]initWithDictionary:self.projects];
    
    [projects setObject:project forKey:project.identifier];
    
    self.projects = [[NSDictionary alloc]initWithDictionary:projects];
    
    // this happens each time a project is loaded for a user.
//    if([self.authenticatedUserLoaded respondsToSelector:@selector(authenticatedUserLoaded:)])
//    {
//        [self.authenticatedUserLoaded authenticatedUserLoaded:self];
//    }
    
    if([BowerBirdConstants Trace]) NSLog(@"Project loaded: %@", project.identifier);
}

-(void)UserLoaded:(User*)user
{
    if([BowerBirdConstants Trace]) NSLog(@"AuthenticatedUser.UserLoaded:");
    
    self.authenticatedUser.user = user;
    
    if([self.authenticatedUserLoaded respondsToSelector:@selector(authenticatedUserLoaded:)])
    {
        [self.authenticatedUserLoaded authenticatedUserLoaded:self];
    }
}

@end
