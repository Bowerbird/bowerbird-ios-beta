/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "User.h"

@interface MediaResource : NSObject

@property (nonatomic,strong) NSString* mediaType;
@property (nonatomic,strong) NSDate* uploadedOn;
@property (nonatomic,strong) NSDictionary* metaData;
@property (nonatomic,strong) NSDictionary* images;
@property (nonatomic,strong) User* user;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) NSString* licence;

@end
