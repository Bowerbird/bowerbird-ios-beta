/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BBModels.h"
#import "BBHelpers.h"
#import "BBEnumHelper.h"

@class BBMediaResource;

@interface BBUser : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *latestActivity;
@property (nonatomic, strong) NSDate *latestHeartbeat;
@property (nonatomic, strong) BBMediaResource* avatar;
@property UserStatus userStatus;

-(BBUser*)initWithObject:(id)user;

-(void)updateLatestActivity:(NSString*)latestActivity;

@end