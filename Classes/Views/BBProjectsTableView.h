/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@class BBProjectsTableView;

@protocol ProjectTableDataSource

-(NSDictionary *)projectsForProjectTable:(BBProjectsTableView*)sender;

@end

@interface BBProjectsTableView : UITableView

//@property (nonatomic, weak) id<ProjectTableDataSource> projects;

@end
