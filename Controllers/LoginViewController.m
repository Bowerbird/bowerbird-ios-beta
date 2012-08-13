/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) User* authenticatedUser;
@property (nonatomic, strong) Authentication* authentication;

@end

@implementation LoginViewController

@synthesize email = _email;
@synthesize password = _password;
@synthesize authenticatedUser = _authenticatedUser;
@synthesize authentication = _authentication;


#pragma mark - Wire up UI Actions

- (IBAction)userEmailAddress:(UITextField *)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.userEmailAddress:");
    
    self.email = sender.text;
    NSLog(@"User entered email: %@", self.email);
}
- (IBAction)userPassword:(UITextField *)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.userPassword:");
    
    self.password = sender.text;
    NSLog(@"User entered email: %@", self.password);
}

// when user presses login, make the request to the server
- (IBAction)logUserIn:(id)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.logUserIn:");
    
    self.authentication = [[Authentication alloc]initWithCallbackDelegate:(self)];
    
    [self.authentication doPostRequest:[BowerBirdConstants AccountLoginUrl] withParameters:[NSDictionary dictionaryWithObjectsAndKeys:self.email, @"email", self.password, @"password", nil]];
}


#pragma mark - Authentication methods and Segues

-(void)segueToHome
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"Home"])
    {
        // set up data if req'd
    }
}

// if we return with a user object, set current user
-(void)setCurrentUser:(User *)currentUser
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.setCurrentUser:");
    
    self.currentUser = currentUser;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.shouldAutoRotateToInterfaceOrientation:");
    
    return YES;
}



#pragma mark - Callback methods to this and methods setting this as delegate

// handle delegate response from login to tell of authentication success/failure
-(void)UserAuthenticated:(User*)user
{
    if([BowerBirdConstants Trace]) NSLog(@"LoginViewController.UserAuthenticated:");
    
    if(user)
    {
        self.authenticatedUser = user;
        
        [self performSelector:@selector(segueToHome)withObject:self];
    }
    else
    {
        // there was a problem. display a message
    }
}

@end