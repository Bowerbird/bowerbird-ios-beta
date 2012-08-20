/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBHomeViewController.h"

@interface BBHomeViewController()

@end

@implementation BBHomeViewController

@synthesize activity = _activity;
@synthesize activities = _activities;

-(void)setActivities:(NSDictionary *)activities
{
    if([BBConstants Trace]) NSLog(@"ActivitiesViewController.setActivities:");
        _activities = activities;
}

- (void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.viewDidLoad:");
        
    BBActivitiesViewController *activitiesViewController = [[BBActivitiesViewController alloc] initWithStyle:UITableViewStylePlain];
//    ActivitiesViewController *activitiesViewController = [[ActivitiesViewController alloc] init];
    BBObservationsViewController *observationsViewController = [[BBObservationsViewController alloc] initWithStyle:UITableViewStylePlain];
    BBPostsViewController *postsViewController = [[BBPostsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    activitiesViewController.title = @"All Activity";
    observationsViewController.title = @"Observations";
    postsViewController.title = @"Posts";
    
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
        self.activity = [[BBActivity alloc]init];
        //[self.activity loadActivitiesForUrl:[BBConstants ActivityUrl] andNotifyDelegate:self];
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


-(void)ActivityHasFinishedLoading:(BBActivity*)activity
{
    if([BBConstants Trace]) NSLog(@"HomeViewController.ActivityHasFinishedLoading:");
    
    NSMutableDictionary* activities = [[NSMutableDictionary alloc]initWithDictionary:self.activities];
    
    [activities setObject:activity forKey:activity.identifier];
    
    self.activities = [[NSDictionary alloc]initWithDictionary:activities];
    
    BBActivitiesViewController* activitiesViewController = [self.viewControllers objectAtIndex:0];
    activitiesViewController.activities = self.activities;
}

@end