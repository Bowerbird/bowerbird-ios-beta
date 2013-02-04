/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBBaseMedia.h"


@interface BBImage : BBBaseMedia


@property (nonatomic,retain) NSString* mimeType;
@property (nonatomic,retain) NSMutableDictionary* original;


@end