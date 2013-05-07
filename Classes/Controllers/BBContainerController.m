/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 This is the lowest level container. All VCs load into this - menu, heading, home, stream etc
 
 -----------------------------------------------------------------------------------------------*/


#import "BBContainerController.h"
#import "BBHomeController.h"
#import "BBContainerView.h"
#import "BBAuthenticationController.h"
#import "BBContributionController.h"
#import "BBAppDelegate.h"
#import "BBApplication.h"
#import "SVProgressHUD.h"
#import "BBAuthenticatedUser.h"


@implementation BBContainerController {
    BBAuthenticatedUser *authUser;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {   
    [BBLog Log:@"BBContainerController.loadView"];
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    
    BBContainerView* container = [[BBContainerView alloc]initWithSize:IPHONE_PORTRAIT];
    
    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHomeView)
                                                 name:@"userHasAuthenticated"
                                               object:nil];

    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUserProfile:)
                                                 name:@"userProfileHasLoaded"
                                               object:nil];
    
    // triggered when user has signed out
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signUserOut)
                                                 name:@"userHasSignedOut"
                                               object:nil];

    // triggered when user has clicked an action to initiate a contribution
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createContributionWithCamera)
                                                 name:@"chooseCameraTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createContributionWithRecord)
                                                 name:@"createRecordTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createContributionWithLibrary)
                                                 name:@"chooseLibraryTapped"
                                               object:nil];
    
    self.view = container;
}

-(void)viewDidLoad {
    [BBLog Log:@"BBContainerController.viewDidLoad"];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBContainerController.viewWillAppear"];
    
    if([self userIsAuthenticated])
    {
        // do UI stuff back in UI land
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setStatus:@"Loading your profile"];
        });
        
        [[RKObjectManager sharedManager] getObjectsAtPath:[BBConstants AuthenticatedUserProfileRoute]
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      if([mappingResult.firstObject isKindOfClass:[BBAuthenticatedUser class]]){
                                                          [SVProgressHUD showSuccessWithStatus:@"Welcome Back!"];
                                                          NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                                                          [userInfo setObject:mappingResult.firstObject forKey:@"authenticatedUser"];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileHasLoaded" object:self userInfo:userInfo];
                                                      }
                                                      [SVProgressHUD showErrorWithStatus:@"Could not log you in"];
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      [BBLog Log:[error localizedDescription]];
                                                      [SVProgressHUD showErrorWithStatus:@"Could not log you in"];
                                                  }];
    }
    else
    {
        // load up the Authentication Controller to register or sign the user in
        [self showAuthenticationView];
    }
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}

-(void)setUserProfile:(NSNotification *) notification {
    //[NSAssert(notification != nil, @"notification must not be null")];
    
    NSDictionary* userInfo = [notification userInfo];
    id authenticatedUser = [userInfo objectForKey:@"authenticatedUser"];
    
    //[NSAssert([authenticatedUser isKindOfClass:[BBAuthenticatedUser class]], @"User Profile must load an AuthenticatedUser object")];
    
    BBApplication *appData = [BBApplication sharedInstance];
    appData.authenticatedUser = (BBAuthenticatedUser*)authenticatedUser;
    
    // send user to home view via notification... could just as easily call method directly
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasAuthenticated" object:nil userInfo:nil];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(BOOL)userIsAuthenticated {
    NSHTTPCookie* cookie = [BBCookieHelper grabCookieForUrl:[BBConstants RootUri]
                                                   withName:[BBConstants CookieName]];
    
    return cookie != nil;
}

-(void)signUserOut{
    [BBLog Log:@"BBContainerController.signUserOut"];
    
    [BBCookieHelper deleteCookies];
    
    [self showAuthenticationView];
}

-(void)showHomeView {
    [BBLog Log:@"BBContainerController.showUserIsAuthenticatedView"];
    
    BBHomeController *homeController = [[BBHomeController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:homeController animated:NO];
}

-(void)showAuthenticationView {
    [BBLog Log:@"BBContainerController.showUserIsNotAuthenticatedView"];
    
    BBAuthenticationController *authenticationController = [[BBAuthenticationController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:authenticationController animated:NO];
}

-(void)createContributionWithCamera {
    [BBLog Log:@"BBContainerController.createContributionWithCamera"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithCamera];

    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:contributionController animated:NO];
}

-(void)createContributionWithLibrary {
    [BBLog Log:@"BBContainerController.createContributionWithLibrary"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithLibrary];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:contributionController animated:NO];
}

-(void)createContributionWithRecord {
    [BBLog Log:@"BBContainerController.createContributionWithRecord"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithRecord];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:contributionController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContainerController"];
    
    [super didReceiveMemoryWarning];
}


@end