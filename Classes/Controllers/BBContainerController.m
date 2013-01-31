//
//  BBViewController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBContainerController.h"

@implementation BBContainerController {
    BBAuthenticatedUser *authUser;
}

#pragma mark -
#pragma mark - Setup and Render

//http://stackoverflow.com/questions/573958/iphone-sdk-what-is-the-difference-between-loadview-and-viewdidload
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

// TODO: call server side signout, Kill hub connections
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

/*
#pragma mark -
#pragma mark - Delegation and Event Handling

-(void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBLoginController.objectLoader:didLoadObject"];

    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        BBApplication* appData = [BBApplication sharedInstance];
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        //[appData.connection start];
     
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Welcome back \n%@", appData.authenticatedUser.user.name]];
        
        //BBUserHubClient* userHubClient = [BBUserHubClient sharedInstance];
        //[userHubClient connectToUserHub:appData.authenticatedUser.user.identifier];
        //appData.userHub = userHubClient.userHub;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileHasLoaded" object:nil];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Error:[NSString stringWithFormat:@"%@%@", @"BBLoginController.objectLoader:didFailWithError:", [error localizedDescription]]];
    
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
 
 */

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContainerController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end