//
//  BBIdentifySightingView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBIdentifySightingProtocol.h"
#import "BBUIControlHelper.h"
#import "MGHelpers.h"
#import "BBClassification.h"

@interface BBIdentifySightingView : MGScrollView

@property (nonatomic,weak) id<BBIdentifySightingProtocol> controller;

-(BBIdentifySightingView*)initWithDelegate:(id<BBIdentifySightingProtocol>)delegate
                                     andSize:(CGSize)size;

-(void)displayIdentification:(BBClassification*)classification;

@end