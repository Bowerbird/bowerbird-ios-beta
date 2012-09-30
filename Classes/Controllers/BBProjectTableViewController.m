/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBProjectTableViewController.h"

@implementation BBProjectTableViewController

@synthesize projects = _projects;

#pragma mark - Datasource and Data Loading methods

-(void)setProjects:(NSMutableArray *)projects
{
    if([BBConstants Trace]) NSLog(@"BBProjectTableViewController.setProjects");
    
    _projects = projects;
    
    [self.tableView reloadData];
}
 
-(void)loadProjects
{
    if([BBConstants Trace])NSLog(@"ProjectTableViewController.loadProjects");
    
    NSString* url = [NSString stringWithFormat:@"%@?%@",[BBConstants ProjectsUrl], [BBConstants AjaxQuerystring]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBProjectPaginator class]])
    {
        self.projects = [NSMutableArray arrayWithArray:((BBProjectPaginator*)object).projects];
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
    static NSString *CellIdentifier = @"Project Detail";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BBProject* project = [self.projects objectAtIndex:indexPath.row];
    BBImage* projectImage = [project.avatar.imageMedia objectAtIndex:(project.avatar.imageMedia.count - 1)];
    
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.description;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [BBConstants RootUriString],projectImage.uri]] placeholderImage:[UIImage imageNamed:@"loader.png"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projects count];
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - View Rendering Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if([BBConstants Trace])NSLog(@"BBProjectTableViewController.initWithStyle");
        
        [self loadProjects];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadProjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"BBProjectTableViewController.shouldAutorotateToInterfaceOrientation:");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end