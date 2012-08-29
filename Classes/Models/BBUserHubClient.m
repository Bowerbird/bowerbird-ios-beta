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
    if([BBConstants Trace])NSLog(@"BBUserHubClient.connectToUserHub with: %@", userId);
    
    NSString *server = [BBConstants RootUriString];
    self.connection = [SRHubConnection connectionWithURL:server];
    self.userHub = [self.connection createProxy:@"UserHub"];
    
    [self.userHub on:@"setupOnlineUsers" perform:self selector:@selector(setupOnlineUsers:)];
    [self.userHub on:@"userStatusUpdate" perform:self selector:@selector(userStatusUpdate:)];
    
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
    if([BBConstants Trace])NSLog(@"BBUserHubClient.setupOnlineUsers");
    
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
                if([BBConstants Trace])NSLog(@"user online: %@", user);
                
                BBUser* newUser = [[BBUser alloc] init];
                [newUser setValuesForKeysWithDictionary:user];
                
                [self.onlineUsers addObject:newUser];
            }
        }
    }
}

-(void)userStatusUpdate:(id)user
{
    if([BBConstants Trace])NSLog(@"BBUserHubClient.setupOnlineUsers");
    
    if([user isKindOfClass:[NSDictionary class]])
    {
        if([BBConstants Trace])NSLog(@"user online: %@", user);
                
        BBUser* newUser = [[BBUser alloc] init];
        [newUser setValuesForKeysWithDictionary:[user objectForKey:@"User"]];
        
        [self.onlineUsers addObject:newUser];
    }
}

#pragma mark -
#pragma mark SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)clientConnection
{
    if([BBConstants Trace])NSLog(@"BBUserHubClient.SRConnectionDidOpen with ConnectionId: %@", clientConnection.connectionId);
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
        
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
    if([BBConstants Trace])NSLog(@"BBUserHubClient.SRConnection:didReceiveError");
    
    if([BBConstants Trace])NSLog(@"Error: %@", error.localizedDescription);
}

@end
