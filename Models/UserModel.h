/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "AvatarModel.h"
#import "SBJSON.h"
#import "AvatarImageLoaded.h"
#import "RequestDataFromServer.h"
#import "BowerBirdConstants.h"
#import "UserLoaded.h"


@interface UserModel : NSObject <AvatarImageLoaded>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) AvatarModel* avatar;

-(id)initWithJson:(NSDictionary*)dictionary;

@end