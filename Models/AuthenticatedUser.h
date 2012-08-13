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

@interface AuthenticatedUser : NSObject <RequestDataFromServer, ProjectLoaded>

@property (retain) ASINetworkQueue *networkQueue;
@property (nonatomic,strong) User* user;
@property (nonatomic,strong) NSArray* categories;
@property (nonatomic, strong) NSDictionary* projects;
@property (nonatomic, strong) NSDictionary* teams;
@property (nonatomic, strong) NSDictionary* organisations;
@property (nonatomic, strong) NSDictionary* userProjects;
@property (nonatomic, strong) NSArray* memberships;
@property (nonatomic, strong) NSString* defaultLicence;

-(id)initWithJson:(NSDictionary*)dictionary;

-(void)loadAndNotifyDelegate:(id)delegate;

@end
