/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBConstants.h"

@implementation BBConstants

// colors
+(NSString *)BlueHexString
{
    return @"#16255B";
}

+(NSString *)PurpleHexString
{
    return @"#606a85";
}

+(BOOL) TraceLog
{
    return YES;
}

+(BOOL) TraceDebug
{
    return YES;
}

+(BOOL) TraceError
{
    return YES;
}

// url
+(NSURL *)RootUri
{
    return [NSURL URLWithString:[self RootUriString]];
}

+(NSString *)RootUriString
{
    // dev.bowerbird.org.au
    return @"http://dev.bowerbird.org.au";
    
    // Hamish's PC
    // return @"http://136.154.22.24:65000";
}

// restful segments
+(NSURL *)ProjectsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/projects"]];
}

// only my sightings url
+(NSURL*)mySightingsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/mysightings"]];
}


// sightings url
+(NSURL*)sightingsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/allsightings"]];
}

// only my posts url
+(NSURL*)myPostsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/myposts"]];
}

// posts url
+(NSURL*)postsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/allposts"]];
}

// restful segments
+(NSURL *)ActivityUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/activity"]];
}

+(NSURL *)AccountLoginUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/login"]];
}

+(NSURL *)AuthenticatedUserProfileUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/account/profile"]];
}

+(NSString *)AuthCookieName
{
    return @"ASP.NET_SessionId";
}

+(NSArray*)AvatarTypes
{
    return [NSArray arrayWithObjects: @"Original", @"Square50", @"Square100", @"Square200", nil];
}

+(NSArray*)MediaImageTypes
{
    return [NSArray arrayWithObjects:@"Original",@"Constrained240", @"Constrained480", @"Constrained600",@"Full1024",@"Full640",@"Full480", @"Square50", @"Square100", @"Square200", nil];
}

+(NSString *)NameOfAvatarDisplayImage
{
    return @"Square200";
}

+(NSString*)NameOfMediaResourceDisplayImage
{
    return @"Square200";
}

+(NSString *)CookieName
{
    return @".BOWERBIRDAUTH";
}

+(NSDictionary*)AjaxRequestParams
{
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"XMLHttpRequest",@"X-Requested-With", @"Content-Type", @"application/x-www-form-urlencoded", nil];
}

+(NSString*)AjaxQuerystring
{
    return @"X-Requested-With=XMLHttpRequest&Content-Type=application%2Fx-www-form-urlencoded";
}

+(int)AwaySeconds
{
    return 180;
}

+(int)OfflineSeconds
{
    return 360;
}

+(int)DisappearSeconds
{
    return 720;
}

+(NSArray*)ranksToQuery {
    return [[NSArray alloc]initWithObjects:@"allranks", @"rank2", @"rank3", @"rank4", @"rank5", @"rank6", @"rank7",  nil];
}

@end