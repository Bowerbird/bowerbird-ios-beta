//
//  BBStreamView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBStreamView.h"

@implementation BBStreamView


#pragma mark -
#pragma mark - Factories

-(BBStreamView *)initWithFrame:(CGRect)frame
{
    [BBLog Log:@"BBStreamView.initWithSize:"];
    
    self = [super initWithFrame:frame];
    
    // basic box
    //self.size = CGSizeMake(frame.size.width, frame.size.height);
    //self.origin = CGPointMake(frame.origin.x, frame.origin.y);
    
    //self = [[BBStreamView alloc]initWithSize:size];
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    self.tag = -1;
    self.contentLayoutMode = MGLayoutTableStyle;
    
    return self;
}

@end