/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"


@interface BBObservationNote : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) BBIdentification* identification;
@property (nonatomic,strong) NSString* taxonomy;
@property (nonatomic,strong) NSArray* descriptions;
@property (nonatomic,strong) NSArray* tags;
@property (nonatomic,strong) BBUser* user;
@property int tagCount;
@property int descriptionCount;
@property (nonatomic,strong) NSString* allTags;


@end