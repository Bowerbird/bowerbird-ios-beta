/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBMembership : NSObject


@property (nonatomic, strong) NSString* groupId;
@property (nonatomic, strong) NSString* groupType;
@property (nonatomic, strong) NSArray* permissions;
@property (nonatomic, strong) NSArray* roleIds;


@end