//
//  BBProjectSelectView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLog.h"
#import "BBProjectSelectDelegateProtocol.h"
#import "BBProjectSelectView.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"

@interface BBProjectSelectView   : MGScrollView

@property (nonatomic,retain) id<BBProjectSelectDelegateProtocol> controller;
@property (nonatomic,strong) MGTableBoxStyled *projectTable;

-(id)initWithDelegate:(id<BBProjectSelectDelegateProtocol>)delegate;

@end