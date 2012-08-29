/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBActivitiesViewController.h"

@implementation BBActivitiesViewController

@synthesize activities = _activities;


#pragma mark - Datasource and Data Loading methods

-(void)setActivities:(NSArray *)activities
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.setActivities:");
    
    _activities = activities;
    
    [self.tableView reloadData];
}

-(void)loadActivities
{
    if([BBConstants Trace])NSLog(@"BBLoadingViewController.loadProjects");
    
    NSString* url = [NSString stringWithFormat:@"%@?%@",[BBConstants ActivityUrl], [BBConstants AjaxQuerystring]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBActivityPaginator class]])
    {
        self.activities = ((BBActivityPaginator*)object).activities;
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


- (void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.viewDidLoad:");
    
    [self loadActivities];
    
	[super viewDidLoad];
}

#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Activity Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    BBActivity* activity = [self.activities objectAtIndex:indexPath.row];
    BBImage* activityUserImage = [activity.user.avatar.imageMedia objectAtIndex:(activity.user.avatar.imageMedia.count - 1)];
    
    cell.textLabel.text = activity.user.firstName;
    cell.detailTextLabel.text = activity.description;
	
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString],activityUserImage.uri]] placeholderImage:[UIImage imageNamed:@"loader.png"]];
    
    if([BBConstants Trace])NSLog(@"text: %@ detail: %@", activity.user.firstName, activity.description);
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.activities.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@, parent is %@", self.title, self.parentViewController);
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	// do something....
}


#pragma mark - View Rendering Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if([BBConstants Trace])NSLog(@"BBActivitiesViewController.initWithStyle");
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.shouldAutorotateToInterfaceOrientation:");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end