/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "AuthenticatedUserModel.h"


@interface AuthenticatedUserModel()
-(void)loadAvatarImages;
@property (nonatomic, weak) id<AuthenticatedUserModelLoadCompleteDelegate> authenticatedUserModelLoadCompleteDelegate;
@property AuthenticatedUserModel* authenticatedUserModel;
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

// passing the response text blob from the server request at node Model.AuthenticatedUser
+(AuthenticatedUserModel*)loadAuthenticatedUserModelFromResponseString:(NSString *)responseString
{
    SBJSON *parser = [[SBJSON alloc] init];
    id jsonObject = [parser objectWithString:responseString error:nil];
    
    // now we have JSON string loaded, parse the AuthenticatedUser object from it's properties
    NSDictionary* jsonBlob = [jsonObject objectForKey:@"Model"];
    jsonBlob = [jsonBlob objectForKey:@"AuthenticatedUser"];
    
    AuthenticatedUserModel* authenticatedUserModel = [[AuthenticatedUserModel alloc]init];
    
    // drill down to AuthenticatedUser.DefaultLicence
    authenticatedUserModel.defaultLicence = [jsonBlob objectForKey:@"DefaultLicence"];
    
    // drill down to AuthenticatedUser.AppRoot as a dictionary
    NSDictionary* jsonDictionary = [jsonBlob objectForKey:@"AppRoot"];
    
    // drill down to AuthenticatedUser.AppRoot.Categories as an array
    authenticatedUserModel.categories = [jsonDictionary objectForKey:@"Categories"];
        
    // drill down to AuthenticatedUser.Memberships
    NSMutableArray* membershipModelArray = [[NSMutableArray alloc]init];
    for(id member in [CollectionHelper populateArrayFromDictionary:[jsonBlob objectForKey:@"Memberships"]])
    {
        [membershipModelArray addObject:[[MembershipModel alloc]initWithJsonBlob:(member)]];
    }
    authenticatedUserModel.memberships = [[NSArray alloc]initWithArray:membershipModelArray];
    
    // drill down to AuthenticatedUser.Projects
    NSMutableArray* projectModelArray = [[NSMutableArray alloc]init];
    for(id project in [CollectionHelper populateArrayFromDictionary:[jsonBlob objectForKey:@"Projects"]])
    {
        [projectModelArray addObject:[ProjectModel buildFromJson:(project)]];
    }
    authenticatedUserModel.projects = projectModelArray;
    
    // drill down to AuthenticatedUser.User
    authenticatedUserModel.user = [UserModel buildFromJson:[jsonBlob objectForKey:@"User"]];
    
    return authenticatedUserModel;
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
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[BowerBirdConstants ProjectsUrl]];
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
    
    self.authenticatedUserModel = [AuthenticatedUserModel loadAuthenticatedUserModelFromResponseString:request.responseString];
        
    // now load all the images
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

// loads the project images from Avatar, and sets this class as callback for
// the 'job done' message. delegates to ImageFinishedLoading below..
-(void)loadAvatarImages
{
    // load the avatars for all the projects
    for (ProjectModel *project in self.authenticatedUserModel.projects) {
        for(id avatar in project.avatars)
        {
            AvatarModel* avatarModel = [project.avatars objectForKey:avatar];
            if([avatarModel isKindOfClass:[AvatarModel class]]
               && avatarModel.imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
            {
                // we are passing this object as a callback delegate
                // so we are notified when the avatar image has loaded for the project
                [avatarModel loadImage:(self) forAvatarOwner:(project)];
            }
        }
    }
    
    // load the avatars for the authenticated user
    for(id avatar in self.authenticatedUserModel.user.avatars)
    {
        AvatarModel* avatarModel = [self.user.avatars objectForKey:avatar];
        if([avatarModel isKindOfClass:[AvatarModel class]]
           && avatarModel.imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
        {
            [avatarModel loadImage:(self) forAvatarOwner:(self.user)];
        }
    }
}

// this method is called back via the protocol delegate in
// the AvatarModel when it's image has loaded from network call.
-(void)ImageFinishedLoading:(NSString *)imageDimensionName
             forAvatarOwner:(id)avatarOwner
{
    if(imageDimensionName == [BowerBirdConstants ProjectDisplayAvatarName])
    {
        //ProjectModel* projectModel = [self.projects objectAtIndex:[self.projects indexOfObject:(avatarOwner)]];
        
        // notify this object's delegate that project is successfully loaded
        //[self.projectLoadCompleteDelegate ProjectLoaded:projectModel];
    }
}

@end
