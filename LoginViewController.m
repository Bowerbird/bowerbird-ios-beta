/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "LoginViewController.h"
#import "UserModel.h"
#import "AuthenticationModel.h"

@interface LoginViewController ()
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) UserModel* authenticatedUser;
@property (nonatomic, strong) AuthenticationModel* authenticationModel;
@end

@implementation LoginViewController

@synthesize email = _email;
@synthesize password = _password;
@synthesize authenticatedUser = _authenticatedUser;
@synthesize authenticationModel = _authenticationModel;

// Wire up the email and password text boxes to update properties
- (IBAction)userEmailAddress:(UITextField *)sender {
    self.email = sender.text;
    NSLog(@"User entered email: %@", self.email);
}
- (IBAction)userPassword:(UITextField *)sender {
    self.password = sender.text;
    NSLog(@"User entered email: %@", self.password);
}

// when user presses login, make the request to the server
- (IBAction)logUserIn:(id)sender
{
    NSURL *url = [NSURL URLWithString:[[BowerBirdConstants RootUri] stringByAppendingFormat:@"/%@/%@", @"account", @"login"]];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:self.email, @"email", self.password, @"password", nil];
    
    self.authenticationModel = [[AuthenticationModel alloc]init];
}


// if we return with a user object, set current user
-(void)setCurrentUser:(UserModel *)currentUser
{
    self.currentUser = currentUser;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



#pragma mark - Callback methods to this and methods setting this as delegate

// handle delegate response from login to tell of authentication success/failure


@end
