/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBSightingsViewController.h"

@implementation BBSightingsViewController

@synthesize sightings = _sightings;


#pragma mark - Datasource and Data Loading methods

-(void)setSightings:(NSArray *)sightings
{
    if([BBConstants Trace]) NSLog(@"BBObservationsViewController.setObservations:");
    
    _sightings = sightings;
    
    [self.tableView reloadData];
}

-(void)loadSightings
{
    if([BBConstants Trace])NSLog(@"BBObservationsViewController.loadObservations");
    
    NSString* url = [NSString stringWithFormat:@"%@?%@",[BBConstants sightingsUrl], [BBConstants AjaxQuerystring]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBSightingPaginator class]])
    {
        self.sightings = ((BBSightingPaginator*)object).sightings;
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


#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Observation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    BBSighting* sighting = [self.sightings objectAtIndex:indexPath.row];
    
    cell.textLabel.text = sighting.user.firstName;
    cell.detailTextLabel.text = sighting.description;
	
    // need to drill down to new property for the uri of the primary media.
    //[cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString], [[observation.primaryMedia.media objectAtIndex:0] url??]]] placeholderImage:[UIImage imageNamed:@"loader.png"]];

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.sightings.count;
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
        if([BBConstants Trace])NSLog(@"BBObservationsViewController.initWithStyle");
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
