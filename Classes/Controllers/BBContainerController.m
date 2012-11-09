//
//  BBViewController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBContainerController.h"

@implementation BBContainerController


#pragma mark -
#pragma mark - Setup and Render


//http://stackoverflow.com/questions/573958/iphone-sdk-what-is-the-difference-between-loadview-and-viewdidload
-(void)loadView {   
    [BBLog Log:@"BBContainerController.loadView"];
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    self.app.navController.navigationBarHidden = YES;
    
    BBContainerView* container = [[BBContainerView alloc]initWithSize:IPHONE_PORTRAIT];
    
    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomeView) name:@"userHasAuthenticated" object:nil];

    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomeView) name:@"userProfileHasLoaded" object:nil];
    
    // triggered when user has signed out
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUserOut) name:@"userHasSignedOut" object:nil];

    // triggered when user has clicked an action to initiate a contribution
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createContributionWithCamera) name:@"chooseCameraTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createContributionWithRecord) name:@"createRecordTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createContributionWithLibrary) name:@"chooseLibraryTapped" object:nil];
    
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
        // pull down the logged in user's latest profile information
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                          delegate:self];
    }
    else
    {
        // load up the Authentication Controller to register or sign the user in
        [self showAuthenticationView];
    }
    
    self.app.navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(BOOL)userIsAuthenticated {
    NSHTTPCookie* cookie = [BBCookieHelper grabCookieForUrl:[BBConstants RootUri]
                                                   withName:[BBConstants CookieName]];
    
    return cookie != nil;
}


// TODO: call server side signout, Kill hub connections
-(void)signUserOut{
    [BBLog Log:@"BBContainerController.signUserOut"];
    
    [BBCookieHelper deleteCookies];
    
    [self showAuthenticationView];
}


-(void)showHomeView {
    [BBLog Log:@"BBContainerController.showUserIsAuthenticatedView"];
    
    BBHomeController *homeController = [[BBHomeController alloc]init];
    [self.app.navController pushViewController:homeController animated:NO];
}


-(void)showAuthenticationView {
    [BBLog Log:@"BBContainerController.showUserIsNotAuthenticatedView"];
    
    BBAuthenticationController *authenticationController = [[BBAuthenticationController alloc]init];
    [self.app.navController pushViewController:authenticationController animated:NO];
}


-(void)createContributionWithCamera {
    [BBLog Log:@"BBContainerController.createContributionWithCamera"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithCamera];
    
    [self.app.navController pushViewController:contributionController animated:NO];
}


-(void)createContributionWithLibrary {
    [BBLog Log:@"BBContainerController.createContributionWithLibrary"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithLibrary];
    
    [self.app.navController pushViewController:contributionController animated:NO];
}


-(void)createContributionWithRecord {
    [BBLog Log:@"BBContainerController.createContributionWithRecord"];
    
    BBContributionController *contributionController = [[BBContributionController alloc]initWithRecord];
    
    [self.app.navController pushViewController:contributionController animated:NO];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBLoginController.objectLoader:didLoadObject"];

    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        [BBLog Debug:object withMessage:@"### BBAuthenticatedUser Loaded"];
        
        BBApplication* appData = [BBApplication sharedInstance];
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        
        [self.app.appData.connection start];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileHasLoaded" object:nil];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Error:[NSString stringWithFormat:@"%@%@", @"BBLoginController.objectLoader:didFailWithError:", [error localizedDescription]]];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContainerController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end