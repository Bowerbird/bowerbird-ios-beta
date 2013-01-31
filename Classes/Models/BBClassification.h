/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBClassification : NSObject


@property (nonatomic,strong) NSString* taxonomy;
@property (nonatomic,strong) NSString* name;
@property int rankPosition;
@property (nonatomic,strong) NSString* rankName;
@property (nonatomic,strong) NSString* rankType;
@property (nonatomic,strong) NSString* parentRankName;
@property (nonatomic,strong) NSArray* ranks;
@property (nonatomic,strong) NSString* category;
@property int speciesCount;
@property (nonatomic,strong) NSArray* commonGroupNames;
@property (nonatomic,strong) NSArray* commonNames;
@property (nonatomic,strong) NSArray* synonyms;
@property (nonatomic,strong) NSString* allCommonNames;


@end