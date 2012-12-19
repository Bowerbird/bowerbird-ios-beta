//
//  BBClassificationSearchController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 4/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBUIControlHelper.h"
#import "BBRankDelegateProtocol.h"
#import "BBRankSearcher.h"
#import "BBModels.h"
#import "SVProgressHUD.h"

@interface BBClassificationSearchController : BBControllerBase<
     RKObjectLoaderDelegate
    ,BBRankDelegateProtocol
>

@end