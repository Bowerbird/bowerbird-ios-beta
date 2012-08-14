/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> Use this class for static global variables
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface BowerBirdConstants : NSObject

+(BOOL) Trace;

+(NSString *)BowerbirdBlueHexString;

+(NSString *)BowerbirdPurpleHexString;

+(NSURL *)RootUri;

+(NSString *)RootUriString;

+(NSURL *)ActivityUrl;

+(NSURL *)ProjectsUrl;

+(NSURL *)AccountLoginUrl;

+(NSURL *)AuthenticatedUserProfileUrl;

+(NSString *)AuthCookieName;

+(NSArray*)AvatarTypes;

+(NSString *)NameOfAvatarDisplayImage;

+(NSString*)NameOfMediaResourceDisplayImage;

+(NSString *)BowerbirdCookieName;

@end
