//
//  BBDateSelectController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLog.h"
#import "BBStyles.h"
#import "BBControllerBase.h"
#import "BBDateSelectView.h"
#import "BBDatePickerDelegateProtocol.h"

// as the facilitator of the edit, we only need to pass the updated value back to
// the parent controller, and close the editing view.
@interface BBDateSelectController : BBControllerBase <BBDatePickerDelegateProtocol>

@property (nonatomic,retain) id controller; // parent controller
@property (nonatomic,strong) BBDateSelectView *dateSelectView; // da view

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate; // setup with pointer to parent
-(NSDate*)createdOn;
-(void)updateCreatedOn:(NSDate*)date; // pass new value up to delegate parent controller
-(void)createdOnStopEdit; // we are finished editing so close this form

@end