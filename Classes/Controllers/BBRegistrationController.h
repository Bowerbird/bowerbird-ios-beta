//
//  BBRegistrationController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBUIControlHelper.h"
#import "BBStyles.h"
#import "BSKeyboardControls.h"

@interface BBRegistrationController : BBControllerBase <
     UITextFieldDelegate
    ,RKObjectLoaderDelegate
    ,BSKeyboardControlsDelegate
>

@end