//
//  Project.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

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

+(ProjectModel *)buildFromJson:(NSDictionary *)properties;

-(void)loadProjectsCallingBackToDelegate:(id)delegate;

@end
