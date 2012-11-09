//
//  BBCategoryPickerController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBCategoryPickerDelegateProtocol.h"
#import "BBCategoryPickerView.h"
#import "BBApplication.h"

@interface BBCategoryPickerController : BBControllerBase <
    BBCategoryPickerDelegateProtocol
>

@property (nonatomic,retain) id delegate; // parent controller
@property (nonatomic,strong) BBCategoryPickerView *categoryPickerView; // da view

-(id)initWithDelegate:(id<BBCategoryPickerDelegateProtocol>)delegate; // setup with pointer to parent
-(NSArray*)getCategories;
-(void)updateCategory:(NSString*)category; // pass new value up to delegate parent controller
-(void)categoryStopEdit; // we are finished editing so close this form

@end