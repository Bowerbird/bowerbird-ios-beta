/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBMediaResource : NSObject

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* mediaType;
@property (nonatomic,retain) NSDate* uploadedOn;
@property (nonatomic,retain) NSDictionary* metaData;
@property (nonatomic,retain) NSArray* media;
//@property (nonatomic,retain) BBImage* image;
//@property (nonatomic,retain) BBUser* user;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* licence;
@property (nonatomic,retain) NSString* key;
@property BOOL isPrimaryMedia;

@end
