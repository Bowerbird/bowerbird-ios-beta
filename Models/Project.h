/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "Group.h"
#import "Project.h"
#import "RequestDataFromServer.h"
#import "ImageLoaded.h"
#import "ProjectLoaded.h"
#import "BowerBirdConstants.h"

@interface Project : Group <RequestDataFromServer, ImageLoaded>

@property (retain) ASINetworkQueue *networkQueue;

-(id)initWithJson:(NSDictionary *)dictionary andNotifyDelegate:(id)delegate;

-(void)loadAllProjectsAndNotifyDelegate:(id)delegate;

-(void)loadTheseProjects:(NSArray*)projects andNotifyDelegate:(id)delegate;

-(NSDictionary *)loadProjectsFromJson:(NSArray *)array;

@property (nonatomic, strong) NSDictionary* projects;

@end
