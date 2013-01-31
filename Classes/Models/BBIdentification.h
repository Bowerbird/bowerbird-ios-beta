/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBVoteDelegateProtocol.h"


@class BBUser;


@interface BBIdentification : NSObject <
    BBVoteDelegateProtocol
>


@property BOOL isCustomIdentification;
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* sightingId;
@property (nonatomic,strong) NSDate* createdOn;
@property (nonatomic,strong) NSString* comments;
@property (nonatomic,strong) NSString* createdOnDescription;
@property (nonatomic,strong) NSString* category;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* rankName;
@property (nonatomic,strong) NSString* rankType;
@property (nonatomic,strong) NSArray* commonGroupNames;
@property (nonatomic,strong) NSArray* commonNames;
@property (nonatomic,strong) NSString* taxonomy;
@property (nonatomic,strong) NSArray* ranks;
@property (nonatomic,strong) NSArray* synonyms;
@property (nonatomic,strong) NSString* allCommonNames;
@property (nonatomic,strong) BBUser* user;


@end