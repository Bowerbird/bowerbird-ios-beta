//
//  BBDateSelectView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBDateSelectView.h"

@implementation BBDateSelectView

@synthesize controller = _controller;
@synthesize datePicker = _datePicker;

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBDateSelectView.initWithDelegate:"];
    
    self = [super initWithFrame:CGRectMake(0, 0, 280, 250)];
    
    UIView *datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 200)];
    _controller = delegate;
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.date = [self createdOn];
    [_datePicker addTarget:self action:@selector(changeObservationDate) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:_datePicker];
    
    // mask the picker
    UIPickerView *inner = _datePicker.subviews[0];
    CGFloat width = 0;
    for (int i = 0; i < inner.numberOfComponents; i++) {
        CGSize size = [inner rowSizeForComponent:i];
        width += size.width + 5;
    }
    float widthOfParent = 300;
    CGFloat left = roundf((widthOfParent - width) / 2);
    CALayer *mask = CALayer.layer;
    mask.backgroundColor = UIColor.blackColor.CGColor;
    mask.frame = CGRectMake(left*2, 10, width, 196);
    mask.cornerRadius = 6;
    _datePicker.layer.mask = mask;
    
    // wrap the picker
    CGRect frame = CGRectMake(0, 0, width, 196);
    UIView *wrap = [[UIView alloc] initWithFrame:frame];
    _datePicker.center = (CGPoint){roundf((frame.size.width) / 2), roundf(frame.size.height / 2)};
    [wrap addSubview:datePickerView];
    
    CoolMGButton *doneButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, wrap.size.height + 10, wrap.width, 40)
                                                               andTitle:@"Finished"
                                                              withBlock:^{[self doneClicked];}];
    
    // add to the parent view
    [self addSubview:wrap];
    [self addSubview:doneButton];

    return self;
}

-(void)changeObservationDate {
    [BBLog Log:@"BBDateSelectView.changeObservationDate:"];
    
    if([_controller respondsToSelector:@selector(updateCreatedOn:)]){
        [_controller updateCreatedOn:_datePicker.date];
    }
}

-(NSDate*)createdOn {
    [BBLog Log:@"BBDateSelectView.createdOn:"];
    
    if([_controller respondsToSelector:@selector(createdOn)]){
        return [_controller createdOn];
    }
    else return [NSDate date];
}

-(void)doneClicked {
    [BBLog Log:@"BBDateSelectView.doneClicked"];

    if([_controller respondsToSelector:@selector(createdOnStopEdit)]){
        [_controller createdOnStopEdit];
    }
}

@end