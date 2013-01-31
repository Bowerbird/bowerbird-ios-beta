/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
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
                                             selector:@selector(showHomeView)
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
        
        BBApplication* appData = [BBApplication sharedInstance];
        appData.authenticatedUser = [[BBAuthenticatedUser alloc]init];
        
        RKObjectManager *manager = [RKObjectManager sharedManager];
        manager.serializationMIMEType = RKMIMETypeJSON;
        
        //[manager getObject:appData.authenticatedUser delegate:appData.authenticatedUser];
        /*
        usingBlock:^(RKObjectLoader *loader) {
            loader.delegate = authUser;
            loader.params = [BBConstants AjaxRequestParams];
        }];
        */
        
        // pull down the logged in user's latest profile information
        [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                  delegate:appData.authenticatedUser];
    }
    else
    {
        // load up the Authentication Controller to register or sign the user in
        [self showAuthenticationView];
    }
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
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
    // Dispose of any resources that can be recreated.
}


@end