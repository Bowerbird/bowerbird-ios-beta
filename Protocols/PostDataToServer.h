/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for specifying required API for a class posting it's data to the server
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "LoginView.h"
#import "ASIFormDataRequest.h"
#import "BowerBirdConstants.h"
#import "SBJSON.h"
#import "ASINetworkQueue.h"
#import "CookieHelper.h"

@protocol PostDataToServer <NSObject>

@required

@property (retain) ASINetworkQueue *networkQueue;

- (void)doPostRequest:(NSURL *)toUrl withParameters:(NSDictionary *) params;

- (void)requestFinished:(ASIFormDataRequest *)request;

- (void)requestFailed:(ASIFormDataRequest *)request;

- (void)queueFinished:(ASIFormDataRequest *)queue;

@end