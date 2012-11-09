//
//  BBDateSelectView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLog.h"
#import "BBDatePickerDelegateProtocol.h"
#import "CoolMGButton.h"
#import "BBUIControlHelper.h"

@interface BBDateSelectView : UIView <
     BBDatePickerDelegateProtocol
>

@property (nonatomic,retain) id<BBDatePickerDelegateProtocol> controller;
@property (nonatomic,strong) UIDatePicker *datePicker;

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate;

@end