/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

/// set this puppy up to hit the Account/Activity URL for a download of latest activity


#import "ActivityViewController.h"

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BowerBirdConstants Trace]) NSLog(@"ActivityViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Activity";
    }
    return self;
}

-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([BowerBirdConstants Trace]) NSLog(@"ActivityViewController.viewWillAppear:");
    
    NSLog(@"ActivityViewController created with: %@", [[ApplicationData sharedInstance] authenticatedUser].user.firstName);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BowerBirdConstants Trace]) NSLog(@"ActivityViewController.shouldAutorotateToInterfaceOrientation:");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
