//
//  BBMenuController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMenuController.h"

@interface BBMenuController ()

@property CGSize menuSize;

@end

@implementation BBMenuController {
    MGScrollView *menuView;
    UIImage *arrow;
}

@synthesize menuSize = _menuSize;


#pragma mark -
#pragma mark - Setup and Render


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


-(void)populateMenu
{
    // heading of avatar and user name
    // link to home
    // heading of projects:
    // link for each project
    // browse all projects
    // log out/profile/settings
    
    MGTableBox *userMenu = [MGTableBox boxWithSize:CGSizeMake(300, 0)];
    userMenu.margin = UIEdgeInsetsZero;
    userMenu.padding = UIEdgeInsetsZero;
    
    BBApplication* appData = [BBApplication sharedInstance];
 
    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 288,54)];
    bowerbirdImage.image =[UIImage imageNamed:@"logo-negative.png"];
    MGLine *bowerbirdLogo = [MGLine lineWithSize:CGSizeMake(300,60)];
    
    bowerbirdLogo.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    bowerbirdLogo.margin = UIEdgeInsetsZero;
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    [userMenu.topLines addObject:bowerbirdLogo];
    
    // add the user's home and favourites in a table
    MGTableBoxStyled *userTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    MGLine *userTableHeader = [MGLine lineWithLeft:@"My Places" right:nil size:CGSizeMake(280,40)];
    userTableHeader.font = HEADER_FONT;
    userTableHeader.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [userTable.topLines addObject:userTableHeader];
    
    PhotoBox *userHomeImage = [PhotoBox mediaFor:@"/img/home.png" size:IPHONE_AVATAR_SIZE];
    userHomeImage.margin = UIEdgeInsetsZero;
    MGLine *userHomeDescription = [MGLine lineWithLeft:userHomeImage right:arrow size:CGSizeMake(280, 40)];
    [userHomeDescription.middleItems addObject:@"Take Me Home"];
    userHomeDescription.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserStream" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    };
    [userTable.middleLines addObject:userHomeDescription];
    
    PhotoBox *userFavoritesImage = [PhotoBox mediaFor:@"/img/favourites.png" size:IPHONE_AVATAR_SIZE];
    userFavoritesImage.margin = UIEdgeInsetsZero;
    MGLine *userFavoritesDescription = [MGLine lineWithLeft:userFavoritesImage right:arrow size:CGSizeMake(280, 40)];
    [userFavoritesDescription.middleItems addObject:@"My Favourites"];
    [userTable.middleLines addObject:userFavoritesDescription];
    
    MGTableBoxStyled *projectTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    MGLine *projectTableHeader = [MGLine lineWithLeft:@"My Projects" right:nil size:CGSizeMake(280,40)];
    projectTableHeader.font = HEADER_FONT;
    projectTableHeader.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [projectTable.topLines addObject:projectTableHeader];
    
    NSArray* projectsForUser = appData.authenticatedUser.projects;
    for(BBProject* project in projectsForUser)
    {
        BBImage* projectImage = [self getImageWithDimension:@"Square50" fromArrayOf:project.avatar.imageMedia];
        PhotoBox *projectAvatar = [PhotoBox mediaFor:projectImage.uri size:IPHONE_AVATAR_SIZE];
        projectAvatar.margin = UIEdgeInsetsZero;
        
        MGLine *projectDescription = [MGLine lineWithLeft:projectAvatar right:arrow size:CGSizeMake(280, 40)];
        [projectDescription.middleItems addObject:project.name];
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

    MGTableBoxStyled *exploreTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    MGLine *exploreTableHeader = [MGLine lineWithLeft:@"Browse All Projects" right:nil size:CGSizeMake(280,40)];
    exploreTableHeader.font = HEADER_FONT;
    exploreTableHeader.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [exploreTable.topLines addObject:exploreTableHeader];
    
    UIImageView *projectBrowser = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_AVATAR_SIZE.width, IPHONE_AVATAR_SIZE.height)];
    projectBrowser.image =[UIImage imageNamed:@"projects.png"];
    MGLine *exploreProjects = [MGLine lineWithLeft:projectBrowser right:@"Project Browser" size:CGSizeMake(280,40)];
    exploreProjects.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exploreProjectsTapped" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
    };
    [exploreTable.middleLines addObject:exploreProjects];
    
    MGTableBoxStyled *profileTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300.0, 0)];
    MGLine *profileTableHeader = [MGLine lineWithLeft:@"My Profile" right:nil size:CGSizeMake(280,30)];
    profileTableHeader.font = HEADER_FONT;
    profileTableHeader.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [profileTable.topLines addObject:profileTableHeader];
    MGLine *signOut = [MGLine lineWithLeft:nil right:@"Sign Me Out" size:CGSizeMake(280,40)];
    signOut.onTap = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasSignedOut" object:nil];
    };
    [profileTable.middleLines addObject:signOut];
    
    [menuView.boxes addObject:userMenu];
    [menuView.boxes addObject:userTable];
    if(projectsForUser.count > 0)
    {
        [menuView.boxes addObject:projectTable];
    }
    [menuView.boxes addObject:exploreTable];
    [menuView.boxes addObject:profileTable];
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
    self.view.x = self.view.width * -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuTappedClose" object:nil];
}


//-(void)loadProjectStream:


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