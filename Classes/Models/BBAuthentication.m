/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> Use this class to attempt login and registration
 
 -----------------------------------------------------------------------------------------------*/

#import "BBAuthentication.h"

@implementation BBAuthentication

@synthesize authenticatedUser = _authenticatedUser;


-(void)setAuthenticatedUser:(BBUser *)authenticatedUser
{
    _authenticatedUser = authenticatedUser;
}
-(BBUser*)authenticatedUser
{
    return _authenticatedUser;
}

@end