/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This object is used to store global application data such as the logged in user
 
 -----------------------------------------------------------------------------------------------*/

#import "BBApplication.h"

@implementation BBApplication

@synthesize     authenticatedUser = _authenticatedUser,
                   authentication = _authentication,
                             user = _user,
                       categories = _categories,
                       activities = _activities,
                       connection = _connection,
                          userHub = _userHub,
                      onlineUsers = _onlineUsers,
                          chatHub = _chatHub,
                            chats = _chats,
                      activityHub = _activityHub,
                           action = _action,
                         licences = _licences;


static BBApplication* bowerbirdApplication = nil;

+(BBApplication*)sharedInstance
{  
    if(bowerbirdApplication == nil)
    {
        bowerbirdApplication = [[super allocWithZone:NULL]init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:bowerbirdApplication
                                             selector:@selector(handleAuthenticatedUserStatusChanged)
                                                 name:@"authenticatedUserStatusChanged"
                                               object:nil];
    
    
    return bowerbirdApplication;
}

-(NSString*)action {
    return _action;
}

-(void)setAction:(NSString *)action {
    _action = action;
}


#pragma -mark -
#pragma -mark - User Hub

-(void)updateUserStatus:(NSString*)identifier
           withActivity:(NSDate *)latestActivity
          withHeartbeat:(NSDate *)latestHeartbeat
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

-(void)setupOnlineUsers:(id)users
{
    [BBLog Log:@"BBUserHubClient.setupOnlineUsers"];
    
    if([users isKindOfClass:[NSArray class]])
    {
        if([users count] > 0)
        {
            for (id user in users)
            {
                [BBLog Log:[NSString stringWithFormat:@"user online: %@", user]];
                [self insertOrUpdateUser:user];
            }
        }
    }
}

-(void)userStatusUpdate:(id)user
{
    [BBLog Log:@"BBUserHubClient.userStatusUpdate"];
    
    if([user isKindOfClass:[NSDictionary class]])
    {
        [BBLog Log:[NSString stringWithFormat:@"user online: %@", user]];
        
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
        // TODO: either change constructor to take mappable object and map using mapper
        // or change data back to json string and send to mapper
        insertUpdateUser = [[BBUser alloc] initWithObject:user];
        
        if(insertUpdateUser)
        {
            [self.onlineUsers addObject:insertUpdateUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusChanged" object:self];
        }
    }
    
    if([insertUpdateUser.identifier isEqualToString:self.user.identifier])
    {
        [self.user updateLatestActivity:[user objectForKey:@"LatestActivity"]];
    }
}


-(void)handleAuthenticatedUserStatusChanged
{
    [self updateUserStatus:self.user.identifier
              withActivity:self.user.latestActivity
             withHeartbeat:self.user.latestHeartbeat];
}

#pragma -mark -
#pragma -mark - Chat Hub

-(void)startPrivateChat:(NSString*)withUserId
{
    [BBLog Log:[NSString stringWithFormat:@"BBChatHubClient.startPrivateChat with: %@", withUserId]];
    
    NSArray* usersInChat = [NSArray arrayWithObjects:withUserId,self.user.identifier, nil];
    NSString* chatId = [BBHash GenerateHashFromArray:usersInChat];

    [self.chatHub invoke:@"JoinChat"
                withArgs:[NSArray arrayWithObjects:chatId, usersInChat, nil]];
}

-(void)joinGroupChat:(NSString*)groupId
{
    NSString* chatId = [BBHash GenerateHash:groupId];
    
    __block BBChat* chat;
    [self.chats enumerateObjectsUsingBlock:^(BBChat* obj, NSUInteger idx, BOOL *stop) {
        if([obj.identifier isEqualToString:chatId])
        {
            chat = obj;
        }
    }];
    
    if(!chat)
    {
        NSArray* usersInChat = [NSArray arrayWithObjects:self.user.identifier, nil];
        [self.chatHub invoke:@"JoinChat"
                    withArgs:[NSArray arrayWithObjects:chatId, usersInChat, chatId, nil]];
    }
}

-(void)sendTypingStatus:(NSString*)chatId
               isTyping:(BOOL)typing
{
    [self.chatHub invoke:@"Typing"
                withArgs:[NSArray arrayWithObjects:chatId, typing, nil]];
}

-(void)sendChatMessage:(BBChatMessage*)chatMessage
{
    [self.chatHub invoke:@"SendChatMessage"
                withArgs:[NSArray arrayWithObjects:chatMessage.chatId, chatMessage.messageId, chatMessage.message, nil]];
}

-(void)chatJoined:(id)payload
{
    [BBLog Log:@"BBApplication.chatJoined:"];
    [BBLog Log:payload];
    // grab the chat if it already exists
    
    // otherwise, show it
    
    // if it's not started, start it
}

-(void)chatExited:(id)payload
{
    [BBLog Log:@"BBApplication.chatExited:"];
    [BBLog Log:payload];
    // close this chat
}

-(void)userJoinedChat:(id)payload
{
    [BBLog Log:@"BBApplication.userJoinedChat:"];
    [BBLog Log:payload];
    
    // grab the chat
    
    // add the user to the chat
    
    // if the user is not 'this' user, and this is a 'group' chat, add the user's message
}

-(void)userExitedChat:(id)payload
{
    [BBLog Log:@"BBApplication.userExitedChat:"];
    [BBLog Log:payload];
    
    // grab the chat
    
    // remove the user from the chat
    
    // if the user is not 'this' user, show leaving message
}

-(void)newChatMessage:(id)payload
{
    [BBLog Log:@"BBApplication.newChatMessage:"];
    [BBLog Log:payload];
    
    // get the chat from the list of chats
    
    // if no chat, get the chat from the server
    
    // if there is a chat, try and find the message with the chat
    
    // else add this message to the chat
    
    
}

-(void)userIsTyping:(id)payload
{
    [BBLog Log:@"BBApplication.userIsTyping:"];
    [BBLog Log:payload];
    
    // find the chat
    
    // if the chat exists, find the user and set their typing status
}


#pragma -mark -
#pragma -mark - Activity Hub

-(void)newActivity:(id)payload
{
    [BBLog Log:@"BBApplication.newActivity"];
    [BBLog Log:payload];
    
    // trigger a whole bunch of events for the activity
}

#pragma mark -
#pragma mark - SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)clientConnection
{
    [BBLog Log:([NSString stringWithFormat:@"BBUserHubClient.SRConnectionDidOpen with ConnectionId: %@", clientConnection.connectionId])];
    
    [self.userHub invoke:@"RegisterUserClient" withArgs:[NSArray arrayWithObjects:self.authenticatedUser.user.identifier, nil]];
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


#pragma mark -
#pragma mark - Cleanup

- (void)dealloc
{
    abort();
    
    [self.connection stop];
    self.userHub = nil;
    self.chatHub = nil;
    self.activityHub = nil;
    self.connection.delegate = nil;
    self.connection = nil;
}

@end