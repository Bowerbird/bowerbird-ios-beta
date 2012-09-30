/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface BBImage : NSObject

@property (nonatomic,retain) NSString* dimensionName;
@property (nonatomic,retain) NSString* uri;
@property (nonatomic,retain) NSString* mimeType;
@property (nonatomic,retain) NSNumber* width;
@property (nonatomic,retain) NSNumber* height;

-(BBImage*)initWithObject:(id)image havingName:(NSString*)name;

@end