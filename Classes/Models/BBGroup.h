/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBGroup : NSObject

@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *groupType;
@property (nonatomic,retain) NSNumber *memberCount;
@property (nonatomic,retain) NSNumber *postCount;
@property (nonatomic,retain) BBMediaResource* avatar;

@end