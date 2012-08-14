/*----------------------------------------------------------------------------------------------- 
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "Project.h"

@interface Project()

@property (nonatomic, weak) id<ProjectLoaded> delegate;
@property (nonatomic, strong) Project* project;

@end

@implementation Project

@synthesize networkQueue;
@synthesize delegate = _delegate;
@synthesize projects = _projects;
@synthesize project = _project;


#pragma mark - Initializers and JSON readers

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate
{
    self = [self init];
    
    if([BowerBirdConstants Trace]) NSLog(@"Project.initWithJson:");
    
    self.delegate = delegate;
    self.identifier = [dictionary objectForKey:@"Id"];
    self.groupType = @"project";
    self.name = [dictionary objectForKey:@"Name"];
    self.description = [dictionary objectForKey:@"Description"];
    self.avatar = [[Image alloc]initWithJson:[[[dictionary objectForKey:@"Avatar"] objectForKey:@"Image"] objectForKey:[BowerBirdConstants NameOfAvatarImageThatGetsDisplayed]] andNotifyImageDownloadComplete:self];
    
    return self;
}

-(void)loadProjectsFromJson:(NSArray *)array
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.loadProjectsFromJson:");
    
    NSMutableDictionary* projects = [[NSMutableDictionary alloc]init];
    for (id projectDictionary in array) {
        Project* project = [[Project alloc]initWithJson:projectDictionary andNotifyDelegate:self.delegate];
        if(project){
            [projects setObject:project forKey: project.identifier];
        }
    }
    
    self.projects = [[NSDictionary alloc]initWithDictionary:projects];
}

#pragma mark - Network methods for loading Projects
 
- (void)doGetRequest:(NSURL *)withUrl
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.doGetRequest:");
    
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
    if([BowerBirdConstants Trace]) NSLog(@"Project.requestFinished:");
    
	if ([[self networkQueue] requestsCount] == 0){
		[self setNetworkQueue:nil];
	}
    
    [self loadProjectsFromJson:[[[[[[SBJSON alloc] init] objectWithString:[request responseString] error:nil] objectForKey:@"Model"] objectForKey:@"Projects"] objectForKey:@"PagedListItems"]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.requestFailed:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.queueFinished:");
    
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate

// called to load all the projects (probably needs some paging parameters)
- (void)loadAllProjectsAndNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.loadAllProjectsAndNotifiyDelegate:");
    
    self.delegate = delegate;
    
	[self doGetRequest:[BowerBirdConstants ProjectsUrl]];
}

// called to load a subset of projects from json array (like the user's project list)
-(void)loadTheseProjects:(NSArray*)projects andNotifyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.loadTheseProjects:AndNotifyDelegate:");
    
    self.delegate = delegate;
    
    [self loadProjectsFromJson:projects];
}

-(void)loadThisProject:(NSDictionary*)project andNotifiyDelegate:(id)delegate
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.loadThisProject:andNotifyDelegate:");
    
    self.delegate = delegate;
    
    self.project = [[Project alloc]initWithJson:project andNotifyDelegate:self.delegate];
}

// called by the avatar loader to notify caller of this class by delegate that project is fully loaded
-(void)ImageFinishedLoading:(Image*)forAvatar
{
    if([BowerBirdConstants Trace]) NSLog(@"Project.ImageFinishedLoading:");
    
    if([self.delegate respondsToSelector:@selector(ProjectHasFinishedLoading:)])
    {
        [self.delegate ProjectHasFinishedLoading:self];
    }
}

@end