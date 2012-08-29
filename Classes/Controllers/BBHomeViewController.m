/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBHomeViewController.h"

@implementation BBHomeViewController

#pragma mark - Datasource and Data Loading methods

- (void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.viewDidLoad:");
        
    BBActivitiesViewController *activitiesViewController = [[BBActivitiesViewController alloc] initWithStyle:UITableViewStylePlain];
    BBSightingsViewController *sightingsViewController = [[BBSightingsViewController alloc] initWithStyle:UITableViewStylePlain];
    BBPostsViewController *postsViewController = [[BBPostsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    activitiesViewController.title = @"All Activity";
    sightingsViewController.title = @"Sightings";
    postsViewController.title = @"Posts";

    self.delegate = self;
    self.viewControllers = [NSArray arrayWithObjects:activitiesViewController, sightingsViewController, postsViewController, nil];
    self.selectedIndex = 0;
    
	[super viewDidLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}


- (BOOL)segmentPageController:(JCMSegmentPageController *)segmentPageController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.segmentedPageController:shouldSelectViewController:atIndex:");
    
	if([BBConstants Trace]) NSLog(@"segmentPageController %@ shouldSelectViewController %@ at index %u", segmentPageController, viewController, index);

	return YES;
}

- (void)segmentPageController:(JCMSegmentPageController *)segmentPageController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.segmentedPageController:didSelectViewController:atIndex:");
    
	if([BBConstants Trace]) NSLog(@"segmentPageController %@ didSelectViewController %@ at index %u", segmentPageController, viewController, index);
}

@end