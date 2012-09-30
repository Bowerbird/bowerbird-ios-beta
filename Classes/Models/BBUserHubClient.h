/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBHelpers.h"
#import "SignalR.h"

@interface BBUserHubClient : NSObject <SRConnectionDelegate>

@property (nonatomic, retain) SRHubConnection* connection;
@property (nonatomic, retain) SRHubProxy* userHub;
@property (nonatomic, retain) NSMutableArray* onlineUsers;

+(id)sharedInstance;

// calls from Client to Server
-(void)connectToUserHub:(NSString*)userId;

-(void)updateUserStatus:(NSString*)identifier
           withActivity:(NSDate*)latestActivity
          withHeartbeat:(NSDate*)latestHeartbeat;

// calls from Server to Client
-(void)setupOnlineUsers:(id)users;

-(void)userStatusUpdate:(id)user;

@end