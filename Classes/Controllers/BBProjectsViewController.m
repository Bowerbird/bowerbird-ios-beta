/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBProjectsViewController.h"

@implementation BBProjectsViewController

@synthesize projects = _projects;

#pragma mark - Set up dataSource and delegate

-(void)setProjects:(NSArray *)projects
{
    if([BBConstants Trace]) NSLog(@"ProjectTableViewController.setProjects");
    
    _projects = projects;
    
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BBConstants Trace]) NSLog(@"ProjectsViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Projects";
        self.title = @"Projects";
    }
    return self;
}

#pragma mark - Authentication methods and Segues

-(void)segueToBrowseProjects
{
    if([BBConstants Trace]) NSLog(@"ProjectsViewController.segueToBrowse");
    
    [self performSegueWithIdentifier:@"BrowseProjects" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BBConstants Trace]) NSLog(@"ProjectsViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"BrowseProjects"])
    {
        // set up data if req'd
    }
}

- (void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"ProjectsViewController.viewDidLoad");
    
    [super viewDidLoad];
        
    UIBarButtonItem *browseProjectsButton = [[UIBarButtonItem alloc] initWithTitle:@"Browse All"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(segueToBrowseProjects)];
    self.navigationItem.title = @"My Projects";
    self.navigationItem.rightBarButtonItem = browseProjectsButton;
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    self.projects = [appData.authenticatedUser.projects allValues];
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