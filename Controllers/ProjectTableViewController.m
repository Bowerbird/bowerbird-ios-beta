/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "ProjectTableViewController.h"

@interface ProjectTableViewController ()
@property (nonatomic, strong) Project* project;
@end

@implementation ProjectTableViewController

@synthesize projects = _projects;
@synthesize project = _project;

#pragma mark - Set up dataSource and delegate

-(void)setProjects:(NSArray *)projects
{
    _projects = projects;
    [self.tableView reloadData];
}

#pragma mark - Rendering Methods
 
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
    [super viewDidLoad];  
    self.project = [[Project alloc]init];
    [self.project loadAllProjectsAndNotifyDelegate:(self)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Project Detail";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Project* project = [self.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.description;
    cell.imageView.image = project.avatar.image;
    
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


#pragma mark - Delegate and Callback Methods

// delegate method, called on completion of project loading by ProjectModel
-(void)ProjectHasFinishedLoading:(Project *)project
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.projects];
    
    [array addObject:project];
    
    self.projects = [NSArray arrayWithArray:array];
}


@end