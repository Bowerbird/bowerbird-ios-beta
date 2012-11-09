//
//  BBDatePickerProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 29/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBDatePickerDelegateProtocol <NSObject>

@required
-(NSDate*)createdOn;

@optional
-(void)updateCreatedOn:(NSDate*)date;
-(void)createdOnStartEdit;
-(void)createdOnStopEdit;

@end