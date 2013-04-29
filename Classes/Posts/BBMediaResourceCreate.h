/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BBGuidGenerator.h"
#import "UIImage+fixOrientation.h"


@class BBMediaEdit, BBValidationError;


@interface BBMediaResourceCreate : NSObject 

@property (nonatomic,retain) NSData* file;
@property (nonatomic,retain) NSString* fileName;
@property (nonatomic,retain) NSString* usage;
@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* type;
@property (nonatomic,strong) BBValidationError *errors;

-(BBMediaResourceCreate*)initWithMedia:(BBMediaEdit*)media
                              forUsage:(NSString*)usage;


@end