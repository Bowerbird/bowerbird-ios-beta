//
//  BBHeaderView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBUserHeadingView.h"

@implementation BBUserHeadingView 

@synthesize headingLabel =_headingLabel;

#pragma mark -
#pragma mark - Factories


-(void)setHeadingText:(NSString *)heading{
    [BBLog Log:@"BBHeaderView.setHeadingText:"];
    
    self.headingLabel.text = heading;
}

-(BBUserHeadingView *)initWithSize:(CGSize)size
                     andTitle:(NSString *)title
{    
    [BBLog Log:@"BBHeaderView.initWithSize:andTitle:"];
    
    self = [BBUserHeadingView boxWithSize:size];
    
    UIColor *headerBgColor = [UIColor whiteColor]; //[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    self.backgroundColor = headerBgColor;
    self.tag = -1;
    self.contentLayoutMode = MGLayoutTableStyle;
    
    UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(PADDING,PADDING,HEADER_BTTN.width, HEADER_BTTN.height)];
    menuBtn.frame = CGRectMake(PADDING,PADDING,HEADER_BTTN.width, HEADER_BTTN.height);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    menuBtn.backgroundColor = headerBgColor;
    [menuBtn addTarget:self action:@selector(menuTapped) forControlEvents:UIControlEventTouchDown];
    
    self.headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
    self.headingLabel.text = title;
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(size.width - HEADER_BTTN.width - PADDING, PADDING, HEADER_BTTN.width, HEADER_BTTN.height);
    [actionBtn setBackgroundImage:[UIImage imageNamed:@"action.png"] forState:UIControlStateNormal];
    actionBtn.backgroundColor = headerBgColor;
    [actionBtn addTarget:self action:@selector(actionTapped) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:menuBtn];
    [self addSubview:self.headingLabel];
    //[self addSubview:logoView];
    [self addSubview:actionBtn];
        
    return self;
}

-(void)menuTapped
{
    [BBLog Log:@"BBHeaderView.menuTapped"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}

-(void)actionTapped
{
    [BBLog Log:@"BBHeaderView.actionTapped"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTapped" object:nil];
}

@end