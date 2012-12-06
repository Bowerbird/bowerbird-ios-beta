/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 *> Use this class for static global variables
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface BBConstants : NSObject

+(BOOL) TraceLog;

+(BOOL) TraceDebug;

+(BOOL) TraceError;

+(NSString*)BlueHexString;

+(NSString*)PurpleHexString;

+(NSURL*)RootUri;

+(NSString*)RootUriString;

+(NSURL*)ActivityUrl;

+(NSURL*)ProjectsUrl;

+(NSURL*)mySightingsUrl;

+(NSURL*)sightingsUrl;

+(NSURL*)myPostsUrl;

+(NSURL*)postsUrl;

+(NSURL*)AccountLoginUrl;

+(NSURL*)AuthenticatedUserProfileUrl;

+(NSString*)AuthCookieName;

+(NSArray*)AvatarTypes;

+(NSString *)NameOfAvatarDisplayImage;

+(NSString*)NameOfMediaResourceDisplayImage;

+(NSString*)CookieName;

+(NSDictionary*)AjaxRequestParams;

+(NSString*)AjaxQuerystring;

+(int)AwaySeconds;

+(int)OfflineSeconds;

+(int)DisappearSeconds;

+(NSArray*)ranksToQuery;

@end