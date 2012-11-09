//
//  BBLoginController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBLoginController.h"

#define ROW_SIZE                    (CGSize){264, 44}
#define TEXT_FIELD_SIZE             (CGSize){50, 30}
#define BTN_SIZE                    (CGSize){50, 30}

@implementation BBLoginController {
    UITextField *emailField, *passwordField;
    BBAuthenticatedUser *authenticatedUser;
    BBAuthentication* auth;
    BBLoginView *loginView;
}


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBLoginController.loadView"];
    
    self.view = [[BBLoginView alloc]initWithSize:[UIScreen mainScreen].bounds.size];
    loginView = (BBLoginView*)self.view;
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
}


-(void)viewDidLoad {
    [BBLog Log:@"BBLoginController.viewDidLoad"];
    
    [super viewDidLoad];
    
    [self displayViewControls];
}


-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBLoginController.viewWillAppear"];
    
    self.app.navController.navigationBarHidden = NO;
    self.title = @"Sign In";
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)displayViewControls {
    [BBLog Log:@"BBLoginController.displayViewControls"];

    MGTableBoxStyled *loginTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    loginTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *loginTableHeading = [MGLine lineWithLeft:@"Log In" right:nil size:CGSizeMake(280, 40)];
    loginTableHeading.font = HEADER_FONT;
    loginTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [loginTable.topLines addObject:loginTableHeading];
    
    // email
    emailField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                              andPlaceholder:@"Email address"
                                                 andDelegate:self];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    MGLine *emailLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [emailLine.middleItems addObject:emailField];
    emailLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [loginTable.middleLines addObject:emailLine];
    
    // password
    passwordField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                                 andPlaceholder:@"Password"
                                                    andDelegate:self];
    
    passwordField.secureTextEntry = YES;
    MGLine *passwordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [passwordLine.middleItems addObject:passwordField];
    [loginTable.middleLines addObject:passwordLine];
    
    
    // buttons
    CoolMGButton *signInBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0,0,280,40)
                                                              andTitle:@"Log Me In"
                                                             withBlock:^{[self signIn];}];
    
    MGLine *buttonLine = [MGLine lineWithLeft:signInBtn right:nil size:CGSizeMake(280, 40)];
    [loginTable.bottomLines addObject:buttonLine];
    
    [loginView.boxes addObject:loginTable];
    [(BBLoginView*)self.view layoutWithSpeed:0.3 completion:nil];
}


-(void)signIn {
    [BBLog Log:@"BBLoginController.signIn"];
    
    NSString* email = emailField.text;
    NSString* password = passwordField.text;
    
    [BBLog Log:[NSString stringWithFormat:@"Attempting login with email: %@ and password %@", email, password]];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"true" forKey:@"rememberme"];
    [params setObject:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    
    [[RKClient sharedClient] post:@"/account/login" params:params delegate:self];
}


-(void)cancelSignIn {
    [BBLog Log:@"BBLoginController.cancelSignIn"];
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [BBLog Log:@"BBLoginController.request:didLoadResponse"];
    
    if ([request isPOST]) // Login Attempt
    {
        [self getUserProfileFromLoginRequest:response];
    }
    else if ([request isGET]) // Load Profile
    {
        [self setUserFromProfileResponse:response];
    }
}


-(void)getUserProfileFromLoginRequest:(RKResponse*)response {
    [BBLog Log:@"BBLoginController.getUserProfileFromLoginRequest"];
    
    if ([response isOK] && [response isJSON])
    {
        NSError* error = nil;
        id obj = [response parsedBody:&error];
        
        //RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthentication class]];
        RKObjectMapping *authenticationMap = [RKObjectMapping mappingForClass:[BBAuthentication class]];
        id mappedObject = [authenticationMap mappableObjectForData:obj];
        
        //id mappedObject = [authenticationMap mappableObjectForData:obj];
        // we have authenticated and are set to pull down the user's profile
        
        if([mappedObject isKindOfClass:[BBAuthentication class]] && mappedObject != nil)
        {
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                              delegate:self];
        }
    }
}


-(void)setUserFromProfileResponse:(RKResponse*)response {
    [BBLog Log:@"BBLoginController.setUserFromProfileResponse"];
    
    if ([response isOK] && [response isJSON])
    {
        //NSError* error = nil;
        //id obj = [response parsedBody:&error];
        //RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthenticatedUser class]];
        
        id obj = [response bodyAsString];
        RKObjectMapping *authenticationMap = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
        
        id mappedObject = [authenticationMap mappableObjectForData:obj];
        
        // we now have the user's profile - send to delegate method for system setup
        if([mappedObject isKindOfClass:[BBAuthenticatedUser class]])
        {
            authenticatedUser = (BBAuthenticatedUser*)mappedObject;
        }
    }
}


// TODO: This is potentially the handler for all RestKit activity
-(void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBLoginController.objectLoader:didLoadObject"];
    
    if([object isKindOfClass:[BBUser class]])
    {
        self.app.appData.user = (BBUser*)object;
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                          delegate:self];
    }
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        // TODO: Get the mappings for Authenticated User working for the menu items et al.
        
        BBApplication *appData = [BBApplication sharedInstance];
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        [appData.connection start];
        
        //[self performSelector:@selector(segueToLoadActivity)withObject:self afterDelay:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticatedUserLoaded" object:nil];
    }
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Error:[NSString stringWithFormat:@"%@%@", @"BBLoginController.objectLoader:didFailWithError:", [error localizedDescription]]];
}


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBRegistrationController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end