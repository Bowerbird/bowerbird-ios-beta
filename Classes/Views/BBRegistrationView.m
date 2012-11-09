//
//  BBRegistrationView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBRegistrationView.h"

@implementation BBRegistrationView


#pragma mark -
#pragma mark - Factories

-(BBRegistrationView *)initWithSize:(CGSize)size
{
    [BBLog Log:@"BBRegistrationView.initWithSize:"];
    
    self = [MGScrollView scrollerWithSize:size];
    self.contentLayoutMode = MGLayoutTableStyle;
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    
    return self;
}


@end