//
//  RequestDataFromServer.h
//  BowerBird
//
//  Created by Hamish Crittenden on 7/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol RequestDataFromServer <NSObject>

@required

@property (retain) ASINetworkQueue *networkQueue;

- (void)doGetRequest:(NSString *)withUrl;

- (void)requestFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)queueFinished:(ASINetworkQueue *)queue;

@end