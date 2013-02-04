/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


typedef enum {
    BBMediaVideo = 0,
    BBMediaImage = 1,
    BBMediaAudio = 2,
    BBMediaUnknown = 3
} BBMediaType;


@class BBMedia, BBBaseMedia;


@interface BBUIMediaHelper : NSObject

+(BBBaseMedia*)getMediaOfSize:(NSString*)sizeName from:(NSArray*)mediaItems;

+(BBMediaType)typeOfMedia:(NSString*)mediaType;

@end

