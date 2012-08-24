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
{
    SRHubConnection *connection;
    SRHubProxy *userHub;
    NSMutableArray *onlineUsers;
}


@property (nonatomic, retain) SRHubConnection* connection;
@property (nonatomic, retain) SRHubProxy* userHub;
@property (nonatomic, retain) NSMutableSet* onlineUsers;

+(id)sharedInstance;

-(void)connectToUserHub:(NSString*)userId;

-(void)setupOnlineUsers:(id)users;

-(void)userStatusUpdate:(id)user;

@end