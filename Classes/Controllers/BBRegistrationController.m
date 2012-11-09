//
//  BBRegistrationController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBRegistrationController.h"

@interface BBRegistrationController()

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, weak) UITextField *textName, *textEmail, *textPassword, *textConfirmPassword;

-(void)scrollViewToTextField:(id)textField;

@end


@implementation BBRegistrationController {
    UITextField *emailField, *nameField, *passwordField, *passwordConfirmField;
    BBAuthenticatedUser *authenticatedUser;
    BBAuthentication *auth;
    MGScrollView *registrationView;
}


@synthesize keyboardControls = _keyboardControls,
                    textName = _textName,
                   textEmail = _textEmail,
                textPassword = _textPassword,
         textConfirmPassword = _textConfirmPassword;


#pragma mark -
#pragma mark - Setup and Render


-(void)loadView {
    [BBLog Log:@"BBRegistrationController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    self.view.backgroundColor = [self backgroundColor];
    registrationView = (MGScrollView*)self.view;
    
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
    [self setupKeyboardResponder];
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
    _textName = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                              andPlaceholder:@"Name"
                                                 andDelegate:self];
    
    MGLine *nameLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [nameLine.middleItems addObject:_textName];
    nameLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [registrationTable.middleLines addObject:nameLine];
    
    
    // email
    _textEmail = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                              andPlaceholder:@"Email address"
                                                 andDelegate:self];
    _textEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
    MGLine *emailLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [emailLine.middleItems addObject:_textEmail];
    emailLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [registrationTable.middleLines addObject:emailLine];

    // password
    _textPassword = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
    andPlaceholder:@"Password"
    andDelegate:self];

    _textPassword.secureTextEntry = YES;
    MGLine *passwordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [passwordLine.middleItems addObject:_textPassword];
    [registrationTable.middleLines addObject:passwordLine];
    
    // confirm password
    _textConfirmPassword = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                                 andPlaceholder:@"Confirm Password"
                                                    andDelegate:self];
    
    _textConfirmPassword.secureTextEntry = YES;
    MGLine *confirmPasswordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [confirmPasswordLine.middleItems addObject:_textConfirmPassword];
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
    
    NSString* email = _textEmail.text;
    NSString* password = _textPassword.text;
    NSString* name = _textName.text;
    
    [BBLog Log:[NSString stringWithFormat:@"Attempting login with email: %@ and password %@", email, password]];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:name forKey:@"name"];
    [params setObject:@"true" forKey:@"rememberme"];
    [params setObject:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    
    [[RKClient sharedClient] post:@"/account/register" params:params delegate:self];
}


-(void)cancelRegisterUser {
    [BBLog Log:@"BBRegistrationController.cancelRegisterUser"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark BSKeyboardControls Delegate


-(void)setupKeyboardResponder {
    
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:_textName,
                                        _textEmail,
                                        _textPassword,
                                        _textConfirmPassword,
                                        nil];
    
    // Add the keyboard control as accessory view for all of the text fields
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    for (id textField in self.keyboardControls.textFields)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            ((UITextField *) textField).inputAccessoryView = self.keyboardControls;
            ((UITextField *) textField).delegate = self;
        }
    }
    
    // Also set the delegate of all the text fields to self
    [self.keyboardControls reloadTextFields];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
}


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}


- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}


- (void)scrollViewToTextField:(id)textField
{
    MGLine *textFieldLine = (MGLine*)((UITextField*)textField).superview;

    [((MGScrollView*)self.view) scrollToView:textFieldLine withMargin:8];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [BBLog Log:@"BBLoginController.request:didLoadResponse"];
    
    if ([request isPOST]) // Register Attempt
    {
        [self getUserProfileFromRegisterRequest:response];
    }
    else if ([request isGET]) // Load Profile
    {
        [self setUserFromProfileResponse:response];
    }
}


-(void)getUserProfileFromRegisterRequest:(RKResponse*)response {
    [BBLog Log:@"BBRegisterController.getUserProfileFromRegisterRequest"];
    
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