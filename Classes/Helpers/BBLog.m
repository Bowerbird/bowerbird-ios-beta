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
    if([BBConstants TraceLog])
    {
        NSLog(@"%@", message);
    }
}

+(void)Error:(id)message
{
    if([BBConstants TraceError])
    {
        NSLog(@"%@", message);
    }
}

+(void)Debug:(id)payload withMessage:(NSString*)message
{
    if([BBConstants TraceDebug])
    {
        NSLog(@"%@", message);
    }
}

+(void)LogStringArray:(NSArray*)params
{
    if([BBConstants TraceLog])
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