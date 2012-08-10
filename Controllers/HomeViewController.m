/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) AuthenticatedUserModel* authenticatedUserModel;
@end

@implementation HomeViewController

@synthesize authenticatedUserModel = _authenticatedUserModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // load the authenticatedUser:
    self.authenticatedUserModel = [[AuthenticatedUserModel alloc]init];
    
    [self.authenticatedUserModel loadAndNotifyDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)AuthenticatedUserLoaded:(AuthenticatedUserModel *)authenticatedUser
{
    self.authenticatedUserModel = authenticatedUser;
    
    NSLog(@"AuthenticationUserModel has been loaded");
    // do some rendering
}

@end
