/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "AuthenticatedUser.h"
#import "Authentication.h"

@interface ApplicationData : NSObject

@property (nonatomic, retain) AuthenticatedUser* authenticatedUser;

@property (nonatomic, retain) Authentication* authentication;

@property (nonatomic, retain) User* user;

@property (nonatomic, retain) NSArray* categories;

+(id)sharedInstance;

@end
