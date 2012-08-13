/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ProjectLoaded.h"
#import "BowerBirdConstants.h"
#import "ProjectsView.h"

@interface ProjectTableViewController : UITableViewController <ProjectLoaded, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* projects;

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section;

@end 