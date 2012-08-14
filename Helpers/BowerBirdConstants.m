//
//  BowerBirdUIConstants.m
//  BowerBird
//
//  Created by Hamish Crittenden on 1/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BowerBirdConstants.h"

@implementation BowerBirdConstants

// colors
+(NSString *)BowerbirdBlueHexString
{
    return @"#16255B";
}

+(NSString *)BowerbirdPurpleHexString
{
    return @"#606a85";
}

+(BOOL) Trace
{
    return NO;
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

+(NSString *)BowerbirdCookieName
{
    return @".BOWERBIRDAUTH";
}

@end
