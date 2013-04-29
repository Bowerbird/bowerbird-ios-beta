/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Client: Atlas of Living Australia
 
 Note: Model for passing to Registration process
 
 -----------------------------------------------------------------------------------------------*/


#import "BBRegisterRequest.h"
#import "BBLog.h"


@interface BBRegisterRequest()

@property (nonatomic,retain) NSString* email;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* password;
@property BOOL rememberme;

@end


@implementation BBRegisterRequest


#pragma mark -
#pragma mark - Member Accessors


@synthesize email = _email,
            name = _name,
            password = _password,
            rememberme = _rememberme;


#pragma mark -
#pragma mark - Constructors


-(id)initWithEmail:(NSString*)email
          password:(NSString*)password
              name:(NSString*)name {
    
    [BBLog Log:@"BBLoginRequest.initWithEmail:password:"];
    
    self = [super init];
    
    if(self){
        self.email = email;
        self.password = password;
        self.name = name;
        self.rememberme = YES;
    }
    
    return self;
}

@end