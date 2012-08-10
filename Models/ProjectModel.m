/*----------------------------------------------------------------------------------------------- 
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "ProjectModel.h"

@interface ProjectModel()

@property (nonatomic, strong) NSDictionary* projects;
@property (nonatomic, weak) id<ProjectLoaded> delegate;

@end

@implementation ProjectModel

@synthesize networkQueue;
@synthesize projects = _projects;
@synthesize delegate = _delegate;


#pragma mark - Class methods for iterating response strings and JSON blobs.

-(id)initWithJson:(NSDictionary *)dictionary
{
    self.identifier = [dictionary objectForKey:@"Id"];
    self.groupType = @"project";
    self.name = [dictionary objectForKey:@"Name"];
    self.description = [dictionary objectForKey:@"Description"];
    
    NSDictionary* avatarJson = [[[dictionary objectForKey:@"Avatar"] objectForKey:@"Image"] objectForKey:[BowerBirdConstants NameOfAvatarImageThatGetsDisplayed]];
    self.avatar = [[AvatarModel alloc]initWithJson:avatarJson andNotifyImageDownloadComplete:self];
    
    return self;
}

-(NSDictionary *)loadProjectsFromResponseString:(NSString *)responseString
{
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary* projectsJson = [parser objectWithString:responseString error:nil];
    projectsJson = [[[projectsJson objectForKey:@"Model"] objectForKey:@"Projects"] objectForKey:@"PagedListItems"];
    
    NSMutableDictionary* projects = [[NSMutableDictionary alloc]init];
    for (id projectDictionary in projectsJson) {
        ProjectModel* newProject = [self initWithJson:projectDictionary];
        if(newProject){
            [projects setObject:newProject forKey: newProject.identifier];
        }
    }

    return [[NSDictionary alloc]initWithDictionary:projects];
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
	if ([[self networkQueue] requestsCount] == 0){
		[self setNetworkQueue:nil];
	}
    self.projects = [self loadProjectsFromResponseString:[request responseString]];
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
    self.delegate = delegate;
    
	[self doGetRequest:[BowerBirdConstants ProjectsUrl]];
}

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
// If this image is of the projectDisplayImage type, the project is ready to display
-(void)ImageFinishedLoading:(AvatarModel*)forAvatar;
{
    if([self.delegate respondsToSelector:@selector(ProjectLoaded:)])
    {
        [self.delegate ProjectLoaded:self];
    }
}

@end