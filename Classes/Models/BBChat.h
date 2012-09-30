/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@class BBChatMessage;

@interface BBChat : NSObject

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) BBGroup* group;
@property BOOL isStarted;
@property (nonatomic, retain) NSMutableArray* chatUsers;
@property (nonatomic, retain) NSMutableArray* chatMessages;

-(void)addChatMessage:(BBChatMessage*)chatMessage;

-(NSString*)chatType;

@end