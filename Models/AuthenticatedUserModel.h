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
#import "AvatarImageLoaded.h"
#import "ProjectModel.h"
#import "MembershipModel.h"
#import "CollectionHelper.h"
#import "AuthenticatedUserLoaded.h"
#import "CookieHelper.h"

@interface AuthenticatedUserModel : NSObject <RequestDataFromServer, AvatarImageLoaded>

@property (retain) ASINetworkQueue *networkQueue;
@property (nonatomic,strong) UserModel* user;
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
