/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBCategories.h"
#import "BBModels.h"

@implementation NSDate (ConvertMethods)

+(NSDate *)ConvertFromJsonDate: (NSString *)jsonDate
{
    NSArray* dateTimeChunks = [jsonDate componentsSeparatedByString:@"T"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    @try
    {
        // first chunk is the date -> yyyy-MM-ddTHH:MM:SSZ
        NSArray* dateChunks = [[dateTimeChunks objectAtIndex:0] componentsSeparatedByString:@"-"];
        
        // if it's a true json date, this should take place
        if(dateChunks && [dateChunks count] == 2)
        {
            NSArray* timeChunks = [[[dateTimeChunks objectAtIndex:1] substringToIndex:[[dateTimeChunks objectAtIndex:1] length ]- 1] componentsSeparatedByString:@":"];
            
            // Convert string to date object
            dateFormat.dateStyle = NSDateFormatterFullStyle;
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", [NSString ConvertFromArrayContents:dateChunks],[NSString ConvertFromArrayContents:timeChunks]]];
            
            return date;
        }
        
        // otherwise try with a regular human readable short date -> 27 Jun 2012
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSDate *date = [dateFormat dateFromString:jsonDate];
        return date;
    }
    @catch (NSException *exception)
    {
        if([BBConstants Trace]) NSLog(@"Exception Occurred: %@", exception);
        
        return [NSDate date];
    }
    @finally
    {
        
    }
}

@end