/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface BBSignalRPayload : NSObject

@property (nonatomic,retain) NSString* hubName;
@property (nonatomic,retain) NSString* method;
@property (nonatomic,retain) NSMutableArray* args;
@property (nonatomic,retain) NSMutableDictionary* state;

@end
