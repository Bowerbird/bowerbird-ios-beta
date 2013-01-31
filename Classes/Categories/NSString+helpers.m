/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "NSString+helpers.h"

@implementation NSString (helpers)

-(NSString*)capitalizeFirstLetter{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                         withString:[[self  substringToIndex:1] capitalizedString]];
}

@end