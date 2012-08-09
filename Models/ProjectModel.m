/*----------------------------------------------------------------------------------------------- 
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "ProjectModel.h"

@interface ProjectModel()
-(void)loadAvatarImages;
@property (nonatomic, strong) NSArray* projects;
@property (nonatomic, weak) id<ProjectLoadCompleteDelegate> projectLoadCompleteDelegate;
@end

@implementation ProjectModel

@synthesize networkQueue;
@synthesize projects = _projects;
@synthesize projectLoadCompleteDelegate = _projectLoadCompleteDelegate;


#pragma mark - Class methods for iterating JSON blobs.
 
+(NSArray *)loadProjectsFromResponseString:(NSString *)responseString
{
    SBJSON *parser = [[SBJSON alloc] init];
       
    NSMutableArray* projects = [[NSMutableArray alloc]init];
    
    id jsonObject = [parser objectWithString:responseString error:nil];
        
    if([jsonObject isKindOfClass:[NSDictionary class]])
    {
        /*
         TODO: There is a better way to load via Dictionary Key in
         one hit but it aint working for me at the moment hence the
         manual drill down
         */
        NSDictionary* model = [jsonObject objectForKey:@"Model"];
        NSDictionary* projectModel = [model objectForKey:@"Projects"];
        NSArray* projectList = [projectModel objectForKey:@"PagedListItems"];
        
        for (id projectProperties in projectList) {
            [projects addObject:[self buildFromJson:projectProperties]];
        }
    }
    
    return projects;
}

+(ProjectModel *)buildFromJson:(NSDictionary *)properties
{
    ProjectModel* model = [[ProjectModel alloc]init];

    model.identifier = [properties objectForKey:@"Id"];
    model.groupType = @"project";
    model.name = [properties objectForKey:@"Name"];
    model.description = [properties objectForKey:@"Description"];
    
    NSDictionary* avatarJson = [properties objectForKey:@"Avatar"];
    NSDictionary* imageJson = [avatarJson objectForKey:@"Image"];
    model.avatars = [AvatarModel buildManyFromJson:imageJson];
    
    return model;
}


#pragma mark - Network methods for loading Projects
 
// this method uses blocks behind the scenes to do run an asynchronous, non blocking thread
- (void)doGetRequest:(NSString *)withUrl
{
	[[self networkQueue] cancelAllOperations];
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    
    NSURL *url = [NSURL URLWithString:[[BowerBirdConstants RootUri]
              stringByAppendingFormat:@"%@", @"/projects"]];
    
    NSLog(@"Loading from url: %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
    
    // now we have JSON string loaded, parse the ProjectModel object from it's properties
    self.projects = [ProjectModel loadProjectsFromResponseString:[request responseString]];
    
    // now that we have avatar urls, load the project's avatar's images
    [self loadAvatarImages];
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
- (void)loadProjectsCallingBackToDelegate:(id)delegate
{
    self.projectLoadCompleteDelegate = delegate;
    
	[self doGetRequest:[BowerBirdConstants RootUri]];
}

// loads the project images from Avatar, and sets this class as callback for
// the 'job done' message. delegates to ImageFinishedLoading below..
-(void)loadAvatarImages
{
    for (ProjectModel *project in self.projects) {
        for(id avatar in project.avatars)
        {
            AvatarModel* avatarModel = [project.avatars objectForKey:avatar];
            if([avatarModel isKindOfClass:[AvatarModel class]]
               && avatarModel.imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
            {
                // we are passing this object as a callback delegate
                // so we are notified when the avatar image has loaded for the project
                [avatarModel loadImage:(self) forAvatarOwnder:(project)];
            }
        }
    }
}

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
// If this image is of the projectDisplayImage type, the project is ready to display
-(void)ImageFinishedLoading:(NSString *)imageDimensionName
             forAvatarOwner:(id)avatarOwner
{
    if(imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
    {
        ProjectModel* projectModel = [self.projects objectAtIndex:[self.projects indexOfObject:(avatarOwner)]];
        
        // notify this object's delegate that project is successfully loaded
        [self.projectLoadCompleteDelegate ProjectLoaded:projectModel];
    }
}

@end