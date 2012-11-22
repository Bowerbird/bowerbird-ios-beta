/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBUserHubClient.h"

@implementation BBUserHubClient

@synthesize     userHub = _userHub,
             connection = _connection,
            onlineUsers = _onlineUsers;

static BBUserHubClient* bowerbirdUserHubClient = nil;

+(BBUserHubClient*)sharedInstance
{
    if(bowerbirdUserHubClient == nil)
    {
        bowerbirdUserHubClient = [[super allocWithZone:NULL]init];
    }
    
    return bowerbirdUserHubClient;
}

-(void)connectToUserHub:(NSString*)userId
{
    NSString *server = [BBConstants RootUriString];
    self.connection = [SRHubConnection connectionWithURL:server];
    self.userHub = [self.connection createProxy:@"UserHub"];
    
    [self.userHub on:@"setupOnlineUsers" perform:self selector:@selector(setupOnlineUsers:)];
    [self.userHub on:@"userStatusUpdate" perform:self selector:@selector(userStatusUpdate:)];
    [self.userHub on:@"mediaResourceUploadSuccess" perform:self selector:@selector(notifyMediaResourceUploaded:)];
    [self.userHub on:@"mediaResourceUploadFailure" perform:self selector:@selector(notifyMediaResourceUploadFailed:)];
    
    [self.connection setDelegate:self];
    [self.connection start];
    
    if(self.onlineUsers == nil)
    {
        self.onlineUsers = [[NSMutableSet alloc] init];
    }
}

- (void)dealloc
{
    abort();
    
    [self.connection stop];
    self.userHub = nil;
    self.connection.delegate = nil;
    self.connection = nil;
}


#pragma mark -
#pragma mark Chat Sample Project

-(void)setupOnlineUsers:(id)users
{ 
 
    if([users isKindOfClass:[NSArray class]])
    {
        if([users count] == 0)
        {
            //[self addMessage:[NSString stringWithFormat:@"No rooms available"] type:@"notification"];
        }
        else
        {
            for (id user in users)
            {                
                BBUser* newUser = [[BBUser alloc] init];
                [newUser setValuesForKeysWithDictionary:user];
                
                [self.onlineUsers addObject:newUser];
            }
        }
    }
}

-(void)userStatusUpdate:(id)user
{    
    if([user isKindOfClass:[NSDictionary class]])
    {
        BBUser* newUser = [[BBUser alloc] init];
        [newUser setValuesForKeysWithDictionary:[user objectForKey:@"User"]];
        
        [self.onlineUsers addObject:newUser];
    }
}

-(void)notifyMediaResourceUploaded:(id)mediaResource {
    [BBLog Log:@"BBUserHubClient:notifyMediaResourceUploaded"];
    
    NSString *notificationKey = [mediaResource objectForKey:@"Key"];
    NSString *mediaResourceId = [mediaResource objectForKey:@"Id"];
    
    NSMutableDictionary *userInfoMutable = [[NSMutableDictionary alloc]init];
    [userInfoMutable setObject:notificationKey forKey:@"Key"];
    [userInfoMutable setObject:mediaResourceId forKey:@"Id"];
    
    NSDictionary *userInfo = [[NSDictionary alloc]initWithDictionary:userInfoMutable];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyMediaResourceUploaded" object:nil userInfo:userInfo];
}

-(void)notifyMediaResourceUploadFailed:(id)failure {
    [BBLog Log:@"BBUserHubClient:notifyMediaResourceUploadFailed"];
    
    NSString *notificationKey = [failure objectForKey:@"key"];
    NSString *failureReason = [failure objectForKey:@"reason"];
    
    NSMutableDictionary *userInfoMutable = [[NSMutableDictionary alloc]init];
    [userInfoMutable setObject:notificationKey forKey:@"Key"];
    [userInfoMutable setObject:failureReason forKey:@"FailureReason"];
    
    NSDictionary *userInfo = [[NSDictionary alloc]initWithDictionary:userInfoMutable];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyMediaResourceUploadFailed" object:nil userInfo:userInfo];
}

#pragma mark -
#pragma mark SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)clientConnection
{
    BBApplication* appData = [BBApplication sharedInstance];
        
    [self.userHub invoke:@"RegisterUserClient" withArgs:[NSArray arrayWithObjects:appData.authenticatedUser.user.identifier, nil]];
}

- (void)SRConnection:(SRConnection *)connection didReceiveData:(NSString *)data
{
    //[messagesReceived insertObject:data atIndex:0];
    //[messageTable reloadData];
    
}

- (void)SRConnectionDidClose:(SRConnection *)connection
{
    //[messagesReceived insertObject:@"Connection Closed" atIndex:0];
    //[messageTable reloadData];
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error
{
    
}

@end
