/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@class BBAuthenticatedUser,BBAuthentication;

@interface BBApplicationData : NSObject

@property (nonatomic, retain) BBAuthenticatedUser* authenticatedUser;
@property (nonatomic, retain) BBAuthentication* authentication;
@property (nonatomic, retain) BBUser* user;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* activities;

+(id)sharedInstance;

@end