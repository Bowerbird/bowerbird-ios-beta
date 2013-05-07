/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Provides a form to enable user to enter their email and password and log in to the system
 
 -----------------------------------------------------------------------------------------------*/


#import "BBLoginController.h"
#import "BBAuthentication.h"
#import "BBAuthenticatedUser.h"
#import "BBAppDelegate.h"
#import "BBUIControlHelper.h"
#import "BBStyles.h"
#import "SVProgressHUD.h"
#import "BBLoginRequest.h"


#define ROW_SIZE                    (CGSize){264, 44}
#define TEXT_FIELD_SIZE             (CGSize){50, 30}
#define BTN_SIZE                    (CGSize){50, 30}


@interface BBLoginController()

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, weak) UITextField *emailField, *passwordField;
-(void)scrollViewToTextField:(id)textField;

@end


@implementation BBLoginController {
    MGScrollView *loginView;
}


#pragma mark -
#pragma mark - Member Accessors


@synthesize  keyboardControls = _keyboardControls,
             emailField = _emailField,
             passwordField = _passwordField;


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBLoginController.loadView"];
    
    self.view = [MGScrollView scrollerWithSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
    
    // triggered once user has successfully signed in or registered
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAuthenticatedUser:)
                                                 name:@"userAuthenticated"
                                               object:nil];
    
    ((MGScrollView*)self.view).contentLayoutMode = MGLayoutTableStyle;
    loginView = (MGScrollView*)self.view;
}

-(void)viewDidLoad {
    [BBLog Log:@"BBLoginController.viewDidLoad"];
    
    [super viewDidLoad];
    
    [self displayViewControls];
    [self setupKeyboardResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [BBLog Log:@"BBLoginController.viewWillAppear"];

    self.title = @"Sign In";
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
}

-(void)displayViewControls {
    [BBLog Log:@"BBLoginController.displayViewControls"];
    
    MGTableBoxStyled *loginTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,100)];
    loginTable.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    MGLine *loginTableHeading = [MGLine lineWithLeft:@"Log In" right:nil size:CGSizeMake(280, 40)];
    loginTableHeading.font = HEADER_FONT;
    loginTableHeading.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [loginTable.topLines addObject:loginTableHeading];
    
    // email
    _emailField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                               andPlaceholder:@"Email address"
                                                  andDelegate:self];
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    MGLine *emailLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [emailLine.middleItems addObject:_emailField];
    emailLine.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [loginTable.middleLines addObject:emailLine];
    
    // password
    _passwordField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40)
                                                  andPlaceholder:@"Password"
                                                     andDelegate:self];
    
    _passwordField.secureTextEntry = YES;
    MGLine *passwordLine = [MGLine lineWithSize:CGSizeMake(280, 60)];
    [passwordLine.middleItems addObject:_passwordField];
    [loginTable.middleLines addObject:passwordLine];
    
    
    // buttons
    CoolMGButton *signInBtn = [BBUIControlHelper createButtonWithFrame:CGRectMake(0,0,280,40)
                                                              andTitle:@"Log Me In"
                                                             withBlock:^{[self signIn];}];
    
    MGLine *buttonLine = [MGLine lineWithLeft:signInBtn right:nil size:CGSizeMake(280, 40)];
    [loginTable.bottomLines addObject:buttonLine];
    
    [loginView.boxes addObject:loginTable];
    [(MGScrollView*)self.view layoutWithSpeed:0.3 completion:nil];
}


#pragma mark -
#pragma mark - Data Loading Utilities and Helpers


-(void)signIn {
    
    [BBLog Log:@"BBLoginController.signIn"];
    
    BBLoginRequest *loginRequest = [[BBLoginRequest alloc]initWithEmail:self.emailField.text
                                                               password:self.passwordField.text];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSURLRequest *request = [objectManager requestWithObject:loginRequest
                                                      method:RKRequestMethodPOST
                                                        path:@"/account/login"
                                                  parameters:nil];
    
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                       if([mappingResult.firstObject isKindOfClass:[BBAuthentication class]]){
                                                                                           BBAuthentication *authentication = [mappingResult firstObject];
                                                                                           
                                                                                           NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                                                                                           [userInfo setObject:authentication forKey:@"authenticatedUser"];
                                                                                           
                                                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"userAuthenticated" object:self userInfo:userInfo];
                                                                                           
                                                                                           [BBLog Log:authentication];
                                                                                       }
                                                                                       else {
                                                                                           [SVProgressHUD showErrorWithStatus:@"No dice bro."];
                                                                                           [BBLog Log:[NSString stringWithFormat:@"ERROR: %@", @"Server didn't return user profile."]];
                                                                                       }
                                                                                   }
                                                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       [SVProgressHUD showErrorWithStatus:@"Could not log you in"];
                                                                                       [BBLog Log:[NSString stringWithFormat:@"ERROR: %@", error.localizedDescription]];
                                                                                   }];
    
    [operation start];
    
    [SVProgressHUD showWithStatus:@"Logging you in"];
}

-(void)loadAuthenticatedUser:(NSNotification *) notification {
    
    [BBLog Log:@"BBLoginController.loadAutheticatedUser:"];
    
    NSDictionary* userInfo = [notification userInfo];
    
    BBAuthentication *authenticatedUser = [userInfo objectForKey:@"authenticatedUser"];
    [BBLog Log:authenticatedUser];
    
    [SVProgressHUD showWithStatus:@"Loading your profile"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[BBConstants AuthenticatedUserProfileRoute]
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  // this ma-fcuker is a what??
                                                  [BBLog Log:mappingResult];
                                                  
                                                  if([mappingResult.firstObject isKindOfClass:[BBAuthenticatedUser class]]){
                                                      BBApplication *app = [BBApplication sharedInstance];
                                                      app.authenticatedUser = mappingResult.firstObject;
                                                  }
                                                  
                                                  [SVProgressHUD showSuccessWithStatus:@"Welcome Back!"];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"userHasAuthenticated" object:nil userInfo:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [BBLog Log:[NSString stringWithFormat:@"ERROR loading authenticatedUser profile: %@", error.localizedDescription]];
                                                  [SVProgressHUD showErrorWithStatus:@"Could not log you in"];
                                              }];
}

-(void)cancelSignIn {
    [BBLog Log:@"BBLoginController.cancelSignIn"];
    
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    
    [self.navigationController popViewControllerAnimated:NO];
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
    self.keyboardControls.textFields = [NSArray arrayWithObjects:
                                        _emailField,
                                        _passwordField,
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
}

-(void)dealloc {
    [self cancelSignIn];
}


@end