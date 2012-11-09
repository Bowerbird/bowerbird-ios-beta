//
//  BBMenuView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMenuView.h"

@implementation BBMenuView


#pragma mark -
#pragma mark - Factories

-(BBMenuView *)initWithSize:(CGSize)size
{
    [BBLog Log:@"BBHeaderView.initWithSize:"];
    
    self = [BBMenuView scrollerWithSize:size];
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    self.contentLayoutMode = MGLayoutTableStyle;
    
    return self;
}

@end