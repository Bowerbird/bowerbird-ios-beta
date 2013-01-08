//
//  BBStreamView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "MGScrollView.h"
#import "BBStreamProtocol.h"
#import "MGHelpers.h"

@interface BBStreamView : MGScrollView

@property (nonatomic,strong) UIView *tableFooterView;

-(BBStreamView*)initWithDelegate:(id<BBStreamProtocol>)delegate andSize:(CGSize)size;

-(void)renderStreamItem:(MGBox*)boxItem
                  atTop:(BOOL)displayAtTop;

@end