/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "LoadingViewController.h"
#import <UIKit/UIKit.h>


@interface LoadingViewController ()

- (BOOL)applicationRequiresLoginOrRegistration;
- (void)segueToLogin;
- (void)segueToHome;
@property (nonatomic, strong) UIActivityIndicatorView* aSpinner;

@end

@implementation LoadingViewController

@synthesize aSpinner = _aSpinner;

#pragma mark - Initialize the Application and Segue

-(BOOL)applicationRequiresLoginOrRegistration
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.applicationRequiresLoginOrRegistration");
    
    NSHTTPCookie* cookie = [CookieHelper grabCookieForUrl:[BowerBirdConstants RootUri] withName:[BowerBirdConstants BowerbirdCookieName]];
    
    return cookie == nil;
}

-(void)segueToLogin
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.segueToLogin");
    
    [self performSegueWithIdentifier:@"Login" sender:self];
}

-(void)segueToHome
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"Home" sender:self];
}

-(void)segueToActivity
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"LoadActivity" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"Login"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"Home"])
    {

    }
    else if([segue.identifier isEqualToString:@"LoadActivity"])
    {
        
    }
}


#pragma mark - View Display logic

-(void) displaySpinner
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.displaySpinner");
    
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    self.aSpinner = tempSpinner;
    
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

- (void) viewDidAppear:(BOOL) animated
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.viewDidAppear:");
    
    [self displaySpinner];
       
    if([self applicationRequiresLoginOrRegistration])
    {
        [self performSelector:@selector(segueToLogin)withObject:self afterDelay:1];
    }
    else if([[ApplicationData sharedInstance] authenticatedUser] == nil)
    {
        ApplicationData* appData = [ApplicationData sharedInstance];
        
        appData.authenticatedUser = [[AuthenticatedUser alloc]init];
        
        [appData.authenticatedUser loadAndNotifyDelegate:self];
    }
    else
    {
        [self performSelector:@selector(segueToActivity)withObject:self];
    }
    
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.shouldAutorotateToInterfaceOrientation:");
    
    return YES;
}

-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - Delegate methods and callbacks

-(void)authenticatedUserLoaded:(AuthenticatedUser *)authenticatedUser
{
    if([BowerBirdConstants Trace]) NSLog(@"LoadingViewController.AuthenticatedUserLoaded:");
    
    [self.aSpinner stopAnimating];
    [self.aSpinner removeFromSuperview];
    
    ApplicationData* appData = [ApplicationData sharedInstance];
    
    appData.authenticatedUser = authenticatedUser;
    
    [self performSelector:@selector(segueToActivity)withObject:self];
}

@end
