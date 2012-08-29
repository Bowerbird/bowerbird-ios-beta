/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBSettingsViewController.h"

@interface BBSettingsViewController ()

-(void)segueToLogout;

@end

@implementation BBSettingsViewController

// remove cookie
// logout user remotely
// delete application data
- (IBAction)logMeOut:(id)sender
{
    [BBCookieHelper deleteCookies];
    //segue to login screen.
    //BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    [self segueToLogout];
}


-(void)segueToLogout
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"Logout"])
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end