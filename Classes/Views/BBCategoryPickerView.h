//
//  BBCategoryPickerView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLog.h"
#import "BBCategoryPickerDelegateProtocol.h"
#import "BBUIControlHelper.h"
#import "BBCategory.h"

@interface BBCategoryPickerView : UIView <
    BBCategoryPickerDelegateProtocol
    ,UIPickerViewDataSource
    ,UIPickerViewDelegate
>

@property (nonatomic,retain) id<BBCategoryPickerDelegateProtocol> controller;
@property (nonatomic,strong) UIPickerView *categoryPicker;
@property (nonatomic,strong) NSArray* categories;

-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate;

@end