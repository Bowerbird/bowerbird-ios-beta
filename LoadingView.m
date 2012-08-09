//
//  LoadingView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 1/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

-(void)setup
{
    self.ContentMode = UIViewContentModeRedraw;
   
    
    [self setBackgroundColor:[UIColor colorWithHex:[BowerBirdConstants BowerbirdBlueHexString] alpha:1.0]];
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
