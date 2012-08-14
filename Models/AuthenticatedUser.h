/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "RequestDataFromServer.h"
#import "BowerBirdConstants.h"
#import "User.h"
#import "SBJSON.h"
#import "ImageLoaded.h"
#import "Project.h"
#import "Membership.h"
#import "CollectionHelper.h"
#import "AuthenticatedUserLoaded.h"
#import "CookieHelper.h"

@interface AuthenticatedUser : NSObject <RequestDataFromServer, ProjectLoaded, UserLoaded>

@property (retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) User* user;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSDictionary* projects;
@property (nonatomic, retain) NSDictionary* teams;
@property (nonatomic, retain) NSDictionary* organisations;
@property (nonatomic, retain) NSDictionary* userProjects;
@property (nonatomic, retain) NSArray* memberships;
@property (nonatomic, retain) NSString* defaultLicence;

-(id)initWithJson:(NSDictionary*)dictionary;

-(void)loadAndNotifyDelegate:(id)delegate;

@end
