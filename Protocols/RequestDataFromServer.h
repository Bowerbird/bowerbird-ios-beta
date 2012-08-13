/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au

 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol RequestDataFromServer <NSObject>

@required

@property (retain) ASINetworkQueue *networkQueue;

- (void)doGetRequest:(NSURL *)withUrl;

- (void)requestFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)queueFinished:(ASINetworkQueue *)queue;

@end