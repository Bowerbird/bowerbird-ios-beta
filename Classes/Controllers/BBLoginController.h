//
//  BBLoginController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBLoginView.h"
#import "BBAuthenticatedUser.h"
#import "BBAppDelegate.h"
#import "BBUIControlHelper.h"
#import "BBStyles.h"

@interface BBLoginController : BBControllerBase <
     UITextFieldDelegate
    ,RKObjectLoaderDelegate
>

@end