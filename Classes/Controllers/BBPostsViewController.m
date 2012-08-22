/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBPostsViewController.h"

@implementation BBPostsViewController

@synthesize activities = _activities;

#pragma mark - Datasource and Data Loading methods

-(void)SetPostActivities:(NSArray*)activities
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.setActivities:");
    
    _activities = activities;
    
    [self.tableView reloadData];
}


#pragma mark - Table View Methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Post Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    BBActivity* activity = [self.activities objectAtIndex:indexPath.row];
    BBImage* activityUserImage = [activity.user.avatar.media objectAtIndex:(activity.user.avatar.media.count - 1)];
    
    cell.textLabel.text = activity.user.firstName;
    cell.detailTextLabel.text = activity.description;
	
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString],activityUserImage.relativeUri]] placeholderImage:[UIImage imageNamed:@"loader.png"]];
    
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
        if([BBConstants Trace])NSLog(@"BBPostsViewController.initWithStyle");
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
