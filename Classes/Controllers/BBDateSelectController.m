//
//  BBDateSelectController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBDateSelectController.h"

@implementation BBDateSelectController

@synthesize controller = _controller;
@synthesize dateSelectView = _dateSelectView;

-(id)initWithDelegate:(id<BBDatePickerDelegateProtocol>)delegate {
    [BBLog Log:@"BBDateSelectController.initWithDelegate"];
    
    self = [super init];
    
    _controller = delegate;
    _dateSelectView = [[BBDateSelectView alloc]initWithDelegate:self];
    _dateSelectView.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBDateSelectController.loadView"];
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    self.view = self.dateSelectView;
}

-(NSDate*)createdOn {
    [BBLog Log:@"BBDateSelectController.createdOn"];
    
    return [_controller createdOn];
}

-(void)updateCreatedOn:(NSDate*)date {
    [BBLog Log:@"BBDateSelectController.updateCreatedOn:"];
    
    if([_controller respondsToSelector:@selector(updateCreatedOn:)]){
        [_controller updateCreatedOn:date];
    }
    else [BBLog Log:@"LOGIC ERROR: BBObservationEditController does not respond to updateCreatedOn"];
}

-(void)createdOnStopEdit {
    [BBLog Log:@"BBDateSelectController.createdOnStopEdit"];
    
    if([_controller respondsToSelector:@selector(createdOnStopEdit)]){
        [_controller createdOnStopEdit];
    }
    else [BBLog Log:@"LOGIC ERROR: BBObservationEditController does not respond to createdOnStopEdit"];
}

@end