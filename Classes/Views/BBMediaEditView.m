//
//  BBMediaDescriptionView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMediaEditView.h"


typedef void (^ActionBlock)();


@implementation BBMediaEditView {
    UIImage* mediaImage;
    NSDictionary* ccLicences;
}


@synthesize controller = _controller;
@synthesize mediaBox = _mediaBox;
@synthesize licencePicker = _licencePicker;
@synthesize captionTextField = _captionTextField;
@synthesize isPrimaryMedia = _isPrimaryMedia;


#pragma mark -
#pragma mark - Setup and Config


-(BBMediaEditView*)initWithDelegate:(id<BBMediaEditDelegateProtocol>)delegate andImage:(UIImage *)image {
    
    self = [self init];
    
    self.controller = delegate;
    mediaImage = image;
    
    return self;
}


#pragma mark -
#pragma mark - Delegate and Protocol interaction

-(NSArray*)getLicences {
    return [self.controller getLicences];
}

-(NSString*)getUserDefaultLicence {
    return [self.controller getUserDefaultLicence];
}

-(void)setAsPrimaryImage {
    [self.controller setAsPrimaryImage];
}

-(void)updateCaption:(NSString *)caption {
    [self.controller updateCaption:caption];
}

-(void)updateLicence:(NSString *)licence {
    [self.controller updateLicence:licence];
}

-(void)saveMediaEdit{
    [self.controller saveMediaEdit];
}

-(void)cancelMediaEdit {
    [self.controller cancelMediaEdit];
}

#pragma mark -
#pragma mark - Utilities and Helpers

-(UITextField *)createTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = text;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    
    return textField;
}

-(CoolMGButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString*)text withBlock:(ActionBlock)block {
    CoolMGButton *button = [[CoolMGButton alloc]initWithFrame:frame];
    //button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    [button setButtonColor:[UIColor colorWithRed:232 green:228 blue:219 alpha:1]];
    [button onControlEvent:UIControlEventTouchUpInside do:block];
    
    return button;
}

@end