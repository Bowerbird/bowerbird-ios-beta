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

// add another constructor to use this controller as a builder for custom identifications....
-(BBClassificationBrowseController*)initWithClassification:(BBClassificationSelector*)classification
                                                  asCustom:(BOOL)custom;

@end