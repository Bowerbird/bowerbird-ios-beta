//
//  BBClassificationController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 3/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBUIControlHelper.h"
#import "BBRankDelegateProtocol.h"
#import "BBRankBrowser.h"

@interface BBClassificationBrowseController : BBControllerBase <
     RKObjectLoaderDelegate
    ,BBRankDelegateProtocol
> 

-(BBClassificationBrowseController*)initWithClassification:(BBClassificationSelector*)classification;

@end