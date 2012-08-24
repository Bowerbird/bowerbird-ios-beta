/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBChatViewController.h"

@implementation BBChatViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    if([BBConstants Trace]) NSLog(@"BBChatViewController.viewDidLoad:");
    
    BBUserChatViewController *userChatViewController = [[BBUserChatViewController alloc] initWithStyle:UITableViewStylePlain];
    BBGroupChatViewController *groupChatViewController = [[BBGroupChatViewController alloc] initWithStyle:UITableViewStylePlain];

    
    userChatViewController.title = @"Users Online";
    groupChatViewController.title = @"Group Chats";
    
    self.delegate = self;
    self.viewControllers = [NSArray arrayWithObjects:userChatViewController, groupChatViewController, nil];
    self.selectedIndex = 0;
    
	[super viewDidLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BBConstants Trace]) NSLog(@"BBChatViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}


- (BOOL)segmentPageController:(JCMSegmentPageController *)segmentPageController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if([BBConstants Trace]) NSLog(@"BBChatViewController.segmentedPageController:shouldSelectViewController:atIndex:");
    
	if([BBConstants Trace]) NSLog(@"segmentPageController %@ shouldSelectViewController %@ at index %u", segmentPageController, viewController, index);
    
	return YES;
}

- (void)segmentPageController:(JCMSegmentPageController *)segmentPageController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if([BBConstants Trace]) NSLog(@"BBChatViewController.segmentedPageController:didSelectViewController:atIndex:");
    
	if([BBConstants Trace]) NSLog(@"segmentPageController %@ didSelectViewController %@ at index %u", segmentPageController, viewController, index);
}

@end
