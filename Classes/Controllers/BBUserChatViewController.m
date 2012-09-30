/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBUserChatViewController.h"

@interface BBUserChatViewController ()

-(void)handleUserStatusChanged;

@end

@implementation BBUserChatViewController

@synthesize onlineUsers = _onlineUsers;

#pragma mark - Datasource and Data Loading methods

-(void)setOnlineUsers:(NSMutableArray *)onlineUsers
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.setActivities:");
    
    _onlineUsers = onlineUsers;
    
    [self.tableView reloadData];
}

-(void)handleUserStatusChanged
{
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    BBUserHubClient* userHub = [BBUserHubClient sharedInstance];
    
    self.onlineUsers = userHub.onlineUsers;
    
    // http://www.idev101.com/code/Cocoa/Notifications.html
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserStatusChanged)
                                                 name:@"userStatusChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserStatusChanged)
                                                 name:@"userAdded"
                                               object:nil];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.onlineUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Activity Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    BBUser* user = [self.onlineUsers objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)", [BBEnumHelper onlineStatus:user.userStatus]];
	
    //[cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString],activityUserImage.relativeUri]] placeholderImage:[UIImage imageNamed:@"loader.png"]];
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
