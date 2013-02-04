/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Container VC to create an identification for a contribution. Can branch from this controller 
 to a Browse screen or a Search screen which queries the API species list
 
 -----------------------------------------------------------------------------------------------*/


#import "BBIdentifySightingController.h"
#import "BBIdentifySightingEdit.h"
#import "BBIdentifySightingView.h"
#import "BBClassificationSearchController.h"
#import "BBClassificationBrowseController.h"
#import "BBJsonResponse.h"


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


-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBCreateSightingNoteController.objectLoaderDidFailWithError:"];
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    // is it a JsonResponse?
    if([object isKindOfClass:[BBJsonResponse class]]) {
        BBJsonResponse *response = (BBJsonResponse*)object;
        
        if(response.success) {
            [SVProgressHUD showSuccessWithStatus:@"Saved"];
            
            [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:NO];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"Didn't save"];
        }
    }
    
    [SVProgressHUD showSuccessWithStatus:@"Saved Note!/n(But didn't Map Result)"];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

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

/*
-(void)createClassification {
    BBClassificationCreateController *createController = [[BBClassificationCreateController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:createController
                                                                                           animated:YES];
}
*/

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
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    // do UI stuff back in UI land
    //dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Saving Identification"]];
    //});

    [manager postObject:identify delegate:self];
    
    /*
    [manager postObject:identify
             usingBlock:^(RKObjectLoader *loader)
    {
        // map native object to dictionary of key values
        RKObjectMapping *map = [[manager mappingProvider] serializationMappingForClass:[BBIdentifySightingEdit class]];
        NSError *error = nil;
        NSDictionary *d = [[RKObjectSerializer serializerWithObject:identify mapping:map] serializedObject:&error];
        
        // convert key value dictionary to json data object
        NSError *e;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:d options:0 error:&e];
        
        // convert json data object to a string
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        loader.params = [RKRequestSerialization serializationWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON];
        loader.delegate = self;
    }];
     */
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