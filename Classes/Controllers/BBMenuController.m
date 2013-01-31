/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMenuController.h"
#import "BBProject.h"
#import "BBUser.h"
#import "BBAuthenticatedUser.h"
#import "BBMediaResource.h"


@interface BBMenuController ()

@property CGSize menuSize;

@end


@implementation BBMenuController {
    MGScrollView *menuView;
    UIImage *arrow;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize menuSize = _menuSize;


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBMenuController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    arrow = [UIImage imageNamed:@"arrow.png"];
    menuView = (MGScrollView*)self.view;
}

- (void)viewDidLoad {
    [BBLog Log:@"BBMenuController.viewDidLoad"];
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(projectJoined:)
                                                 name:@"projectJoined"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(projectLeft:)
                                                 name:@"projectLeft"
                                               object:nil];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [tapGestureRecognize requireGestureRecognizerToFail:tapGestureRecognize];
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRecognizer];
    
    [self populateMenu];
    self.view.alpha = 0;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)populateMenu {
    // heading of avatar and user name
    // link to home
    // heading of projects:
    // link for each project
    // browse all projects
    // log out/profile/settings
    
    [menuView.boxes removeAllObjects];
    
    MGLine *bottomRowPadder = [MGLine lineWithSize:CGSizeMake(280, 5)];
    
    MGTableBox *userMenu = [MGTableBox boxWithSize:CGSizeMake(300, 0)];
    userMenu.margin = UIEdgeInsetsZero;
    userMenu.padding = UIEdgeInsetsZero;
    
    BBApplication* appData = [BBApplication sharedInstance];
 
    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 288,54)];
    bowerbirdImage.image =[UIImage imageNamed:@"logo-negative.png"];
    MGLine *bowerbirdLogo = [MGLine lineWithSize:CGSizeMake(300,60)];
    bowerbirdLogo.underlineType = MGUnderlineNone;
    
    
    bowerbirdLogo.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    bowerbirdLogo.margin = UIEdgeInsetsZero;
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    [userMenu.topLines addObject:bowerbirdLogo];
    
    
    // USER PLACES TABLE
    MGTableBox *userTableWrapper = [MGTableBox box];
    MGTableBoxStyled *userTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    [userTableWrapper.middleLines addObject:userTable];
    PhotoBox *userHomeImage = [PhotoBox mediaFor:@"/img/home.png" size:IPHONE_AVATAR_SIZE];
    userHomeImage.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    MGLine *userHomeDescriptionLabel = [MGLine lineWithLeft:@"Home" right:arrow size:CGSizeMake(220, 40)];
    userHomeDescriptionLabel.font = HEADER_FONT;
    userHomeDescriptionLabel.underlineType = MGUnderlineNone;
    MGLine *userHomeDescription = [MGLine lineWithLeft:userHomeImage right:userHomeDescriptionLabel size:CGSizeMake(280, 50)];
    userHomeDescription.underlineType = MGUnderlineNone;
    userHomeDescription.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserStream" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    };
    [userTable.middleLines addObject:userHomeDescription];
    PhotoBox *userFavoritesImage = [PhotoBox mediaFor:@"/img/favourites.png" size:IPHONE_AVATAR_SIZE];
    userFavoritesImage.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    MGLine *userFavoritesDescriptionLabel = [MGLine lineWithLeft:@"Favorites" right:arrow size:CGSizeMake(220, 40)];
    userFavoritesDescriptionLabel.font = HEADER_FONT;
    userFavoritesDescriptionLabel.underlineType = MGUnderlineNone;
    MGLine *userFavoritesDescription = [MGLine lineWithLeft:userFavoritesImage right:userFavoritesDescriptionLabel size:CGSizeMake(280, 50)];
    userFavoritesDescription.underlineType = MGUnderlineNone;
    userFavoritesDescription.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserFavorites" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    };
    [userTable.middleLines addObject:userFavoritesDescription];
    [userTable.bottomLines addObject:bottomRowPadder];
    
    // PROJECT TABLE
    MGTableBox *projectTableWrapper = [MGTableBox box];
    MGLine *projectTableHeader = [MGLine lineWithLeft:@"Projects" right:nil size:CGSizeMake(280,40)];
    //projectTableHeader.font = HEADER_FONT;
    projectTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 10);
    projectTableHeader.underlineType = MGUnderlineNone;
    [projectTableWrapper.topLines addObject:projectTableHeader];
    MGTableBoxStyled *projectTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    [projectTableWrapper.middleLines addObject:projectTable];
    NSArray* projectsForUser = appData.authenticatedUser.projects;
    for(BBProject* project in projectsForUser)
    {
        BBImage* projectImage = [self getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *projectAvatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        projectAvatar.margin = UIEdgeInsetsMake(5, 5, 5, 5);
        MGLine *projectDescriptionLabel = [MGLine lineWithLeft:project.name right:arrow size:CGSizeMake(220, 40)];
        projectDescriptionLabel.font = HEADER_FONT;
        projectDescriptionLabel.underlineType = MGUnderlineNone;
        MGLine *projectDescription = [MGLine lineWithLeft:projectAvatar right:projectDescriptionLabel size:CGSizeMake(280, 50)];
        projectDescription.underlineType = MGUnderlineNone;
        projectDescription.margin = UIEdgeInsetsZero;
        projectDescription.onTap = ^{
            // TODO: add a delegate to ContainerController whose protocol can empty stream controller views...
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:[NSString stringWithString:project.identifier] forKey:@"groupId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupMenuTapped" object:self userInfo:userInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
        };
        
        [projectTable.middleLines addObject:projectDescription];
    }
    [projectTable.bottomLines addObject:bottomRowPadder];

    // EXPLORE TABLE
    MGTableBox *exploreTableWrapper = [MGTableBox box];
    MGLine *exploreTableHeader = [MGLine lineWithLeft:@"Explore, Join and Leave Projects" right:nil size:CGSizeMake(280,40)];
    //exploreTableHeader.font = HEADER_FONT;
    exploreTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 10);
    exploreTableHeader.underlineType = MGUnderlineNone;
    [exploreTableWrapper.topLines addObject:exploreTableHeader];
    MGTableBoxStyled *exploreTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    [exploreTableWrapper.middleLines addObject:exploreTable];
    PhotoBox *projectBrowser = [PhotoBox mediaForImage:[UIImage imageNamed:@"projects.png"] size:IPHONE_AVATAR_SIZE];
    projectBrowser.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    MGLine *exploreProjectsLabel = [MGLine lineWithLeft:@"Project Browser" right:arrow size:CGSizeMake(220, 40)];
    exploreProjectsLabel.font = HEADER_FONT;
    exploreProjectsLabel.underlineType = MGUnderlineNone;
    MGLine *exploreProjects = [MGLine lineWithLeft:projectBrowser right:exploreProjectsLabel size:CGSizeMake(280,50)];
    exploreProjects.bottomPadding = 5;
    exploreProjects.underlineType = MGUnderlineNone;
    exploreProjects.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exploreProjectsTapped" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    };
    [exploreTable.middleLines addObject:exploreProjects];
    [exploreTable.bottomLines addObject:bottomRowPadder];
    
    // PROFILE TABLE
    MGTableBox *profileTableWrapper = [MGTableBox box];
    MGLine *profileTableHeader = [MGLine lineWithLeft:appData.authenticatedUser.user.name right:nil size:CGSizeMake(280,40)];
    //profileTableHeader.font = HEADER_FONT;
    profileTableHeader.padding = UIEdgeInsetsMake(10, 10, 0, 10);
    profileTableHeader.underlineType = MGUnderlineNone;
    [profileTableWrapper.topLines addObject:profileTableHeader];
    MGTableBoxStyled *profileTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    [profileTableWrapper.middleLines addObject:profileTable];
    PhotoBox *accountBrowser = [PhotoBox mediaForImage:[UIImage imageNamed:@"user-icon.png"] size:IPHONE_AVATAR_SIZE];
    accountBrowser.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    MGLine *signOutLabel = [MGLine lineWithLeft:@"Logout" right:arrow size:CGSizeMake(220,40)];
    signOutLabel.font = HEADER_FONT;
    signOutLabel.underlineType = MGUnderlineNone;
    MGLine *signOut = [MGLine lineWithLeft:accountBrowser right:signOutLabel size:CGSizeMake(280, 50)];
    signOut.underlineType = MGUnderlineNone;
    signOut.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasSignedOut" object:nil];
    };
    [profileTable.middleLines addObject:signOut];
    [profileTable.bottomLines addObject:bottomRowPadder];
    
    [menuView.boxes addObject:userMenu];
    [menuView.boxes addObject:userTableWrapper];
    if(projectsForUser.count > 0)
    {
        [menuView.boxes addObject:projectTableWrapper];
    }
    [menuView.boxes addObject:exploreTableWrapper];
    [menuView.boxes addObject:profileTableWrapper];
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
    self.view.x = self.view.width * -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
}

