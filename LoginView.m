//
//  LoginView.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 30/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize emailTextbox = _emailTextbox;
@synthesize passwordTextbox = _passwordTextbox;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
