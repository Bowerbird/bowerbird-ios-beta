/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBCategories.h"
#import "BBModels.h"

@implementation NSString (ConvertMethods)

+(NSString *)ConvertFromArrayContents: (NSArray *)arrayOfStrings
{
    NSString* stringFromArrayContents = [[NSString alloc]init];
    
    for(NSString* str in arrayOfStrings)
    {
        stringFromArrayContents = [NSString stringWithFormat:@"%@%@", stringFromArrayContents, str];
    }
    
    return stringFromArrayContents;
}

@end
