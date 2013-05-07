/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Allows non-members to sign up. Also processes a secondary authentication.
 
 -----------------------------------------------------------------------------------------------*/


#import "BBRegistrationController.h"
#import "BBUIControlHelper.h"
#import "BBStyles.h"
#import "BBAuthenticatedUser.h"
#import "BBAuthentication.h"
#import "BBAppDelegate.h"
#import "BBRegisterRequest.h"


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


#pragma mark -
#pragma mark - Member Accessors


@synthesize keyboardControls = _keyboardControls,
            textName = _textName,
            textEmail = _textEmail,
            textPassword = _textPassword,
            textConfirmPassword = _textConfirmPassword;


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBRegistrationController.loadView"];
    
    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAuthenticatedUser:)
                                                 name:@"userAuthenticated"
                                               object:nil];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    self.view.backgroundColor = [self backgroundColor];
    registrationView = (MGScrollView*)self.view;
}

-(void)viewDidLoad {
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

    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    self.title = @"Register";
}

-(void)displayViewControls {
    [BBLog Log:@"BBRegistrationController.displayViewControls"];
    
    MGTableBoxStyled *registrationTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    registrationTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *registrationTableHeading = [MGLine lineWithLeft:@"Register" right:nil size:CGSizeMake(280, 40)];
    registrationTableHeading.font = HEADER_FONT;
    registrationTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [registrationTable.topLines addObject:registrationTableHeading];
    
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
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)registerUser {
    [BBLog Log:@"BBRegistrationController.registerUser"];
    
    BBRegisterRequest *registerRequest = [[BBRegisterRequest alloc] initWithEmail:self.textEmail.text
                                                                         password:self.textPassword.text
                                                                             name:self.textName.text];
                                          
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSURLRequest *request = [objectManager requestWithObject:registerRequest
                                                      method:RKRequestMethodPOST
                                                        path:@"/account/register"
                                                  parameters:nil];
    
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                       if([mappingResult isKindOfClass:[BBAuthentication class]]){
                                                                                           NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                                                                                           [userInfo setObject:mappingResult forKey:@"authenticatedUser"];
                                                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAuthenticatedUser" object:self userInfo:userInfo];
                                                                                       }
                                                                                   }
                                                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       [SVProgressHUD showErrorWithStatus:@"Could not register you"];
                                                                                       [BBLog Log:[NSString stringWithFormat:@"ERROR Registering: %@", error.localizedDescription]];
                                                                                   }];
    
    [operation start];
    
    [SVProgressHUD showWithStatus:@"Registering you"];
}

-(void)loadAuthenticatedUser:(NSNotification *) notification {
    
    NSDictionary* userInfo = [notification userInfo];
    BBAuthentication *authenticatedUser = [userInfo objectForKey:@"authenticatedUser"];
    
    [SVProgressHUD showWithStatus:@"Loading your profile"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[BBConstants AuthenticatedUserProfileUrl]
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [SVProgressHUD showSuccessWithStatus:@"Welcome to BowerBird!"];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasAuthenticated" object:nil userInfo:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [SVProgressHUD showErrorWithStatus:@"Could not log you in"];
                                              }];
}

-(void)cancelRegisterUser {
    [BBLog Log:@"BBRegistrationController.cancelRegisterUser"];
    
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
}

-(void)keyboardControlsDonePressed:(BSKeyboardControls *)controls {
    [controls.activeTextField resignFirstResponder];
}

-(void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls
                              withDirection:(KeyboardControlsDirection)direction
                         andActiveTextField:(id)textField {
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}

-(void)scrollViewToTextField:(id)textField {
    MGLine *textFieldLine = (MGLine*)((UITextField*)textField).superview;

    [((MGScrollView*)self.view) scrollToView:textFieldLine withMargin:8];
}

-(void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBRegistrationController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [self cancelRegisterUser];
}


@end