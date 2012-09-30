/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBEnumHelper.h"

@implementation BBEnumHelper

+(NSString*)onlineStatus:(UserStatus)status
{
    switch (status) {
        case online:
            return @"Online";
            
        case away:
            return @"Away";
            
        case offline:
        default:
            
            return @"Offline";
    }
}

@end
