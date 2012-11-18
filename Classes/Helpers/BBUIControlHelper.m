//
//  BBUIControlHelper.m
//  BowerBird
//
//  Created by Hamish Crittenden on 31/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBUIControlHelper.h"

@implementation BBUIControlHelper

+(UITextField *)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)text andDelegate:(id)delegate {
    //UITextField *textField = [[UITextField alloc]init];
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = text;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = delegate;
    
    return textField;
}

+(CoolMGButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString*)text withBlock:(ActionBlock)block {
    CoolMGButton *button = [[CoolMGButton alloc]initWithFrame:frame];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    //[button setButtonColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1]];
    [button setButtonColor:[UIColor colorWithRed:0.38 green:0.65 blue:0.9 alpha:1]];
    [button onControlEvent:UIControlEventTouchUpInside do:block];
    
    return button;
}

+(MGTableBoxStyled *)createMGTableBoxStyledWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding {
    MGTableBoxStyled *styledTable = [MGTableBoxStyled boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}


+(MGTableBox *)createMGTableBoxWithSize:(CGSize)size andBGColor:(UIColor *)color andHeading:(NSString*)heading andPadding:(UIEdgeInsets)padding {
    MGTableBox *styledTable = [MGTableBox boxWithSize:size];
    MGLine *headingLine = [MGLine lineWithLeft:heading right:nil size:CGSizeMake(size.width-padding.left-padding.right, size.height-padding.top-padding.bottom)];
    headingLine.font = HEADER_FONT;
    [styledTable.topLines addObject:headingLine];
    styledTable.backgroundColor = [UIColor whiteColor];
    styledTable.padding = padding;
    styledTable.backgroundColor = color;
    
    return styledTable;
}

@end