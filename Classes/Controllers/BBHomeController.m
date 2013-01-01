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
@synthesize stream = _stream;


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBHomeController.loadView"];
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
    
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


-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(BBHomeView*)setupHomeView:(BBHomeView*)withView {
    [BBLog Log:@"BBHomeController.setupHomeView:withView"];
    
    self.headerController = [[BBHeaderController alloc]init];
    self.menuController = [[BBMenuController alloc]init];
    self.actionController = [[BBActionController alloc]init];
    
    // all devices and orientations have the same header height
    self.menuController.view.y = IPHONE_HEADER_PORTRAIT.height;
    self.menuController.view.x = [self screenSize].width * -1;
    
    self.actionController.view.y = [self screenSize].height;
    self.actionController.view.x = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:@"menuTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:@"menuTappedClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAction) name:@"actionTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAction) name:@"actionTappedClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOut) name:@"userLoggedOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserStream) name:@"userProfileLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserStream) name:@"loadUserStream" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGroupStream:) name:@"groupMenuTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProjectBrowser) name:@"exploreProjectsTapped" object:nil];
    
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
    
    [SVProgressHUD dismiss];
    
    if([object isKindOfClass:[BBUser class]])
    {
        [BBLog Debug:object withMessage:@"### BBUser Loaded"];
        
        BBApplication *appData = [BBApplication sharedInstance];
        appData.user = (BBUser*)object;
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                          delegate:self];
    }
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        [BBLog Debug:object withMessage:@"### BBAuthenticatedUser Loaded"];
        
        BBApplication *appData = [BBApplication sharedInstance];
        //[appData.connection start];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileLoaded" object:nil];
    }
    
    if([object isKindOfClass:[BBActivityPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBActivityPaginator Loaded"];

        // pass model to stream controller constructor
        self.streamController = [[BBStreamController alloc]init];
        [self.view addSubview:self.streamController.view];
        self.streamController.view.y += 50;
        ((MGScrollView*)self.streamController.view).height -= 50;

        // append stream's view to this window
        [self.streamController displayActivities:object];
    }
    
    if([object isKindOfClass:[BBProjectPaginator class]])
    {
        [BBLog Debug:object withMessage:@"### BBProjectPaginator Loaded"];
        // we should remove all the stream controller's views at this point
        
        // pass model to stream controller constructor
        self.streamController = [[BBStreamController alloc]init];
        [self.view addSubview:self.streamController.view];
        self.streamController.view.y += 50;
        ((MGScrollView*)self.streamController.view).height -= 50;
        
        // append stream's view to this window
        [self.streamController displayProjects:object];
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
    
    [SVProgressHUD dismiss];
}


-(void)showMenu {
    [BBLog Log:@"BBHomeController.showMenu"];
    [UIView animateWithDuration:0.15 animations:^{
        self.menuController.view.x = 0;
        self.menuController.view.alpha = 1;
    }];
    
    [self.view bringSubviewToFront:self.menuController.view];
}


-(void)hideMenu {
    [BBLog Log:@"BBHomeController.hideMenu"];
    [UIView animateWithDuration:0.15 animations:^{
        self.menuController.view.x = self.menuController.view.width * -1;
        self.menuController.view.alpha = 0;
    }];
}


-(void)showAction {
    [BBLog Log:@"BBHomeController.showAction"];
    [UIView animateWithDuration:0.15 animations:^{
        // all devices and orientations have the same header height
        self.actionController.view.y = 0;
        self.actionController.view.alpha = 1;
    }];
    
    [self.view bringSubviewToFront:self.actionController.view];
}


-(void)hideAction {
    [BBLog Log:@"BBHomeController.hideAction"];
    [UIView animateWithDuration:0.25 animations:^{
        self.actionController.view.y = self.view.height;
        self.actionController.view.alpha = 0;
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

    [self clearStreamViews];
    [SVProgressHUD showWithStatus:@"Loading Activity"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants ActivityUrl], [BBConstants AjaxQuerystring]]
                                                      delegate:self];
    
    // update the user stream title with the name of the currently logged in user.
    BBApplication* app = [BBApplication sharedInstance];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    
    // NOTE: THis is a nil test because API is sending back null name in auth user
    if(app.authenticatedUser.user.name != nil){
        //[userInfo setObject:app.authenticatedUser.user.name forKey:@"name"];
        // renamed to "Home"
        [userInfo setObject:@"Home" forKey:@"name"];
    }else{
        [userInfo setObject:@"My Home Stream" forKey:@"name"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo];
}


-(void)loadGroupStream:(NSNotification *) notification {
    [BBLog Log:@"BBHomeController.loadGroupStream"];
    
    [self clearStreamViews];
    [SVProgressHUD showWithStatus:@"Loading Activity"];
    NSDictionary* userInfo = [notification userInfo];
    BBApplication *app = [BBApplication sharedInstance];
    BBProject* project = [self getProjectWithIdentifier:[userInfo objectForKey:@"groupId"] fromArrayOf:app.authenticatedUser.projects];
    
//    NSString *queryUrl =[NSString stringWithFormat:@"%@/%@/activity?%@",[BBConstants RootUriString], project.identifier, [BBConstants AjaxQuerystring]];
    NSString *queryUrl =[NSString stringWithFormat:@"%@/%@?%@",[BBConstants RootUriString], project.identifier, [BBConstants AjaxQuerystring]];
  
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:queryUrl
                                                      delegate:self];
    
    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:[NSString stringWithString:project.name] forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}


-(void)loadProjectBrowser {
    [BBLog Log:@"BBHomeController.loadProjectBrowser"];
    
    [self clearStreamViews];
    [SVProgressHUD showWithStatus:@"Loading Projects"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@/projects?%@",[BBConstants RootUriString], [BBConstants AjaxQuerystring]]
                                                      delegate:self];
    
    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:@"Browse Projects" forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}


-(void)clearStreamViews {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view addSubview:self.headerController.view];
    [self.view addSubview:self.menuController.view];
    [self.view addSubview:self.actionController.view];
}


-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBHomeController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end