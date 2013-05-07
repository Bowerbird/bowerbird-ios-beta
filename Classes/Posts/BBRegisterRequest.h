/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBRegisterRequest : NSObject

-(id)initWithEmail:(NSString*)email
          password:(NSString*)password
              name:(NSString*)name;

@property (nonatomic,retain) NSString* email;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* password;
@property BOOL rememberme;

@end