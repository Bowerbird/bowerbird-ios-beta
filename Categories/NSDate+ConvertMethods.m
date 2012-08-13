/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "NSDate+ConvertMethods.h"
#import "NSString+ConvertMethods.h"

@implementation NSDate (ConvertMethods)

// change from format yyyy-MM-ddTHH:MM:SSZ to yyyy-MM-dd hh:mm:ss
+(NSDate *)ConvertFromJsonDate: (NSString *)jsonDate
{
    NSArray* dateTimeChunks = [jsonDate componentsSeparatedByString:@"T"];
    
    // first chunk is the date
    NSArray* dateChunks = [[dateTimeChunks objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray* timeChunks = [[[dateTimeChunks objectAtIndex:1] substringToIndex:[[dateTimeChunks objectAtIndex:1] length ]- 1] componentsSeparatedByString:@":"];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterFullStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", [NSString ConvertFromArrayContents:dateChunks],[NSString ConvertFromArrayContents:timeChunks]]];
    
    return date;
}

@end