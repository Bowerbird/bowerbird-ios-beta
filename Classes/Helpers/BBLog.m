/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBLog.h"
#import "BBConstants.h"

@implementation BBLog

+(void)Log:(id)message
{
    if([BBConstants Trace])
    {
        NSLog(@"%@", message);
    }
}

+(void)LogStringArray:(NSArray*)params
{
    if([BBConstants Trace])
    {
        __block NSString* message;
        [params enumerateObjectsUsingBlock:^(NSString* param, NSUInteger idx, BOOL *stop)
         {
             if([param isKindOfClass:[NSString class]]){
                 [message stringByAppendingFormat:@"%@ | ", param];
             }
         }];
        
        [BBLog Log:message];
    }
}

@end