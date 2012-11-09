//
//  BBHeaderController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBHeaderController.h"

@implementation BBHeaderController


#pragma mark -
#pragma mark - Setup and Render


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BBLog Log:@"BBHeaderController.viewDidLoad"];
}


-(void)loadView {
    [BBLog Log:@"BBHeaderController.loadView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setHeadingWithTitle:)
                                                 name:@"updateHeadingTitle"
                                               object:nil];
    
    self.view = [[BBUserHeadingView alloc] initWithSize:IPHONE_HEADER_PORTRAIT andTitle:@"BowerBird"];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)setHeadingWithTitle:(NSNotification *) notification
{
    NSDictionary* userInfo = [notification userInfo];
    self.view = [[BBUserHeadingView alloc] initWithSize:IPHONE_HEADER_PORTRAIT andTitle:[userInfo objectForKey:@"name"]];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBHeaderController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Delegation and Event Handling


@end