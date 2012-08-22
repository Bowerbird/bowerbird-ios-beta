/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBHomeViewController.h"

@implementation BBHomeViewController

@synthesize activities = _activities;

#pragma mark - Datasource and Data Loading methods

-(void)setActivities:(NSArray *)activities
{
    if([BBConstants Trace]) NSLog(@"BBActivitiesViewController.setActivities:");
    
    _activities = activities;
    
    for(id viewController in self.viewControllers)
    {
        if([viewController respondsToSelector:@selector(SetActivities:)])
        {
            [viewController SetActivities:activities];
        }
        if([viewController respondsToSelector:@selector(SetObservationActivities:)])
        {
            [viewController SetObservationActivities:activities];
        }
        if([viewController respondsToSelector:@selector(SetPostActivities:)])
        {
            [viewController setActivities:activities];
        }
    }
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
    if([BBConstants Trace]) NSLog(@"HomeViewController.viewDidLoad:");
        
    BBActivitiesViewController *activitiesViewController = [[BBActivitiesViewController alloc] initWithStyle:UITableViewStylePlain];
    BBObservationsViewController *observationsViewController = [[BBObservationsViewController alloc] initWithStyle:UITableViewStylePlain];
    BBPostsViewController *postsViewController = [[BBPostsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    activitiesViewController.title = @"All Activity";
    observationsViewController.title = @"Observations";
    postsViewController.title = @"Posts";
    
    [self loadActivities];
    
    self.delegate = self;
    self.viewControllers = [NSArray arrayWithObjects:activitiesViewController, observationsViewController, postsViewController, nil];
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