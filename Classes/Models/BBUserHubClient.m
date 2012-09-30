/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBUserHubClient.h"

@interface BBUserHubClient()

- (void)insertOrUpdateUser:(id)user;

@end

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


#pragma mark -
#pragma mark - Calls from Client to Server

-(void)connectToUserHub:(NSString*)userId
{
    [BBLog Log:[NSString stringWithFormat:@"BBUserHubClient.connectToUserHub with: %@", userId]];
    
    self.connection = [SRHubConnection connectionWithURL:[BBConstants RootUriString]];
    self.userHub = [self.connection createProxy:@"UserHub"];
    
    [self.userHub on:@"setupOnlineUsers"
             perform:self
            selector:@selector(setupOnlineUsers:)];
    
    [self.userHub on:@"userStatusUpdate"
             perform:self
            selector:@selector(userStatusUpdate:)];
    
    [self.connection setDelegate:self];
    [self.connection start];
    
    self.onlineUsers = [[NSMutableArray alloc] init];
}


-(void)updateUserStatus:(NSString*)identifier withActivity:(NSDate *)latestActivity withHeartbeat:(NSDate *)latestHeartbeat
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDateFormatter* dFormatter = [[NSDateFormatter alloc]init];
    [dFormatter setTimeZone:timeZone];
    [dFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSString* activityString = [dFormatter stringFromDate:latestActivity];
    NSString* heartbeatString = [dFormatter stringFromDate:latestHeartbeat];
    
    [self.userHub invoke:@"UpdateUserClientStatus"
                withArgs:[NSArray arrayWithObjects:identifier, activityString, heartbeatString, nil]];
    
    [BBLog Log:[NSString stringWithFormat:@"updateUserStatus: %@ %@ %@", identifier, activityString, heartbeatString]];
}


#pragma mark -
#pragma mark - Calls from Server to Client

-(void)setupOnlineUsers:(id)users
{ 
    if([BBConstants Trace])NSLog(@"BBUserHubClient.setupOnlineUsers");
    
    if([users isKindOfClass:[NSArray class]])
    {
        if([users count] > 0)
        {
            for (id user in users)
            {
                if([BBConstants Trace])NSLog(@"user online: %@", user);
                
                [self insertOrUpdateUser:user];
            }
        }
    }
}


-(void)userStatusUpdate:(id)user
{
    if([BBConstants Trace])NSLog(@"BBUserHubClient.userStatusUpdate");
    
    if([user isKindOfClass:[NSDictionary class]])
    {
        if([BBConstants Trace])NSLog(@"user online: %@", user);
        
        id uid = [user objectForKey:@"User"];
        
        [self insertOrUpdateUser:uid];
    }
}


- (void)insertOrUpdateUser:(id)user
{
    __block BBUser* insertUpdateUser;
    [self.onlineUsers enumerateObjectsUsingBlock:^(BBUser* item, NSUInteger idx, BOOL *stop)
     {
         if([item.identifier isEqualToString:[user objectForKey:@"Id"]])
         {
             insertUpdateUser = item;
         }
     }];
    
    if(insertUpdateUser)
    {
        [insertUpdateUser updateLatestActivity:[user objectForKey:@"LatestActivity"]];
    }
    else
    {
        insertUpdateUser = [[BBUser alloc] initWithObject:user];
        
        if(insertUpdateUser)
        {
            [self.onlineUsers addObject:insertUpdateUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    
    // set the global user to point to the instance of the updating, polling, ticking, user if it hasn't been set
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    if(!appData.user)
    {
        if([insertUpdateUser.identifier isEqualToString:appData.authenticatedUser.user.identifier])
        {
            appData.user = insertUpdateUser;
        }
    }
}


#pragma mark -
#pragma mark SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)clientConnection
{
    [BBLog Log:([NSString stringWithFormat:@"BBUserHubClient.SRConnectionDidOpen with ConnectionId: %@", clientConnection.connectionId])];
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
        
    [self.userHub invoke:@"RegisterUserClient" withArgs:[NSArray arrayWithObjects:appData.authenticatedUser.user.identifier, nil]];
}

- (void)SRConnection:(SRConnection *)connection didReceiveData:(NSString *)data
{
    [BBLog Log:([NSString stringWithFormat:@"BBUserHubClient.SRConnection didReceiveData: %@", data])];
}

- (void)SRConnectionDidClose:(SRConnection *)connection
{
    [BBLog Log:(@"BBUserHubClient.SRConnection didClose: %@")];
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error
{
    [BBLog Log:(@"BBUserHubClient.SRConnection:didReceiveError")];
    [BBLog Log:([NSString stringWithFormat:@"Error: %@", error.localizedDescription])];
}

- (void)dealloc
{
    abort();
    
    [self.connection stop];
    self.userHub = nil;
    self.connection.delegate = nil;
    self.connection = nil;
}

@end
