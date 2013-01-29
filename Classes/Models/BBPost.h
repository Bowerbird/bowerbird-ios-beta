/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBPost : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* createdOnDescription;
@property (nonatomic,strong) BBGroup* group;
@property (nonatomic,strong) NSString* groupId;
@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSString* postType;
@property (nonatomic,strong) NSString* subject;
@property (nonatomic,strong) BBUser *user;

@end