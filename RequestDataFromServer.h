//
//  RequestDataFromServer.h
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "LoginView.h"
#import "ASIHTTPRequest.h"
#import "BowerBirdConstants.h"
#import "SBJSON.h"
#import "ASINetworkQueue.h"
#import "CookieCutter.h"

@protocol RequestDataFromServer <NSObject>

@required

@property (retain) ASINetworkQueue *networkQueue;

- (void)doGetRequest:(NSString *)withUrl;

- (void)requestFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)queueFinished:(ASINetworkQueue *)queue;

@end