/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBLoadingViewController.h"
#import <UIKit/UIKit.h>

@interface BBLoadingViewController ()

-(BOOL)applicationRequiresLoginOrRegistration;
-(void)segueToLogin;
-(void)segueToActivity;
-(void)loadAuthenticatedUser;
@property (nonatomic, strong) UIActivityIndicatorView* aSpinner;

@end

@implementation BBLoadingViewController

@synthesize aSpinner = _aSpinner;

#pragma mark - Initialize the Application and Segue

-(BOOL)applicationRequiresLoginOrRegistration
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.applicationRequiresLoginOrRegistration");
    
    NSHTTPCookie* cookie = [BBCookieHelper grabCookieForUrl:[BBConstants RootUri] withName:[BBConstants CookieName]];
    
    return cookie == nil;
}

-(void)segueToLogin
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.segueToLogin");
    
    [self performSegueWithIdentifier:@"Login" sender:self];
}

-(void)segueToActivity
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"LoadActivity" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"Login"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"LoadActivity"])
    {
        
    }
}


#pragma mark - View Display logic

-(void) displaySpinner
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.displaySpinner");
    
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    self.aSpinner = tempSpinner;
    
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

- (void) viewDidAppear:(BOOL) animated
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.viewDidAppear:");
    
    [self displaySpinner];
       
    if([self applicationRequiresLoginOrRegistration])
    {
        [self performSelector:@selector(segueToLogin)withObject:self afterDelay:1];
    }
    else if([[BBApplicationData sharedInstance] authenticatedUser] == nil)
    {
        [self loadAuthenticatedUser];
    }
    else
    {
        [self performSelector:@selector(segueToActivity)withObject:self afterDelay:1];
    }
    
    [super viewDidLoad];
}

-(void)loadAuthenticatedUser
{
    if([BBConstants Trace])NSLog(@"BBLoadingViewController.loadProjects");
    
    NSString* url = [NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        // save our new user
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        
        // connect said user to the user hub for notifications
        BBUserHubClient* userHub = [BBUserHubClient sharedInstance];
        [userHub connectToUserHub:appData.authenticatedUser.user.identifier];
                
        [self performSelector:@selector(segueToActivity)withObject:self afterDelay:1];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.shouldAutorotateToInterfaceOrientation:");
    
    return YES;
}

-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
}

@end
