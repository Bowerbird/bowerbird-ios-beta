/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBImage.h"
#import "BBApplication.h"

@interface BBCollectionHelper : NSObject

+(NSArray*)populateArrayFromDictionary:(NSDictionary*)dictionary;

+(BBImage*)getImageWithDimension:(NSString*)dimensionName fromArrayOf:(NSArray*)images;

+(NSArray*)getUserProjects:(NSArray*)withIdentifiers inYesNotInNo:(BOOL)yesOrNo;

@end
