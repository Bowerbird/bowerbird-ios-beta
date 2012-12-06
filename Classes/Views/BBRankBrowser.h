//
//  BBRankBrowser.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 5/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBStyles.h"
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "BBModels.h"
#import "BBRankDelegateProtocol.h"
#import "BBUIControlHelper.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface BBRankBrowser : MGScrollView <
    BBRankDelegateProtocol
>

-(BBRankBrowser*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate;

-(void)displayRanks:(NSArray*)ranks;

-(void)displayRankLoader;

@end