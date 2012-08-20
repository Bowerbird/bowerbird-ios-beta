/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBProjectTableViewController.h"

@implementation BBProjectTableViewController

@synthesize projects = _projects;

#pragma mark - Set up dataSource and delegate

-(void)setProjects:(NSArray *)projects
{
    if([BBConstants Trace]) NSLog(@"ProjectTableViewController.setProjects");
    
    _projects = projects;
    
    [self.tableView reloadData];
}

#pragma mark - View Rendering Methods
 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if([BBConstants Trace])NSLog(@"ProjectTableViewController.initWithStyle");
        
        [self loadProjects];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadProjects];
}

-(void)loadProjects
{
    if([BBConstants Trace])NSLog(@"ProjectTableViewController.loadProjects");
    
    NSString* projectsUrl = [NSString stringWithFormat:@"%@/Projects?X-Requested-With=XMLHttpRequest",[BBConstants RootUri]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:projectsUrl delegate:self];
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBProjectPaginator class]])
    {
        self.projects = ((BBProjectPaginator*)object).projects;
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

- (void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader
{
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary
{

}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader
{
    if([BBConstants Trace])NSLog(@"Unexpected Response: %@", objectLoader.response.bodyAsString);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Rendering Methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Project Detail";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    BBProject* project = [self.projects objectAtIndex:indexPath.row];
    //BBImage* projectImage = [project.avatar.media objectForKey:[BBConstants NameOfAvatarDisplayImage]];
    
    // this is a hack because it's a BBImage but should be a dictionary as above...

    BBImage* projectImage = (BBImage*)project.avatar.media;
    
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.description;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString],projectImage.relativeUri]] placeholderImage:[UIImage imageNamed:@"loader.png"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.projects count];
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end