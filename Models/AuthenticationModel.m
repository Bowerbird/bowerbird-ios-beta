/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this class to attempt login, registration and user rehydration between app sessions
 
 -----------------------------------------------------------------------------------------------*/


#import "AuthenticationModel.h"

@interface AuthenticationModel()
-(void)processAuthenticationResponse:(ASIFormDataRequest*)request;
@property (nonatomic, strong) UserModel* authenticatedUser;
@property (nonatomic, weak) id<AuthenticationCompleteDelegate> authenticationCompleteDelegate;
@end

@implementation AuthenticationModel

@synthesize networkQueue;
@synthesize authenticatedUser = _authenticatedUser;


#pragma mark - Object initializers
- (id)initWithCallbackDelegate:(id)delegate
{
    self.authenticationCompleteDelegate = delegate;
    
    return self;
}


#pragma mark - Class methods for iterating JSON blobs.

-(void)processAuthenticationResponse:(ASIFormDataRequest*) request
{
    SBJSON *parser = [[SBJSON alloc] init];
    id jsonObject = [parser objectWithString:[request responseString] error:nil];
    
    if([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* model = [jsonObject objectForKey:@"Model.User"];
        self.authenticatedUser = [UserModel buildFromJson:model];
    }
    
    NSArray* cookies = [request responseCookies];
    
    for(id cookie in cookies)
    {
        NSLog(@"Cookie: %@", cookie);
    }
    // if we have a user, save user object to nsuserdefaults for this app
    // save the returned cookie (or work out how ASI does it)
    // call a delegate to tell the UI to proceed
}


#pragma mark - Network methods for authenticating User

- (void)doPostRequest:(NSURL *)toUrl withParameters:(NSDictionary *) params;
{
    [[self networkQueue] cancelAllOperations];
    [[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
       
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:toUrl];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    
    for(id key in params)
    {
        [request addPostValue:[params objectForKey:(key)] forKey:key];
    }
    
    [[self networkQueue] addOperation:request];
	[[self networkQueue] go];
    //[CookieCutter dumpCookies:nil];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}
    
    [self processAuthenticationResponse:(request)];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASIFormDataRequest *)queue
{
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate

// delegate method, called on completion of user loading by UserModel
-(void)UserLoaded:(UserModel *)user
{
    self.authenticatedUser = user;
    
    if([self.authenticationCompleteDelegate respondsToSelector:@selector(UserAuthenticated:)])
    {
        [self.authenticationCompleteDelegate UserAuthenticated:user];
    }
}

@end