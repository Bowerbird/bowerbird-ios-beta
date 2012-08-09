/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "RequestDataFromServer.h"
#import "BowerBirdConstants.h"
#import "UserModel.h"
#import "SBJSON.h"
#import "AvatarImageLoadCompleteDelegate.h"
#import "ProjectModel.h"
#import "MembershipModel.h"
#import "CollectionHelper.h"
#import "AuthenticatedUserModelLoadCompleteDelegate.h"
#import "CookieHelper.h"

@interface AuthenticatedUserModel : NSObject <RequestDataFromServer, AvatarImageLoadCompleteDelegate>

@property (retain) ASINetworkQueue *networkQueue;

@property (nonatomic,strong) UserModel* user;
@property (nonatomic,strong) NSArray* categories;
@property (nonatomic, strong) NSArray* projects;
@property (nonatomic, strong) NSArray* teams;
@property (nonatomic, strong) NSArray* organisations;
@property (nonatomic, strong) NSArray* userProjects;
@property (nonatomic, strong) NSArray* memberships;
@property (nonatomic, strong) NSString* defaultLicence;

+(AuthenticatedUserModel*)loadAuthenticatedUserModelFromResponseString:(NSString *)responseString;

- (void)doGetRequest:(NSURL *)withUrl;

@end
