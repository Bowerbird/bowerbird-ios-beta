/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBLoginRequest.h"


@implementation BBLoginRequest


#pragma mark -
#pragma mark - Member Accessors


@synthesize email = _email,
            password = _password,
            rememberme = _rememberme;


-(void)setEmail:(NSString *)email { _email = email; }
-(NSString*)email { return _email; }
-(void)setPassword:(NSString *)password { _password = password; }
-(NSString*)password { return _password; }
-(void)setRememberme:(BOOL)rememberme { _rememberme = rememberme; }
-(BOOL)rememberme { return _rememberme; }


@end