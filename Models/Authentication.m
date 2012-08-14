/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> Use this class to attempt login and registration
 
 -----------------------------------------------------------------------------------------------*/

#import "Authentication.h"

@interface Authentication()

-(void)processAuthenticationResponse:(ASIFormDataRequest*)request;
@property (nonatomic, strong) User* authenticatedUser;
@property (nonatomic, weak) id<AuthenticationComplete> authenticationComplete;
@property (nonatomic, strong) ASIFormDataRequest *request;

@end

@implementation Authentication

@synthesize networkQueue;
@synthesize authenticatedUser = _authenticatedUser;
@synthesize request =_request;
@synthesize authenticationComplete = _authenticationComplete;


#pragma mark - Object initializers and methods for iterating JSON blobs.

- (id)initWithCallbackDelegate:(id)delegate
{
    self = [self init];
    
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.initWithCallbackDelegate:");
    
    self.authenticationComplete = delegate;
    
    return self;
}

-(void)processAuthenticationResponse:(ASIFormDataRequest*) request
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.processAuthenticationResponse:");
    
    NSDictionary* modelJson = [[[SBJSON alloc] init] objectWithString:[request responseString] error:nil];
    self.authenticatedUser = [[User alloc]initWithJson:([[modelJson objectForKey:@"Model"] objectForKey:@"User"]) andNotifyProjectLoaded:self];
    
    NSHTTPCookie* authenticatedCookie;
    
    for(id cookie in [request responseCookies])
    {
        if([cookie isKindOfClass:[NSHTTPCookie class]])
        {
            if([cookie name] == [BowerBirdConstants BowerbirdCookieName])
            {
                authenticatedCookie = cookie;
                NSLog(@"Cookie: %@", cookie);
            }
        }
    }

    if([self.authenticationComplete respondsToSelector:@selector(UserAuthenticated:)])
    {
        [self.authenticationComplete UserAuthenticated:self.authenticatedUser];
    }
}


#pragma mark - Network methods for authenticating User

- (void)doPostRequest:(NSURL *)toUrl withParameters:(NSDictionary *) params;
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.doPostRequest:withParameters:");
    
    [[self networkQueue] cancelAllOperations];
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
       
    self.request = [ASIFormDataRequest requestWithURL:toUrl];
    [self.request addRequestHeader:@"Accept" value:@"*/*"];
    [self.request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    
    for(id key in params)
    {
        [self.request addPostValue:[params objectForKey:(key)] forKey:key];
    }
    
    [[self networkQueue] addOperation:self.request];
	[[self networkQueue] go];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.requestFinished:");
    
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}

    [self processAuthenticationResponse:(self.request)];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.requestFailed:");
    
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Request failed: %@", [[request error] localizedDescription]);
}

- (void)queueFinished:(ASIFormDataRequest *)queue
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.queueFinished:");
    
	if ([[self networkQueue] requestsCount] == 0)
    {
		[self setNetworkQueue:nil];
	}
}


#pragma mark - Callback methods to this and methods setting this as delegate

// delegate method, called on completion of user loading by UserModel
-(void)UserLoaded:(User *)user
{
    if([BowerBirdConstants Trace]) NSLog(@"Authentication.userLoaded:");
    
    self.authenticatedUser = user;
    
    if([self.authenticationComplete respondsToSelector:@selector(UserAuthenticated:)])
    {
        [self.authenticationComplete UserAuthenticated:user];
    }
}

@end