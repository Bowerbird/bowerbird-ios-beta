/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBProjectsViewController.h"

@implementation BBProjectsViewController

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
}

@end