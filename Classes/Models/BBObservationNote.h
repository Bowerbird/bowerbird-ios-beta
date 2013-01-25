/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBVoteDelegateProtocol.h"

@interface BBObservationNote : NSObject <
    BBVoteDelegateProtocol
>

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) NSString* createdOnDescription;
@property (nonatomic,strong) NSArray* descriptions;
@property (nonatomic,strong) NSArray* tags;
@property (nonatomic,strong) BBUser* user;
@property (nonatomic,strong) NSString* sightingId;
@property (nonatomic,strong) NSString* comments;
@property (nonatomic,strong) NSString* allTags;
@property (nonatomic,strong) NSNumber* tagCount;
@property (nonatomic,strong) NSNumber* descriptionCount;

@end