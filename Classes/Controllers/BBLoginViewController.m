/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBLoginViewController.h"

@interface BBLoginViewController ()

@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;

@end

@implementation BBLoginViewController

@synthesize email = _email;
@synthesize password = _password;


#pragma mark - Wire up UI Actions

-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)userEmailAddress:(UITextField *)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.userEmailAddress:");
    
    self.email = sender.text;
    
    if([BBConstants Trace]) NSLog(@"User entered email: %@", self.email);
}
- (IBAction)userPassword:(UITextField *)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.userPassword:");
    
    self.password = sender.text;
    
    if([BBConstants Trace]) NSLog(@"User entered email: %@", self.password);
}

// when user presses login, make the request to the server
- (IBAction)logUserIn:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.logUserIn:");
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    // to do
}


#pragma mark - Authentication methods and Segues

-(void)segueToLoadActivity
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"LoadActivity" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"LoadActivity"])
    {
        // set up data if req'd
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.shouldAutoRotateToInterfaceOrientation:");
    
    return YES;
}


#pragma mark - Callback methods to this and methods setting this as delegate

// handle delegate response from login to tell of authentication success/failure
-(void)UserAuthenticated:(BBUser*)user
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.UserAuthenticated:");
    
    if(user)
    {
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        
        appData.user = user;
            
        appData.authenticatedUser = [[BBAuthenticatedUser alloc]init];
        
        //[appData.authenticatedUser loadAndNotifyDelegate:self];
    }
    else
    {
        // there was a problem. display a message
    }
}

-(void)authenticatedUserLoaded:(BBAuthenticatedUser *)authenticatedUser
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.AuthenticatedUserLoadedUser");
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    appData.authenticatedUser = authenticatedUser;
    
    [self performSelector:@selector(segueToLoadActivity)withObject:self];
}

@end