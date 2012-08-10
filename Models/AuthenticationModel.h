/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "PostDataToServer.h"
#import "UserLoaded.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BowerBirdConstants.h"
#import "UserModel.h"
#import "SBJSON.h"
#import "AuthenticationComplete.h"

@interface AuthenticationModel : NSObject <PostDataToServer, UserLoaded>

@property (retain) ASINetworkQueue *networkQueue;

- (id)initWithCallbackDelegate:(id)delegate;

- (void)doPostRequest:(NSURL *)toUrl withParameters:(NSDictionary *) params;

@end
