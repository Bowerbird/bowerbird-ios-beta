/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "PostDataToServer.h"
#import "UserLoadCompleteDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BowerBirdConstants.h"
#import "UserModel.h"
#import "SBJSON.h"

@interface AuthenticationModel : NSObject <PostDataToServer, UserLoadCompleteDelegate>

@property (retain) ASINetworkQueue *networkQueue;

//- (void)doPostRequest:(NSString *)toUrl withParameters:(NSDictionary *) params;
//
//- (void)requestFinished:(ASIFormDataRequest *)request;
//
//- (void)requestFailed:(ASIFormDataRequest *)request;
//
//- (void)queueFinished:(ASIFormDataRequest *)queue;

@end
