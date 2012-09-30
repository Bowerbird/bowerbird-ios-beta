/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBChatMessage : NSObject

@property (nonatomic, retain) NSString* chatId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSDate* timestamp;
@property (nonatomic, retain) NSString* messageId;
@property (nonatomic, retain) NSString* message;

@end