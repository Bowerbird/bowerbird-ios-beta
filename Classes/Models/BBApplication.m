/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> This object is used to store global application data such as the logged in user
 
 -----------------------------------------------------------------------------------------------*/

#import "BBApplication.h"


@implementation BBApplication


#pragma mark -
#pragma mark - Member Accessors


@synthesize     authenticatedUser = _authenticatedUser,
                authentication = _authentication,
                user = _user,
                categories = _categories,
                licences = _licences;


static BBApplication* bowerbirdApplication = nil;
+(BBApplication*)sharedInstance {
    if(bowerbirdApplication == nil) bowerbirdApplication = [[super allocWithZone:NULL]init];
    return bowerbirdApplication;
}


#pragma mark -
#pragma mark - Cleanup


- (void)dealloc {
    abort();
}


@end