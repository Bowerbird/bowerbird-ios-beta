//
//  BBActionView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBActionView.h"

@implementation BBActionView


#pragma mark -
#pragma mark - Factories

-(BBActionView *)initWithSize:(CGSize)size
{
    [BBLog Log:@"BBActionView.initWithSize:"];
    
    // basic box
    self = [BBActionView boxWithSize:size];
    
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    self.tag = -1;
    self.contentLayoutMode = MGLayoutGridStyle;

 //   [self populateActionView];
    
    return self;
}

@end