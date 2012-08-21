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

+(BOOL) Trace
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
    // Hamish's PC
    return @"http://dev.bowerbird.org.au";
    
    // Bowerbird dev server
    //return @"http://136.154.22.24:65000";
}

// restful segments
+(NSURL *)ProjectsUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self RootUriString], @"/projects"]];
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
    return [NSArray arrayWithObjects: @"Original", @"Square42", @"Square100", @"Square200", nil];
}

+(NSArray*)MediaImageTypes
{
    return [NSArray arrayWithObjects:@"Original",@"Square42", @"Square100", @"Square200",@"Full480",@"Full768",@"Full1024", nil];
}

+(NSString *)NameOfAvatarDisplayImage
{
    return @"Square200";
}

+(NSString*)NameOfMediaResourceDisplayImage
{
    return @"Full768";
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

@end
