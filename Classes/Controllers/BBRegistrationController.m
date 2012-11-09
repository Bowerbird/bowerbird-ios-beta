//
//  BBRegistrationController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBRegistrationController.h"

@implementation BBRegistrationController {
    UITextField *emailField, *nameField, *passwordField, *passwordConfirmField;
    BBAuthenticatedUser *authenticatedUser;
    BBAuthentication *auth;
    BBRegistrationView *registrationView;
}


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBRegistrationController.loadView"];
    
    self.view = [[BBRegistrationView alloc]initWithSize:[UIScreen mainScreen].bounds.size];
    registrationView = (BBRegistrationView*)self.view;
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [BBLog Log:@"BBRegistrationController.viewDidLoad"];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerUser)
                                                 name:@"submitRegistrationTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelRegisterUser)
                                                 name:@"cancelRegistrationTapped"
                                               object:nil];
    
    [self displayViewControls];
}


-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBRegistrationController.viewWillAppear"];

    self.app.navController.navigationBarHidden = NO;
    self.title = @"Register";
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayViewControls {
    [BBLog Log:@"BBRegistrationController.displayViewControls"];
    
    MGTableBoxStyled *registrationTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    registrationTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *registrationTableHeading = [MGLine lineWithLeft:@"Register" right:nil size:CGSizeMake(280, 40)];
    registrationTableHeading.font = HEADER_FONT;
    registrationTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [registrationTable.topLines addObject:registrationTableHeading];
    
    // spiel
    NSString *spielText = @"Iphone wayfarers post-ironic banksy. Typewriter authentic lomo tofu cred. Twee shoreditch seitan small batch, 3 wolf moon freegan odd future wayfarers squid occupy scenester leggings letterpress. +1 pickled readymade flexitarian viral hoodie. Master cleanse next level butcher semiotics, bespoke Austin tumblr vice skateboard jean shorts american apparel. Iphone synth vinyl fanny pack street art trust fund leggings godard, shoreditch mumblecore ennui butcher swag master cleanse. Vinyl etsy jean shorts gastropub iphone wolf, put a bird on it truffaut mixtape gentrify";
    MGLine *spiel = [MGLine lineWithMultilineLeft:spielText right:nil width:280 minHeight:40];
    [registrationTable.middleLines addObject:spiel];
    
    // name
    nameField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                              andPlaceholder:@"Name"
                                                 andDelegate:self];
    
    MGLine *nameLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [nameLine.middleItems addObject:nameField];
    nameLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [registrationTable.middleLines addObject:nameLine];
    
    
    // email
    emailField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                              andPlaceholder:@"Email address"
                                                 andDelegate:self];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    MGLine *emailLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [emailLine.middleItems addObject:emailField];
    emailLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [registrationTable.middleLines addObject:emailLine];

    // password
    passwordField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
    andPlaceholder:@"Password"
    andDelegate:self];

    passwordField.secureTextEntry = YES;
    MGLine *passwordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [passwordLine.middleItems addObject:passwordField];
    [registrationTable.middleLines addObject:passwordLine];
    
    // confirm password
    passwordConfirmField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                                 andPlaceholder:@"Confirm Password"
                                                    andDelegate:self];
    
    passwordField.secureTextEntry = YES;
    MGLine *confirmPasswordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [confirmPasswordLine.middleItems addObject:passwordConfirmField];
    [registrationTable.middleLines addObject:confirmPasswordLine];

    // buttons
    CoolMGButton *signInBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0,0,280,40)
                                                              andTitle:@"Register Me"
                                                             withBlock:^{[self registerUser];}];
    
    MGLine *buttonLine = [MGLine lineWithLeft:signInBtn right:nil size:CGSizeMake(280, 40)];
    [registrationTable.bottomLines addObject:buttonLine];
    
    [registrationView.boxes addObject:registrationTable];
    [(BBRegistrationView*)self.view layoutWithSpeed:0.3 completion:nil];
}


-(void)registerUser {
    [BBLog Log:@"BBRegistrationController.registerUser"];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"submitRegistrationTapped" object:nil];
}


-(void)cancelRegisterUser {
    [BBLog Log:@"BBRegistrationController.cancelRegisterUser"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBRegistrationController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end