//
//  BBDisplayFullImage.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 18/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBImage.h"
#import "MGHelpers.h"
#import "SVProgressHUD.h"

@interface BBDisplayFullImageController : BBControllerBase <
     UIGestureRecognizerDelegate
    ,UIScrollViewDelegate
>

-(id)initWithImage:(BBImage*)image;

@end