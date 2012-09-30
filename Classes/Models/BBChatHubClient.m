/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBChatHubClient.h"

@interface BBChatHubClient()
-(void)ensureConnectionExists;
-(NSString*)generateChatId:(NSArray*)fromUserIds;
@end

@implementation BBChatHubClient

@synthesize     chatHub = _chatHub,
                userHub = _userHub,
             connection = _connection,
                  chats = _chats;


static BBChatHubClient* bowerbirdChatHubClient = nil;

+(BBChatHubClient*)sharedInstance
{
    if(bowerbirdChatHubClient == nil)
    {
        bowerbirdChatHubClient = [[super allocWithZone:NULL]init];
    }
    
    return bowerbirdChatHubClient;
}

-(void)ensureConnectionExists
{
    self.connection = [SRHubConnection connectionWithURL:[BBConstants RootUriString]];
    self.chatHub = [self.connection createProxy:@"ChatHub"];
    self.userHub = [self.connection createProxy:@"UserHub"];
    
    [self.chatHub on:@"newChatMessage"
             perform:self
            selector:@selector(newChatMessage:)];
    
    [self.chatHub on:@"userJoinedChat"
             perform:self
            selector:@selector(userJoinedChat:)];
    
    [self.chatHub on:@"userExitedChat"
             perform:self
            selector:@selector(userExitedChat:)];
    
    [self.chatHub on:@"userIsTyping"
             perform:self
            selector:@selector(userIsTyping:)];
    
    [self.userHub on:@"chatJoined"
             perform:self
            selector:@selector(chatJoined:)];
    
    [self.userHub on:@"chatExited"
             perform:self
            selector:@selector(chatExited:)];
    
    [self.connection setDelegate:self];
    [self.connection start];
}

-(NSString*)generateChatId:(NSArray*)fromUserIds
{
    NSMutableArray* sortableArray = [NSMutableArray arrayWithArray:fromUserIds];
    
    NSArray* sortedIds = [sortableArray sortedArrayUsingSelector:@selector(compare:)];
    
    __block NSString* joinedIds;
    [sortedIds enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        joinedIds = [joinedIds stringByAppendingString:obj];
    }];
    
    NSString* hashedId = [BBHash GenerateHash:joinedIds];
    
    return hashedId;
}


#pragma mark -
#pragma mark - Calls from Client to Server

-(void)startPrivateChat:(NSString*)withUserId
{
    [BBLog Log:[NSString stringWithFormat:@"BBChatHubClient.startPrivateChat with: %@", withUserId]];
    
    // generate a hash of the chat from the user and self's identifiers
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    NSArray* usersInChat = [NSArray arrayWithObjects:withUserId,appData.user.identifier, nil];
    NSString* chatId = [self generateChatId:usersInChat];
    
    [self ensureConnectionExists];
    
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
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        NSArray* usersInChat = [NSArray arrayWithObjects:appData.user.identifier, nil];
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


#pragma mark -
#pragma mark - Calls from Server to Client

-(void)chatJoined:(id)payload
{
    [BBLog Log:@"BBChatHubClient.chatJoined:"];
    [BBLog Log:payload];
    // grab the chat if it already exists
    
    // otherwise, show it
    
    // if it's not started, start it
}

-(void)chatExited:(id)payload
{
    [BBLog Log:@"BBChatHubClient.chatExited:"];
    [BBLog Log:payload];
    // close this chat
}

-(void)userJoinedChat:(id)payload
{
    [BBLog Log:@"BBChatHubClient.userJoinedChat:"];
    [BBLog Log:payload];
    
    // grab the chat
    
    // add the user to the chat
    
    // if the user is not 'this' user, and this is a 'group' chat, add the user's message
}

-(void)userExitedChat:(id)payload
{
    [BBLog Log:@"BBChatHubClient.userExitedChat:"];
    [BBLog Log:payload];
    
    // grab the chat
    
    // remove the user from the chat
    
    // if the user is not 'this' user, show leaving message
}

-(void)newChatMessage:(id)payload
{
    [BBLog Log:@"BBChatHubClient.newChatMessage:"];
    [BBLog Log:payload];
    
    // get the chat from the list of chats
    
    // if no chat, get the chat from the server
    
    // if there is a chat, try and find the message with the chat
    
        // else add this message to the chat
    
    
}

-(void)userIsTyping:(id)payload
{
    [BBLog Log:@"BBChatHubClient.userIsTyping:"];
    [BBLog Log:payload];
    
    // find the chat
    
    // if the chat exists, find the user and set their typing status
}

@end
