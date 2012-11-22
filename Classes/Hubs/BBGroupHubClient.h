/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBHelpers.h"
#import "SignalR.h"

@interface BBGroupHubClient : NSObject <SRConnectionDelegate>

@property (nonatomic, retain) SRHubConnection* connection;
@property (nonatomic, retain) SRHubProxy* groupHub;

+(id)sharedInstance;

// calls from Server to Client
-(void)newActivity:(id)payload;

@end