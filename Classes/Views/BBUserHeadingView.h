//
//  BBHeaderView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "UIView+Categories.h"

@class BBHeaderController;

@interface BBUserHeadingView : MGBox

@property (nonatomic,weak) UIButton *menuBtn;
@property (nonatomic,weak) UIButton *actionBtn;
@property (nonatomic,strong) UILabel *headingLabel;

-(BBUserHeadingView *)initWithSize:(CGSize)size
                     andTitle:(NSString *)title;

-(void)setHeadingText:(NSString*)heading;

@end