/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This object is used to store global application data such as the logged in user
 
 -----------------------------------------------------------------------------------------------*/

#import "BBApplicationData.h"

@implementation BBApplicationData

@synthesize     authenticatedUser = _authenticatedUser,
                   authentication = _authentication,
                             user = _user,
                       categories = _categories,
                       activities = _activities;

static BBApplicationData* bowerbirdApplicationData = nil;

+(BBApplicationData*)sharedInstance
{  
    if(bowerbirdApplicationData == nil)
    {
        bowerbirdApplicationData = [[super allocWithZone:NULL]init];
    }
    
    return bowerbirdApplicationData;
}

- (void)dealloc
{
    abort();
}

@end