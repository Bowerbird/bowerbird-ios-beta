/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBConstants.h"


@interface BBCookieHelper : NSObject

+ (void) dumpCookies:(NSString *)msgOrNil;

+ (NSString *) cookieDescription:(NSHTTPCookie *)cookie;

+ (NSHTTPCookie *) grabCookieForUrl:(NSURL *)url withName:(NSString *) name;

+(void)deleteCookies;


@end