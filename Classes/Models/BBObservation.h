/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@class BBMediaResource;

@interface BBObservation : NSObject

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSDate* observedOnDate;
@property (nonatomic,retain) NSString* address;
@property float latitude;
@property float longitude;
@property (nonatomic,retain) NSString* category;
@property BOOL isIdentificationRequired;
@property BOOL anonymiseLocation;
@property (nonatomic,retain) NSSet* media;
@property (nonatomic,retain) BBMediaResource* primaryMedia;
@property (nonatomic,retain) BBUser* user;
@property (nonatomic,retain) NSArray* comments;
@property (nonatomic,retain) NSSet* projectIds;

@end
