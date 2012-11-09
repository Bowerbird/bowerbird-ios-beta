//
//  BBAuthenticationController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBAuthenticationController.h"

@implementation BBAuthenticationController {
    MGScrollView *authenticationView;
}


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBAuthenticationController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    self.view.backgroundColor = [self backgroundColor];
    authenticationView = (MGScrollView*)self.view;
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
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
    
    self.app.navController.navigationBarHidden = YES;
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
    MGTableBoxStyled *welcomeTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300, 100)];
    welcomeTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *welcomeTableHeading = [MGLine lineWithLeft:@"What is BowerBird?" right:nil size:CGSizeMake(280, 40)];
    welcomeTableHeading.font = HEADER_FONT;
    welcomeTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [welcomeTable.topLines addObject:welcomeTableHeading];
    
    id welcomeSpiel = @"BowerBird is a place to share and discuss Australia's biodiversity. To find out more, visit bowerbird.org.au.";
    MGLine *welcomeTableBlurb =[MGLine lineWithMultilineLeft:welcomeSpiel right:nil width:280 minHeight:40];
    welcomeTableBlurb.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [welcomeTable.middleLines addObject:welcomeTableBlurb];
    
    // A Login Table
    MGTableBoxStyled *loginTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    loginTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *loginTableHeading = [MGLine lineWithLeft:@"I'm already a Member!" right:nil size:CGSizeMake(280, 40)];
    loginTableHeading.font = HEADER_FONT;
    loginTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [loginTable.topLines addObject:loginTableHeading];
    
    id loginSpiel = @"If you are already a member of BowerBird, you can log in by entering your email address and your password. Simply tap this box.";
    MGLine *loginTableBlurb =[MGLine lineWithMultilineLeft:loginSpiel right:nil width:280 minHeight:40];
    loginTableBlurb.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [loginTable.middleLines addObject:loginTableBlurb];
    loginTable.onTap = ^{[self loginAuthenticationScreen];};
   
    // A Register Table
    MGTableBoxStyled *registerTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    registerTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *registerTableHeading = [MGLine lineWithLeft:@"It's my first time.." right:nil size:CGSizeMake(280, 40)];
    registerTableHeading.font = HEADER_FONT;
    registerTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [registerTable.topLines addObject:registerTableHeading];
    
    id registerSpiel = @"If you are not yet a BowerBird member, you will need to register before accessing all the fantastic features. Simply tap this box to begin. We will be gentle.";
    MGLine *registerTableBlurb = [MGLine lineWithMultilineLeft:registerSpiel right:nil width:280 minHeight:40];
    registerTableBlurb.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [registerTable.middleLines addObject:registerTableBlurb];
    registerTable.onTap = ^{[self registerAuthenticationScreen];};
    
    // A Browse Table
    MGTableBoxStyled *browseTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    MGLine *browseTableHeading = [MGLine lineWithLeft:@"Browse" right:nil size:CGSizeMake(280, 40)];
    browseTableHeading.font = HEADER_FONT;
    id browseSpiel = @"If you would like to simply look at the contributions in BowerBird without joining, take a peek";
    CoolMGButton *browseButton = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 280, 40)
                                                                 andTitle:@"Browse"
                                                                withBlock:^{[self browseScreen];}];
    [browseTable.topLines addObject:browseTableHeading];
    [browseTable.middleLines addObject:[MGLine lineWithMultilineLeft:browseSpiel right:nil width:280 minHeight:40]];
    [browseTable.bottomLines addObject:browseButton];
    
    [authenticationView.boxes addObject:userMenu];
    [authenticationView.boxes addObject:welcomeTable];
    [authenticationView.boxes addObject:loginTable];
    [authenticationView.boxes addObject:registerTable];
    //[authenticationView.boxes addObject:browseTable];
    
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}


-(void)loginAuthenticationScreen {
    [BBLog Log:@"Login pushed"];
    
    BBLoginController *loginController = [[BBLoginController alloc]init];
    
    [self.app.navController pushViewController:loginController animated:YES];
}

-(void)registerAuthenticationScreen {
    [BBLog Log:@"Register pushed"];
    
    BBRegistrationController *registrationController = [[BBRegistrationController alloc]init];
    
    [self.app.navController pushViewController:registrationController animated:YES];
}

-(void)browseScreen {
    [BBLog Log:@"Browse pushed"];
    
    // throw a call to the controller to go to browser
}



-(void)authenticatedUserLoaded {
    [BBLog Log:@"BBAuthenticationController.authenticatedUserLoaded"];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"userHasAuthenticated" object:nil];
    
    [self.app.navController popToRootViewControllerAnimated:YES];
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