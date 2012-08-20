/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBComment : NSObject

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* sequentialId;
@property (nonatomic,retain) NSDate* commentedOn;
@property (nonatomic,retain) BBUser* user;
@property (nonatomic,retain) NSString* message;
@property (nonatomic,retain) NSArray* comments;

@end