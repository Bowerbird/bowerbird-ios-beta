/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBHelpers.h"
#import "SignalR.h"

@interface BBChatHubClient : NSObject <SRConnectionDelegate>

@property (nonatomic, retain) SRHubConnection* connection;
@property (nonatomic, retain) SRHubProxy* chatHub;
@property (nonatomic, retain) SRHubProxy* userHub;
@property (nonatomic, retain) NSMutableArray* chats;


+(id)sharedInstance;

// calls from Client to Server
-(void)startPrivateChat:(NSString*)chatId;

-(void)joinGroupChat:(NSString*)groupId;

-(void)sendTypingStatus:(NSString*)chatId
               isTyping:(BOOL)typing;

-(void)sendChatMessage:(BBChatMessage*)chatMessage;


// calls from Server to Client
-(void)userJoinedChat:(id)payload;
-(void)userExitedChat:(id)payload;
-(void)newChatMessage:(id)payload;
-(void)userIsTyping:(id)payload;

@end
