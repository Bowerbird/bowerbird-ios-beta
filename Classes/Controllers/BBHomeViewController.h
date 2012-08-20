/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "BBModels.h"
#import "BBProtocols.h"
#import "JCMSegmentPageController.h"
#import "BBPostsViewController.h"
#import "BBActivitiesViewController.h"
#import "BBObservationsViewController.h"

@interface BBHomeViewController : JCMSegmentPageController <JCMSegmentPageControllerDelegate>

@property (nonatomic, strong) NSDictionary* activities;

@property (nonatomic,strong) BBActivity* activity;

@end