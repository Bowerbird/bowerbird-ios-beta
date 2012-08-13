/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "NSNumber+ConvertMethods.h"

@implementation NSNumber (ConvertMethods)

+(NSNumber *)ConvertFromString: (NSString *)stringNumber
{
    return [NSNumber numberWithInteger:[stringNumber integerValue]];
}

@end