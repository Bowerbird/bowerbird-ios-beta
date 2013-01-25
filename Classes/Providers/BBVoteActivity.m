//
//  BBVoteActivity.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBVoteActivity.h"

@implementation BBVoteActivity

- (NSString *)activityType
{
    return @"yourappname.Review.App";
}

- (NSString *)activityTitle
{
    return @"Review App";
}

- (UIImage *)activityImage
{

    return [UIImage imageNamed:@"alarm.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity and UIActivityProvider
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=yourappid"]];
    
    [self activityDidFinish:YES];
}

@end