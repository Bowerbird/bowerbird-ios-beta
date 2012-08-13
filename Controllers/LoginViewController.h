//
//  LoginViewController.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 30/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationComplete.h"
#import "User.h"
#import "LoginView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "BowerBirdConstants.h"
#import "SBJSON.h"
#import "ASINetworkQueue.h"
#import "CookieHelper.h"
#import "Authentication.h"

#define EMAIL @"email";
#define PASSWORD @"password";

@interface LoginViewController : UIViewController <AuthenticationComplete>

@end
