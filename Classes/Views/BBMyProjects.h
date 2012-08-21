/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@class BBMyProjects;

@protocol ProjectTableDataSource

-(NSArray *)projectsForProjectTable:(BBMyProjects*)sender;

@end

@interface BBMyProjects : UITableView

@end
