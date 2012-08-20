/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBLoadingViewController.h"
#import <UIKit/UIKit.h>


@interface BBLoadingViewController ()

- (BOOL)applicationRequiresLoginOrRegistration;
- (void)segueToLogin;
- (void)segueToActivity;
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
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        
        appData.authenticatedUser = [[BBAuthenticatedUser alloc]init];
        
        //[appData.authenticatedUser loadAndNotifyDelegate:self];
        
        [self performSelector:@selector(segueToLogin)withObject:self afterDelay:1];
    }
    else
    {
        [self performSelector:@selector(segueToActivity)withObject:self afterDelay:1];
    }
    
    [super viewDidLoad];
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


#pragma mark - Delegate methods and callbacks

-(void)authenticatedUserLoaded:(BBAuthenticatedUser *)authenticatedUser
{
    if([BBConstants Trace]) NSLog(@"LoadingViewController.AuthenticatedUserLoaded:");
    
    [self.aSpinner stopAnimating];
    [self.aSpinner removeFromSuperview];
    
    BBApplicationData* appData = [BBApplicationData sharedInstance];
    
    appData.authenticatedUser = authenticatedUser;
    
    [self performSelector:@selector(segueToActivity)withObject:self];
}

@end
