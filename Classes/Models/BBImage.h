/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBImage : NSObject

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* imageDimensionName;
@property (nonatomic,retain) NSString* fileName;
@property (nonatomic,retain) NSString* relativeUri;
@property (nonatomic,retain) NSString* format;
@property (nonatomic,retain) NSNumber* width;
@property (nonatomic,retain) NSNumber* height;
@property (nonatomic,retain) NSString* extension;
@property (nonatomic,retain) NSString* originalFileName;
@property (nonatomic,retain) NSDictionary* exifData;
@property (nonatomic,retain) UIImage* image;

@end
