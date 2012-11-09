//
//  BBHomeView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 16/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBHomeView.h"

@implementation BBHomeView

-(BBHomeView *)initWithSize:(CGSize)size
{
    [BBLog Log:@"BBHomeView.initWithSize:"];
    
    self = [BBHomeView scrollerWithSize:size];
    self.tag = -1;
    self.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1];
    
    UIImage *logo = [UIImage imageNamed:@"background-icon.png"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logo];
    logoView.alpha = 0.5;
    
    logoView.center = CGPointMake(160, 220);
        
    [self addSubview:logoView];
    
    return self;
}

@end