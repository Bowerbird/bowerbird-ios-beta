/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBActivitiesViewController.h"

@implementation BBActivitiesViewController

@synthesize activities = _activities;

-(void)setActivities:(NSDictionary *)activities
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.setActivities:");
    _activities = activities;
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization      
    }
    return self;
}

-(void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.viewDidLoad");

    [super viewDidLoad];
    //self.tableView = [[UITableView alloc]init];
    
    //__block id delegate = self;
    //[self.tableView addPullToRefreshWithActionHandler:^{
    //    NSLog(@"refresh dataSource");
    //    [self.activity loadActivitiesForUrl:[BowerBirdConstants ActivityUrl] andNotifyDelegate:delegate];
    //    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    //}];
    
    //[self.tableView addInfiniteScrollingWithActionHandler:^{
    //    NSLog(@"load more data");
        // this would be querying the load activities url and passing the next page number and page size..
    //}];
    
    // trigger the refresh manually at the end of viewDidLoad
    //[self.tableView.pullToRefreshView triggerRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.viewWillAppear:");
    
    //if([BBConstants Trace]) NSLog(@"ActivitiesViewController created with: %@", [[BBApplicationData sharedInstance] authenticatedUser].user.firstName);
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.shouldAutorotateToInterfaceOrientation:");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.tableView:cellForRowAtIndexPath:");
    
	static NSString *CellIdentifier = @"Activity Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray* arrayOfActivity = [[NSArray alloc] initWithArray:[self.activities allValues]];
    BBActivity* activity = [arrayOfActivity objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = activity.description;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.tableView:didSelectRowAtIndexPath:");
    
	if([BBConstants Trace]) NSLog(@"%@, parent is %@", self.title, self.parentViewController);
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	//self.view = [[ActivityTableView alloc]init];
    [self viewDidLoad];
}

- (IBAction)dismissModalScreen:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end