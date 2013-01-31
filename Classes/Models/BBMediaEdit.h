/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBGuidGenerator.h"


@interface BBMediaEdit : NSObject


-(BBMediaEdit*)initWithImage:(UIImage*)image;


@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* licence;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) UIImage* image;
@property BOOL isPrimaryImage;


@end