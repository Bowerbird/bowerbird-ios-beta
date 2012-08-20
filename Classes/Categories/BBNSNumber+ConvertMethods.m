/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBCategories.h"
#import "BBModels.h"

@implementation NSNumber (ConvertMethods)

+(NSNumber *)ConvertFromStringToInteger: (NSString *)stringNumber
{
    return [NSNumber numberWithInteger:[stringNumber integerValue]];
}

+(NSNumber*) ConvertFromStringToFloat:(NSString *)stringNumber
{
    return [NSNumber numberWithFloat:[stringNumber floatValue]];
}

@end