-(void)projectJoined:(NSNotification *) notification{
    
    BBApplication* appData = [BBApplication sharedInstance];
    NSDictionary* userInfo = [notification userInfo];
    BBProject *project = [userInfo objectForKey:@"project"];
    
    __block BOOL alreadyExists = NO;
    [appData.authenticatedUser.projects enumerateObjectsUsingBlock:^(BBProject *obj, NSUInteger idx, BOOL *stop) {
        if([obj.identifier isEqualToString:project.identifier]) {
            alreadyExists = YES;
            *stop = YES;
        }
    }];
    
    if(!alreadyExists) {
        NSMutableArray *projects = [[NSMutableArray alloc]initWithArray:appData.authenticatedUser.projects];
        appData.authenticatedUser.projects = projects;
    }
    
    [self populateMenu];
    [self.view setNeedsDisplay];
}

-(void)projectLeft:(NSNotification *) notification{
    
    BBApplication* appData = [BBApplication sharedInstance];
    NSDictionary* userInfo = [notification userInfo];
    BBProject *project = [userInfo objectForKey:@"project"];
    
    __block NSMutableArray *projects = [[NSMutableArray alloc]initWithArray:appData.authenticatedUser.projects];
    [projects enumerateObjectsUsingBlock:^(BBProject *obj, NSUInteger idx, BOOL *stop) {
        if([obj.identifier isEqualToString:project.identifier]) {
            [projects removeObject:obj];
            *stop = YES;
        }
    }];
    
    appData.authenticatedUser.projects = projects;
    
    [self populateMenu];
    [self.view setNeedsDisplay];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBMenuController.singleTapGestureRecognizer:"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
}

- (void)handleSwipeFrom:(UIGestureRecognizer *)gestureRecognizer {
    [BBLog Log:@"BBMenuController.handleSwipeFrom:"];
    
    // this is a right swipe so bring in the menu
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBMenuController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end