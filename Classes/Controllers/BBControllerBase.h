//
//  BBControllerBase.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHelpers.h"
#import "MGHelpers.h"
#import "BBAppDelegate.h"

@interface BBControllerBase : UIViewController

@property (nonatomic,strong) BBAppDelegate *app;

-(BBImage*)getImageWithDimension:(NSString*)dimensionName fromArrayOf:(NSArray*)images;

-(BBProject*)getProjectWithIdentifier:(NSString*)identifier fromArrayOf:(NSArray*)projects;

@end