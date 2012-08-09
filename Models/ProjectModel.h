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
#import "AvatarImageLoadCompleteDelegate.h"
#import "ProjectLoadCompleteDelegate.h"
#import "BowerBirdConstants.h"

@interface ProjectModel : GroupModel <RequestDataFromServer, AvatarImageLoadCompleteDelegate>

@property (retain) ASINetworkQueue *networkQueue;

+(NSArray *)loadProjectsFromResponseString:(NSString *)responseString;

-(id)initWithJsonBlob:(NSDictionary *)jsonBlob;

-(void)loadProjectsCallingBackToDelegate:(id)delegate;

@end
