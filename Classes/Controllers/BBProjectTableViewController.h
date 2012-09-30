/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "BBModels.h"
#import "UIImageView+WebCache.h"

@interface BBProjectTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>

@property (nonatomic, strong) NSMutableArray* projects;

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section;

@end 