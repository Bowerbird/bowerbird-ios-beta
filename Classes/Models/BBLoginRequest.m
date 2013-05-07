/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Client: Atlas of Living Australia
 
 Note: Model for passing to Login process
 
 -----------------------------------------------------------------------------------------------*/


#import "BBLoginRequest.h"
#import "BBLog.h"


@implementation BBLoginRequest


#pragma mark -
#pragma mark - Member Accessors


@synthesize email = _email,
            password = _password,
            rememberme = _rememberme;


-(NSString*)email { return _email; }
-(void)setEmail:(NSString *)email { _email = email; }
-(NSString*)password { return _password; }
-(void)setPassword:(NSString *)password { _password = password; }
-(BOOL)rememberme { return _rememberme; }
-(void)setRememberme:(BOOL)rememberme { _rememberme = rememberme; }


#pragma mark -
#pragma mark - Constructors


-(id)initWithEmail:(NSString*)email
          password:(NSString*)password {
    
    [BBLog Log:@"BBLoginRequest.initWithEmail:password:"];
    
    self = [super init];
    
    if(self){
        self.email = email;
        self.password = password;
        self.rememberme = YES;
    }
    
    return self;
}


@end