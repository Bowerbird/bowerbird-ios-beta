//
//  LoginViewController.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 30/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationCompleteDelegate.h"
#import "UserModel.h"
#import "LoginView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "BowerBirdConstants.h"
#import "SBJSON.h"
#import "ASINetworkQueue.h"
#import "CookieCutter.h"

#define EMAIL "email";
#define PASSWORD "password";

@interface LoginViewController : UIViewController <AuthenticationCompleteDelegate>

@end
