/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBProtocols.h"
#import "BBHelpers.h"

@interface BBAuthenticatedUser : NSObject

@property (nonatomic, retain) BBUser* user;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSDictionary* projects;
@property (nonatomic, retain) NSDictionary* teams;
@property (nonatomic, retain) NSDictionary* organisations;
@property (nonatomic, retain) NSDictionary* userProjects;
@property (nonatomic, retain) NSArray* memberships;
@property (nonatomic, retain) NSString* defaultLicence;

@end