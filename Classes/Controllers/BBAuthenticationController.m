/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Determines if the user has a cookie. If so, loads the users profile, if not, redirects to login.
 
 -----------------------------------------------------------------------------------------------*/


#import "BBAuthenticationController.h"
#import "BBRegistrationController.h"
#import "BBAboutController.h"
#import "BBLoginController.h"
#import "BBAuthenticatedUser.h"
#import "BBAppDelegate.h"
#import "MGHelpers.h"
#import "BBHelpers.h"
#import "BBBowerBirdHeaderLogo.h"


@implementation BBAuthenticationController {
    MGScrollView *authenticationView;
}


#pragma mark -
#pragma mark - Rendering


-(void)loadView {
    [BBLog Log:@"BBAuthenticationController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    self.view.backgroundColor = [self backgroundColor];
    authenticationView = (MGScrollView*)self.view;
}

-(void)viewDidLoad {
    [BBLog Log:@"BBAuthenticationController.viewDidLoad"];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticatedUserLoaded)
                                                 name:@"authenticatedUserLoaded"
                                               object:nil];
    
    [self displayViewControls];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBAuthenticationController.viewWillAppear"];
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayViewControls {
    [BBLog Log:@"BBAuthenticationController.displayViewControls "];
    
    // A Title or BowerBird Logo:?? Generisize this from the menu and action screens.
    MGTableBox *userMenu = [MGTableBox boxWithSize:CGSizeMake(300, 0)];
    userMenu.margin = UIEdgeInsetsZero;
    userMenu.padding = UIEdgeInsetsZero;
    
    UIImageView *bowerbirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 288,54)];
    bowerbirdImage.image =[UIImage imageNamed:@"logo-negative.png"];
    MGLine *bowerbirdLogo = [MGLine lineWithSize:CGSizeMake(300,60)];
    
    bowerbirdLogo.margin = UIEdgeInsetsMake(5, 5, 5, 5);
    bowerbirdLogo.margin = UIEdgeInsetsZero;
    bowerbirdLogo.alpha = 0.5;
    [bowerbirdLogo.middleItems addObject:bowerbirdImage];
    [userMenu.topLines addObject:bowerbirdLogo];
    
    // What is bowerbird
    id welcomeHeading = @"What is BowerBird?";
    id welcomeSpiel = @"BowerBird is a place to share and discuss Australia's biodiversity. The BowerBird App is designed to allow BowerBird members to contribute in the field. For extended functionality, visit bowerbird.org.au.";
    MGTableBoxStyled *welcomeTable = [self createTableWithHeading:welcomeHeading
                                                         andSpiel:welcomeSpiel];
    
    // Login Table
    id loginHeading = @"I'm already a Member!";
    id loginSpiel = @"If you are already a member of BowerBird, you can log in by entering your email address and your password. Simply tap this box.";
    MGTableBoxStyled *loginTable = [self createTableWithHeading:loginHeading
                                                         andSpiel:loginSpiel];
    loginTable.onTap = ^{[self loginAuthenticationScreen];};
   
    // A Register Table
    id registerHeading = @"I'm new to BowerBird!";
    id registerSpiel = @"If you are not yet a BowerBird member, you will need to register before accessing all the fantastic features. Simply tap this box to get started.";
    MGTableBoxStyled *registerTable = [self createTableWithHeading:registerHeading
                                                          andSpiel:registerSpiel];
    registerTable.onTap = ^{[self registerAuthenticationScreen];};
    
    // A Browse Table
    id browseHeading = @"The Fine Print";
    id browseSpiel = @"If you would like to take a look at the privacy policy, terms of use and list of resource sources before you decide to join, tap to read here.";
    MGTableBoxStyled *browseTable = [self createTableWithHeading:browseHeading
                                                        andSpiel:browseSpiel];
    browseTable.onTap = ^{[self legalScreen];};
    
    [authenticationView.boxes addObject:userMenu];
    [authenticationView.boxes addObject:welcomeTable];
    [authenticationView.boxes addObject:loginTable];
    [authenticationView.boxes addObject:registerTable];
    [authenticationView.boxes addObject:browseTable];
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}

-(MGTableBoxStyled*)createTableWithHeading:(id)headingText
                                  andSpiel:(id)spielText {
    
    MGTableBoxStyled *table = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    table.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *tableHeading = [MGLine lineWithLeft:headingText
                                          right:nil
                                           size:CGSizeMake(280, 40)];
    tableHeading.font = HEADER_FONT;
    tableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [table.topLines addObject:tableHeading];
    MGLine *tableBlurb = [MGLine lineWithMultilineLeft:spielText
                                                 right:nil
                                                 width:280
                                             minHeight:40];
    tableBlurb.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [table.middleLines addObject:tableBlurb];


    return table;
}

-(void)loginAuthenticationScreen {
    [BBLog Log:@"Login pushed"];
    
    BBLoginController *loginController = [[BBLoginController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:loginController animated:YES];
}

-(void)registerAuthenticationScreen {
    [BBLog Log:@"Register pushed"];
    
    BBRegistrationController *registrationController = [[BBRegistrationController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:registrationController animated:YES];
}

-(void)legalScreen {
    [BBLog Log:@"Browse pushed"];
    
    BBAboutController *aboutController = [[BBAboutController alloc]init];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:aboutController animated:YES];
}

-(void)authenticatedUserLoaded {
    [BBLog Log:@"BBAuthenticationController.authenticatedUserLoaded"];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popToRootViewControllerAnimated:YES];
}

-(void)cancelUserRegistration {
    [BBLog Log:@"BBAuthenticationController.cancelUserRegistration"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayAuthenticate" object:nil];
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBAuthenticationController"];
 
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end