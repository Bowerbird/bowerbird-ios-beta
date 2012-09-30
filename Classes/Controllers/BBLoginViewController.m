/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBLoginViewController.h"

@interface BBLoginViewController ()
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@end

@implementation BBLoginViewController

@synthesize email = _email;
@synthesize password = _password;


#pragma mark -
#pragma mark - UI Activity

-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)userEmailAddress:(UITextField *)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.userEmailAddress:");
    
    self.email = sender.text;
    
    if([BBConstants Trace]) NSLog(@"User entered email: %@", self.email);
}

- (IBAction)userPassword:(UITextField *)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.userPassword:");
    
    self.password = sender.text;
    
    if([BBConstants Trace]) NSLog(@"User entered email: %@", self.password);
}

- (IBAction)logUserIn:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.logUserIn:");
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:self.email forKey:@"email"];
    [params setObject:self.password forKey:@"password"];
    [params setObject:@"true" forKey:@"rememberme"];
    [params setObject:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    
    [[RKClient sharedClient] post:@"/account/login" params:params delegate:self];
}


#pragma mark -
#pragma mark - RESTful Activity

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) // Load Profile
    {
        if ([response isOK] && [response isJSON])
        {
            NSError* error = nil;
            id obj = [response parsedBody:&error];
            
            RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthenticatedUser class]];
            
            id mappedObject = [authenticationMap mappableObjectForData:obj];
            
            if([mappedObject isKindOfClass:[BBAuthenticatedUser class]])
            {
                BBApplicationData* appData = [BBApplicationData sharedInstance];
                
                appData.authenticatedUser = (BBAuthenticatedUser*)mappedObject;
                
                [self performSelector:@selector(segueToLoadActivity)withObject:self afterDelay:1];
            }
        
        }
    }
    else if ([request isPOST]) // Login Attempt
    {
        if ([response isOK] && [response isJSON])
        {   
            NSError* error = nil;
            id obj = [response parsedBody:&error];
            
            RKObjectMapping *authenticationMap = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[BBAuthentication class]];
            
            id mappedObject = [authenticationMap mappableObjectForData:obj];

            if([mappedObject isKindOfClass:[BBAuthentication class]])
            {
                BBAuthentication* auth = (BBAuthentication*)mappedObject;
                
                BBApplicationData* appData = [BBApplicationData sharedInstance];
                
                appData.user = auth.authenticatedUser;
                
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                                  delegate:self];
            }
        }
    }
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
    if([BBConstants Trace])NSLog(@"Object Response: %@", object);
    
    if([object isKindOfClass:[BBUser class]])
    {
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        
        appData.user = (BBUser*)object;

        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[BBConstants AuthenticatedUserProfileUrl], [BBConstants AjaxQuerystring]]
                                                          delegate:self];
    }
    
    if([object isKindOfClass:[BBAuthenticatedUser class]])
    {
        BBApplicationData* appData = [BBApplicationData sharedInstance];
        
        appData.authenticatedUser = (BBAuthenticatedUser*)object;
        
        // connect said user to the user hub for notifications
        BBUserHubClient* userHub = [BBUserHubClient sharedInstance];
        [userHub connectToUserHub:appData.authenticatedUser.user.identifier];
        
        [self performSelector:@selector(segueToLoadActivity)withObject:self afterDelay:1];
    }
}

- (void) objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray *)objects
{
    if([BBConstants Trace])NSLog(@"Objects Response: %@", objects);
    
}

-(void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if([BBConstants Trace])NSLog(@"Error Response: %@", [error localizedDescription]);
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader
{
    if([BBConstants Trace])NSLog(@"Unexpected Response: %@", objectLoader.response.bodyAsString);
}



#pragma mark -
#pragma mark - Navigation Activity

-(void)segueToLoadActivity
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.segueToHome");
    
    [self performSegueWithIdentifier:@"LoadActivity" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.prepareForSegue:sender:");
    
    if([segue.identifier isEqualToString:@"LoadActivity"])
    {
        // set up data if req'd
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([BBConstants Trace]) NSLog(@"LoginViewController.shouldAutoRotateToInterfaceOrientation:");
    
    return YES;
}

@end