/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This object is used to store global application data such as the logged in user
 
 -----------------------------------------------------------------------------------------------*/

#import "ApplicationData.h"

@implementation ApplicationData

@synthesize authenticatedUser = _authenticatedUser;
@synthesize authentication = _authentication;
@synthesize user = _user;
@synthesize categories = _categories;

static ApplicationData* bowerbirdApplicationData = nil;

#pragma mark - Shared instance/global of the AuthenticatedUser:

+(ApplicationData*)sharedInstance
{  
    if(bowerbirdApplicationData == nil)
    {
        bowerbirdApplicationData = [[super allocWithZone:NULL]init];
    }
    
    return bowerbirdApplicationData;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for non-singleton use.
    abort();
}

@end