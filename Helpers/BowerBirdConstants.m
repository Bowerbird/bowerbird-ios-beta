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
+(NSString *)RootUri
{
    // hamish's pc
    return @"http://136.154.22.24:65000";
    
    //return @"http://dev.bowerbird.org.au";
}

// restful segments
+(NSString *)ProjectUri
{
    return @"http://dev.bowerbird.org.au/projects";
}

+(NSString *)ObservationUri
{
    return @"http://dev.bowerbird.org.au/observations";
}

+(NSString *)AuthCookieName
{
    return @"ASP.NET_SessionId";
}

+(NSArray*)AvatarTypes
{
    return [NSArray arrayWithObjects: @"Original", @"Square42", @"Square100", @"Square200", nil];
}

+(NSString *)ProjectDisplayAvatarName
{
    return @"Square200";
}

@end
