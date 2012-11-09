/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "SignalR.h"

@class BBAuthenticatedUser,BBAuthentication, BBUser, BBChatMessage;

@interface BBApplication : NSObject <SRConnectionDelegate>

@property (nonatomic, retain) BBAuthenticatedUser* authenticatedUser;
@property (nonatomic, retain) BBAuthentication* authentication;
@property (nonatomic, retain) BBUser* user;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* licences;

@property (nonatomic, retain) SRHubConnection* connection;
@property (nonatomic, retain) SRHubProxy* userHub;
@property (nonatomic, retain) NSMutableArray* onlineUsers;
@property (nonatomic, retain) SRHubProxy* chatHub;
@property (nonatomic, retain) NSMutableArray* chats;
@property (nonatomic, retain) SRHubProxy* activityHub;
@property (nonatomic, retain) NSArray* activities;
@property (nonatomic, strong) NSString* action;

+(id)sharedInstance;
-(void)handleAuthenticatedUserStatusChanged;

#pragma -mark -
#pragma -mark - User Hub

// calls from Client to Server
-(void)updateUserStatus:(NSString*)identifier
           withActivity:(NSDate*)latestActivity
          withHeartbeat:(NSDate*)latestHeartbeat;

// calls from Server to Client
-(void)setupOnlineUsers:(id)users;
-(void)userStatusUpdate:(id)user;


#pragma -mark -
#pragma -mark - Chat Hub

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


#pragma -mark -
#pragma -mark - Activity Hub

// calls from Server to Client
-(void)newActivity:(id)payload;

@end