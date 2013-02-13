/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Exists as a wrapper to contain all VCs with Logged in context such as menu, stream and heading
 
 -----------------------------------------------------------------------------------------------*/


#import "BBHomeController.h"
#import "BBMenuController.h"
#import "BBActionController.h"
#import "BBHeaderController.h"
#import "BBStreamController.h"
#import "BBAboutController.h"
#import "BBHomeView.h"
#import "MGHelpers.h"
#import "SVProgressHUD.h"
#import "BBAppDelegate.h"
#import "BBUser.h"
#import "BBAuthenticatedUser.h"
#import "BBProject.h"


#define HOME_SIZE (CGSize){160, 420}


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(browseGroupStream:) name:@"groupBrowseTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProjectBrowser) name:@"exploreProjectsTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserFavorites) name:@"loadUserFavorites" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLegal) name:@"legalHasBeenTapped" object:nil];

    //loadUserFavorites
    
    return withView;
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)displayStreamView:(UIView*)streamView {
    [BBLog Log:@"BBHomeController.displayStreamView:"];
    
    [self.view addSubview:streamView];
    self.streamController.view.y += 50;
    self.streamController.view.height -= 50;
}

-(void)handleSwipeRight:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBHomeController.handleSwipeRight:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTapped" object:nil];
}

-(void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBHomeController.objectLoader:didLoadObject"];
    
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfileLoaded" object:nil];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Error:[NSString stringWithFormat:@"%@%@", @"BBLoginController.objectLoader:didFailWithError:", [error localizedDescription]]];
    
    [SVProgressHUD showErrorWithStatus:error.description];
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
    [self dismissModalViewControllerAnimated:YES];
}

-(void)signOut {
    [BBLog Log:@"BBHomeController.signOut"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
}

-(void)loadUserStream {
    [BBLog Log:@"BBHomeController.loadUserStream"];

    [self clearStreamViews];
    
    self.streamController = [[BBStreamController alloc]initWithUserAndDelegate:self];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setObject:@"Home" forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo];
}

-(void)loadGroupStream:(NSNotification *) notification {
    [BBLog Log:@"BBHomeController.loadGroupStream"];
    
    [self clearStreamViews];

    NSString *groupId = [[notification userInfo] objectForKey:@"groupId"];
    
    self.streamController = [[BBStreamController alloc]initWithGroup:groupId
                                                         andDelegate:self];
    
    BBApplication *app = [BBApplication sharedInstance];
    
    BBProject* project = [self getProjectWithIdentifier:groupId
                                            fromArrayOf:app.authenticatedUser.projects];

    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:[NSString stringWithString:project.name] forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}


-(void)browseGroupStream:(NSNotification *) notification {
    [BBLog Log:@"BBHomeController.browseGroupStream"];
    
    [self clearStreamViews];
    
    NSString *groupId = [[notification userInfo] objectForKey:@"groupId"];
    NSString *groupName = [[notification userInfo] objectForKey:@"name"];
    
    self.streamController = [[BBStreamController alloc]initWithGroup:groupId
                                                         andDelegate:self];
    
    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:[NSString stringWithString:groupName] forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}

-(void)loadProjectBrowser {
    [BBLog Log:@"BBHomeController.loadProjectBrowser"];
    
    [self clearStreamViews];
    
    self.streamController = [[BBStreamController alloc]initWithProjectsAndDelegate:self];

    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:@"Browse Projects" forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}

-(void)loadUserFavorites {
    [BBLog Log:@"BBHomeController.loadUserFavorites"];
    
    [self clearStreamViews];
    
    self.streamController = [[BBStreamController alloc]initWithFavouritesAndDelegate:self];

    NSMutableDictionary* userInfo2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo2 setObject:@"My Favourites" forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeadingTitle" object:self userInfo:userInfo2];
}

-(void)showLegal {
    [BBLog Log:@"BBHomeController.showLegal"];
    
    [self clearStreamViews];
    
    BBAboutController *aboutController = [[BBAboutController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:aboutController animated:YES];
}

-(void)clearStreamViews {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view addSubview:self.headerController.view];
    [self.view addSubview:self.menuController.view];
    [self.view addSubview:self.actionController.view];
    
    self.streamController = nil;
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBHomeController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end