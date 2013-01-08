//
//  BBStreamView.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBStreamView.h"

@interface BBStreamView()

@property (nonatomic,strong) id<BBStreamProtocol> controller;

@end

@implementation BBStreamView

@synthesize controller = _controller;
@synthesize tableFooterView = _tableFooterView;

-(BBStreamView*)initWithDelegate:(id<BBStreamProtocol>)delegate
                         andSize:(CGSize)size
{
    self = [super init];

    self.size = size;
    
    // tableFooterView needs to be visible at the bottom of the scroll view... then hidden..?
    self.tableFooterView = [MGBox boxWithSize:CGSizeMake(self.size.width, 30)];
    
    _controller = delegate;

    return self;
}

-(void)renderStreamItem:(MGBox*)boxItem
                  atTop:(BOOL)displayAtTop
{
    // this will change when the items get thrown off the view... this will need to be outside the loop
    if(displayAtTop) {
        [self.boxes insertObject:boxItem atIndex:0];
    }
    else {
        [self.boxes addObject:boxItem];
    }
    [self layout];
}

@end