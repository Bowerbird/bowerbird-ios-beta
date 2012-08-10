/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "GroupModel.h"
#import "ProjectModel.h"
#import "RequestDataFromServer.h"
#import "AvatarImageLoaded.h"
#import "ProjectLoaded.h"
#import "BowerBirdConstants.h"

@interface ProjectModel : GroupModel <RequestDataFromServer, AvatarImageLoaded>

@property (retain) ASINetworkQueue *networkQueue;

-(id)initWithJson:(NSDictionary *)dictionary;

-(NSDictionary *)loadProjectsFromResponseString:(NSString *)responseString;

-(void)loadAndNotifyDelegate:(id)delegate;

@end
