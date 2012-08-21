/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBActivitiesViewController.h"

@interface BBActivitiesViewController()

-(void)loadActivity;

@end

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
    
    [self loadActivity];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.viewWillAppear:");
    
    //if([BBConstants Trace]) NSLog(@"ActivitiesViewController created with: %@", [[BBApplicationData sharedInstance] authenticatedUser].user.firstName);
    
    [self.tableView reloadData];
}

-(void)loadActivity
{
    if([BBConstants Trace])NSLog(@"BBLoadingViewController.loadProjects");
    
    NSString* url = [NSString stringWithFormat:@"%@?%@",[BBConstants ActivityUrl], [BBConstants AjaxQuerystring]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
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

#pragma mark - RKObjectLoaderDelegate

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        
        [self performSelector:@selector(segueToActivity)withObject:self afterDelay:1];
    }
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray *)objects
{
    if([BBConstants Trace])NSLog(@"Objects Response: %@", objects);
    
}

-(void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if([BBConstants Trace])NSLog(@"Error Response: %@", [error localizedDescription]);
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader
{
    if([BBConstants Trace])NSLog(@"Unexpected Response: %@", objectLoader.response.bodyAsString);
}



@end