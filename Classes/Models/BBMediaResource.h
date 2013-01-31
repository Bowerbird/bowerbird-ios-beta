/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBMediaResource : NSObject


@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* mediaType;
@property (nonatomic,retain) NSDate* uploadedOn;
@property (nonatomic,retain) NSDictionary* metaData;
@property (nonatomic,retain) NSArray* imageMedia;
@property (nonatomic,retain) NSArray* audioMedia;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* licence;
@property (nonatomic,retain) NSString* key;
@property BOOL isPrimaryMedia;


-(BBMediaResource*)initWithAvatarObject:(id)avatar;


@end