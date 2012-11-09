//
//  BBProjectSelectView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBProjectSelectView.h"

@implementation BBProjectSelectView

@synthesize controller = _controller;
@synthesize projectTable = _projectTable;


-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate {
    [BBLog Log:@"BBProjectSelectView.initWithDelegate:"];

    _controller = delegate;
    self = [BBProjectSelectView scrollerWithSize:CGSizeMake(280, 200)];
    self.contentLayoutMode = MGLayoutTableStyle;
    self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    
    return self;
}

@end