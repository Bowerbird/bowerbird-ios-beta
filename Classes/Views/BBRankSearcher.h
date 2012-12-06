//
//  BBRankSearcher.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 6/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBStyles.h"
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "BBModels.h"
#import "BBRankDelegateProtocol.h"
#import "BBUIControlHelper.h"
#import "NMCustomLabel.h"
#import "NMCustomLabelStyle.h"

@interface BBRankSearcher  : MGScrollView <
     BBRankDelegateProtocol
    ,UITextFieldDelegate
>

@property (nonatomic,strong) UITextField *titleTextField;

-(BBRankSearcher*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate;

-(void)displayRanks:(NSArray*)ranks forQuery:(NSString*)query;

@end
