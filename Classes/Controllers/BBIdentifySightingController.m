/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Container VC to create an identification for a contribution. Can branch from this controller 
 to a Browse screen or a Search screen which queries the API species list
 
 -----------------------------------------------------------------------------------------------*/


#import <RestKit/RestKit.h>
#import "BBIdentifySightingController.h"
#import "BBIdentifySightingEdit.h"
#import "BBIdentifySightingView.h"
#import "BBClassificationSearchController.h"
#import "BBClassificationBrowseController.h"
#import "BBJsonResponse.h"
#import "BBValidationError.h"
#import "SVProgressHUD.h"


@interface BBIdentifySightingController()

@property (nonatomic, strong) BBIdentifySightingEdit *identification;

@end


@implementation BBIdentifySightingController


#pragma mark -
#pragma mark - Member Accessors


@synthesize identification = _identification;


#pragma mark -
#pragma mark - Constructors


-(BBIdentifySightingController*)initWithSightingId:(NSString*)sightingId {
    [BBLog Log:@"BBIdentifySightingController.initWithSightingId:"];
    
    self = [super init];
    
    if(self){
        _identification = [[BBIdentifySightingEdit alloc]initWithSightingId:sightingId];
    }
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBIdentifySightingController.loadView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelIdentification)
                                                 name:@"cancelIdentification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setClassification:)
                                                 name:@"identificationSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCustomIdentification:)
                                                 name:@"customIdentificationSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveIdentification:)
                                                 name:@"saveIdentification" object:nil];
    
    self.view = [[BBIdentifySightingView alloc]initWithDelegate:self
                                                        andSize:[self screenSize]];
    
    self.view.backgroundColor = [self backgroundColor];
}


#pragma mark - 
#pragma mark - Delegates and Event Handlers


-(void)searchClassifications {
    BBClassificationSearchController *searchController = [[BBClassificationSearchController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:searchController
                                                                                           animated:YES];
}

-(void)browseClassifications {
    BBClassificationBrowseController *browseController = [[BBClassificationBrowseController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:browseController
                                                                                           animated:YES];
}

-(void)removeClassification {
    // clear the taxonomy
    // tell the view to clear the classification display box
}

-(void)save {
    
    // create a sightingNoteCreate
    BBIdentifySightingEdit *identify = [[BBIdentifySightingEdit alloc]init];
    identify.sightingId = _identification.sightingId;
    identify.taxonomy = _identification.taxonomy;
    identify.isCustomIdentification = NO;
    
    // do the actual saving..
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSURLRequest *request = [objectManager requestWithObject:identify
                                                      method:RKRequestMethodPOST
                                                        path:nil
                                                  parameters:nil];
    
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                       if([mappingResult isKindOfClass:[BBIdentifySightingEdit class]]){
                                                                                           
                                                                                           if(((BBIdentifySightingEdit*)mappingResult).errors != nil) {
                                                                                               NSArray *messages = ((BBIdentifySightingEdit*)mappingResult).errors.messages;
                                                                                               
                                                                                               [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                                   [BBLog Log:obj];
                                                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Error:"
                                                                                                                                                   message:obj
                                                                                                                                                  delegate:nil
                                                                                                                                         cancelButtonTitle:@"OK"
                                                                                                                                         otherButtonTitles:nil];
                                                                                                   [alert show];
                                                                                               }];
                                                                                           }
                                                                                           else {
                                                                                               // SUCCESS
                                                                                               [SVProgressHUD showSuccessWithStatus:@"Saving your identification"];
                                                                                               
                                                                                               // Broadcast the new Identification.... do we display it?
                                                                                               NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                                                                                               [userInfo setObject:mappingResult forKey:@"identification"];
                                                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"identificationCreated" object:self userInfo:userInfo];
                                                                                           }
                                                                                       }
                                                                                   }
                                                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error occurred submitting the Identification: %@", error.localizedDescription]];
                                                                                   }];
    
    [SVProgressHUD showWithStatus:@"Saving your identification"];
}

-(void)cancel {
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - Notification Responders


-(void)cancelIdentification {
    [self.navigationController popToViewController:self animated:NO];
}

-(void)setClassification:(NSNotification *) notification {
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBClassification *classification = [userInfo objectForKey:@"classification"];
    
    _identification.taxonomy = classification.taxonomy;
    [((BBIdentifySightingView*)self.view) displayIdentification:classification];
}

-(void)setCustomIdentification:(NSNotification *) notification {
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBIdentifySightingEdit *identification = [[BBIdentifySightingEdit alloc]init];
    [identification setCustomIdentification:[userInfo objectForKey:@"customIdentification"]];
}


@end