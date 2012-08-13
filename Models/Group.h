/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Group : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *groupType;
@property (nonatomic, strong) Group *parentGroup;
@property (nonatomic, strong) NSArray *childGroups;
@property (nonatomic, strong) Image* avatar;

@end