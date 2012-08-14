/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "NSDate+ConvertMethods.h"
#import "NSNumber+ConvertMethods.h"
#import "User.h"
#import "Project.h"
#import "Image.h"
#import "MediaResource.h"
#import "Project.h"
#import "Comment.h"
#import "ObservationLoaded.h"

@interface Observation : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSDate* observedOnDate;
@property (nonatomic,strong) NSString* address;
@property float latitude;
@property float longitude;
@property (nonatomic,strong) NSString* category;
@property BOOL isIdentificationRequired;
@property BOOL anonymiseLocation;
@property (nonatomic,strong) NSDictionary* media;
@property (nonatomic,strong) MediaResource* primaryMedia;
@property (nonatomic,strong) User* user;
@property (nonatomic,strong) NSDictionary* comments;
@property (nonatomic,strong) NSArray* projects;


@end
