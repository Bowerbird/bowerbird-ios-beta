/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize authenticatedUser = _authenticatedUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([BowerBirdConstants Trace]) NSLog(@"HomeViewController.initWithNibName:bundle:");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([BowerBirdConstants Trace]) NSLog(@"HomeViewController.viewWillAppear:");
        
    //self.authenticatedUser = [[AuthenticatedUser alloc]init];
    
    //[self.authenticatedUser loadAndNotifyDelegate:self];
    NSLog(@"HomeViewController created with: %@", self.authenticatedUser.user.firstName);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BowerBirdConstants Trace]) NSLog(@"HomeViewController.shouldAutorotateToInterfaceOrientation:");
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)authenticatedUserLoaded:(AuthenticatedUser *)authenticatedUser
{
    if([BowerBirdConstants Trace]) NSLog(@"HomeViewController.AuthenticatedUserLoaded:");
    
    self.authenticatedUser = authenticatedUser;

    // this is where we can re-render the view if required with newly updated model.
    // most likely, we will update the models in the view's components.
}

@end
