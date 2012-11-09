//
//  BBHomeController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 16/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBHomeController.h"

#define HOME_SIZE                  (CGSize){160, 420}

@implementation BBHomeController

@synthesize actionController = _actionController;
@synthesize headerController = _headerController;
@synthesize menuController = _menuController;
@synthesize streamController = _streamController;


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBHomeController.loadView"];
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    self.app.navController.navigationBarHidden = YES;
    
    self.view = [self setupHomeView:[[BBHomeView alloc]initWithSize:HOME_SIZE]];
}


-(void)viewDidLoad {
    [BBLog Log:@"BBHomeController.viewDidLoad"];
    
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    [self loadUserStream];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(BBHomeView*)setupHomeView:(BBHomeView*)withView {
    [BBLog Log:@"BBHomeController.setupHomeView:withView"];
    
    self.headerController = [[BBHeaderController alloc]init];
    [self addChildViewController:self.headerController];
    [withView addSubview:self.headerController.view];
    
    self.menuController = [[BBMenuController alloc]init];
    [self addChildViewController:self.menuController];
    [withView addSubview:self.menuController.view];
    
    self.actionController = [[BBActionController alloc]init];
    [self addChildViewController:self.actionController];
    [withView addSubview:self.actionController.view];
    
    // all devices and orientations have the same header height
    self.menuController.view.y = IPHONE_HEADER_PORTRAIT.height;
    self.menuController.view.x = self.menuController.view.width * -1;
    
    self.actionController.view.y = IPHONE_HEADER_PORTRAIT.height + self.actionController.view.height;
    self.actionController.view.x = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:@"menuTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:@"menuTappedClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAction) name:@"actionTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAction) name:@"actionTappedClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOut) name:@"userLoggedOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserStream) name:@"userProfileLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserStream) name:@"loadUserStream" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGroupStream:) name:@"groupMenuTapped" object:nil];
    
    return withView;
}


#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBContainerController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}


-(void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBLoginController.objectLoader:didLoadObject"];
    
    if([object isKindOfClass:[BBUser class]])
    {
        [BBLog Debug:object withMessage:@"### BBUser Loaded"];
        
        self.app.appData.user = (BBUser*)object;
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                          delegate:self];
    }
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        [BBLog Debug:object withMessage:@"### BBAuthenticatedUser Loaded"];
        
        self.app.appData.authenticatedUser = (BBAuthenticatedUser*)object;
        [self.app.appData.connection start];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileLoaded" object:nil];
    }
    
    if([object isKindOfClass:[BBActivityPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBActivityPaginator Loaded"];

        // pass model to stream controller constructor
        self.streamController = [[BBStreamController alloc]init];
        [self.view addSubview:self.streamController.view];

        // append stream's view to this window
        [self.streamController displayActivities:object];
    }
    
    if([object isKindOfClass:[BBSightingPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBSightingPaginator Loaded"];
        
        // pass model to stream controller constructor
        self.streamController = [[BBStreamController alloc]init];
        [self.view addSubview:self.streamController.view];
        
        // append stream's view to this window
        [self.streamController displaySightings:object];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Error:[NSString stringWithFormat:@"%@%@", @"BBLoginController.objectLoader:didFailWithError:", [error localizedDescription]]];
}


-(void)showMenu {
    [BBLog Log:@"BBHomeController.showMenu"];
    [UIView animateWithDuration:0.15 animations:^{
        self.menuController.view.x = 0;
    }];
    
    [self.view bringSubviewToFront:self.menuController.view];
}


-(void)hideMenu {
    [BBLog Log:@"BBHomeController.hideMenu"];
    [UIView animateWithDuration:0.15 animations:^{
        self.menuController.view.x = self.menuController.view.width * -1;
    }];
}


-(void)showAction {
    [BBLog Log:@"BBHomeController.showAction"];
    [UIView animateWithDuration:0.15 animations:^{
        // all devices and orientations have the same header height
        self.actionController.view.y = 0;
    }];
    
    [self.view bringSubviewToFront:self.actionController.view];
}


-(void)hideAction {
    [BBLog Log:@"BBHomeController.hideAction"];
    [UIView animateWithDuration:0.25 animations:^{
        self.actionController.view.y = self.view.height;
    }];
}


-(void)signOut {
    [BBLog Log:@"BBHomeController.signOut"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    // delete the cookie, or elsewhere delete the cookie.
    //[self setupAuthenticatedViewPort];
}


-(void)loadUserStream {
    [BBLog Log:@"BBHomeController.loadUserStream"];
    
    // load up the user's activity
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants ActivityUrl], [BBConstants AjaxQuerystring]]
                                                      delegate:self];
    
    // update the user stream title with the name of the currently logged in user.
    BBApplication* app = [BBApplication sharedInstance];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    
    // NOTE: THis is a nil test because API is sending back null name in auth user
    if(app.authenticatedUser.user.name != nil){
        [userInfo setObject:app.authenticatedUser.user.name forKey:@"name"];
    }else{
        [userInfo setObject:@"My Home Stream" forKey:@"name"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo];
}

-(void)loadGroupStream:(NSNotification *) notification {
    [BBLog Log:@"BBHomeController.loadGroupStream"];
    
    NSDictionary* userInfo = [notification userInfo];
    BBApplication *app = [BBApplication sharedInstance];
    BBProject* project = [self getProjectWithIdentifier:[userInfo objectForKey:@"groupId"] fromArrayOf:app.authenticatedUser.projects];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@/%@/activity?%@",[BBConstants RootUriString], project.identifier, [BBConstants AjaxQuerystring]]
                                                      delegate:self];
    
    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:[NSString stringWithString:project.name] forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBHomeController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end