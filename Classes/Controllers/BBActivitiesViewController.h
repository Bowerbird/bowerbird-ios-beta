/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "BBModels.h"
#import "BBProtocols.h"
#import "BBHelpers.h"
#import "UIImageView+WebCache.h"

@interface BBActivitiesViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, BBActivityLoaded>

@property (nonatomic, strong) NSArray* activities;

@end