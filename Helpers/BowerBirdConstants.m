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

+(NSString *)NameOfAvatarImageThatGetsDisplayed
{
    return @"Square200";
}

+(NSString *)BowerbirdCookieName
{
    return @".BOWERBIRDAUTH";
}

@end
