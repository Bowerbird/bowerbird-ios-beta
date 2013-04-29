/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 Form to create a sighting note for a given contribution
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCreateSightingNoteController.h"
#import "BBUIControlHelper.h"
#import "SVProgressHUD.h"
#import "BBStyles.h"
#import "MGHelpers.h"
#import "BBAppDelegate.h"
#import "BBCreateSightingNoteView.h"
#import "BBSightingNoteEditDelegateProtocol.h"
#import "DWTagList.h"
#import "BBSightingNoteAddDescriptionController.h"
#import "BBSightingNoteEditDescriptionController.h"
#import "BBSightingNoteDescriptionCreate.h"
#import "BBSightingNoteTagController.h"
#import "BBSightingNoteEdit.h"
#import "BBSightingNoteCreate.h"
#import "BBJsonResponse.h"
#import "BBClassification.h"
#import "BBValidationError.h"


@implementation BBCreateSightingNoteController


#pragma mark -
#pragma mark - Member Accessors


@synthesize sightingNote = _sightingNote;


#pragma mark -
#pragma mark - Constructors


-(BBCreateSightingNoteController*)initWithSightingId:(NSString*)sightingId {
    self = [super init];
    
    _sightingNote = [[BBSightingNoteEdit alloc]initWithSightingId:sightingId];
    
    return self;
}


#pragma mark -
#pragma mark - Renderers


-(void)loadView {
    [BBLog Log:@"BBCreateSightingNoteController.loadView"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelIdentification) name:@"cancelIdentification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setClassificationForNote:) name:@"classificationSelectedForNote" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSightingNoteDescription:) name:@"sightingNoteEditDescriptionSaved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSightingNoteDescription:) name:@"sightingNoteEditDescriptionDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSightingNoteDescriptionEdit) name:@"sightingNoteEditDescriptionCancel" object:nil];
    
    // create the view for this container
    self.view = [[BBCreateSightingNoteView alloc]initWithDelegate:self andSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
}

-(void)viewWillAppear:(BOOL)animated {
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)save {
    [BBLog Log:@"BBCreateSightingController.save"];
    
    if([self validateForm]) {
        [self saveIsValid];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"Check the Validation Errors"];
    }
}

-(BOOL)validateForm {
    
    // empty the validation area of the view
    BOOL isValid = YES;
    
    if(_sightingNote.tags.count == 0 && _sightingNote.descriptions.count == 0 && ([_sightingNote.comments isEqualToString:@""] || !_sightingNote.comments)) {
        isValid = NO;
    }
    
    return isValid;
}

-(void)saveIsValid{
    
    // create a sightingNoteCreate
    BBSightingNoteCreate *postSightingNote = [[BBSightingNoteCreate alloc]init];
    postSightingNote.sightingId = _sightingNote.sightingId;
    
    __block NSString *tagsAsString;
    __block NSMutableString *stringToAppend;
    [_sightingNote.tags enumerateObjectsUsingBlock:^(NSString* obj, BOOL *stop) {
        stringToAppend = tagsAsString.length > 0 ? [NSString stringWithFormat:@", %@",obj] : obj;
        if(tagsAsString)
        {
            tagsAsString = [NSString stringWithFormat:@"%@%@", tagsAsString, stringToAppend];
        }
        else
        {
            tagsAsString = stringToAppend;
        }
    }];
    postSightingNote.tags = tagsAsString;
    postSightingNote.comments = _sightingNote.comments;
    
    NSMutableArray *descriptionObjects = [[NSMutableArray alloc]init];
    for (NSString* key in [_sightingNote.descriptions allKeys]) {
        NSString *val = [_sightingNote.descriptions objectForKey:key];
        BBSightingNoteDescriptionCreate *sightingNoteDescription = [[BBSightingNoteDescriptionCreate alloc]init];
        sightingNoteDescription.key = key;
        sightingNoteDescription.value = val;
        
        // either set as new array or make mutable..
        [descriptionObjects addObject:sightingNoteDescription];
    }
    
    postSightingNote.descriptions = descriptionObjects;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSURLRequest *request = [objectManager requestWithObject:postSightingNote
                                                      method:RKRequestMethodPOST
                                                        path:nil
                                                  parameters:nil];
    
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request
                                                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                       if([mappingResult isKindOfClass:[BBSightingNoteCreate class]]){
                                                                                           
                                                                                           if(((BBSightingNoteCreate*)mappingResult).errors != nil) {
                                                                                               NSArray *messages = ((BBSightingNoteCreate*)mappingResult).errors.messages;
                                                                                               
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
                                                                                               // Broadcast the new Sighting Note Creation.... do we display it?
                                                                                               NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                                                                                               [userInfo setObject:mappingResult forKey:@"sightingNote"];
                                                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingNoteCreated" object:self userInfo:userInfo];
                                                                                           }
                                                                                       }
                                                                                   }
                                                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error occurred submitting Sighting Note: %@", error.localizedDescription]];
                                                                                   }];
    
    [SVProgressHUD showWithStatus:@"Saving your sighting"];
}

-(void)cancel {
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

-(NSArray*)getDescriptions {
    [BBLog Log:@"BBCreateSightingNoteController.getDescriptions:"];
    
    NSMutableArray *descriptions = [[NSMutableArray alloc]init];
    
    for (NSString* key in _sightingNote.descriptions) {
        NSString* val = [_sightingNote.descriptions objectForKey:key];
        BBSightingNoteDescriptionCreate *sightingNoteDescription = [[BBSightingNoteDescriptionCreate alloc]init];
        [sightingNoteDescription setKey:key];
        [sightingNoteDescription setValue:val];
        [descriptions addObject:sightingNoteDescription];
    }
    
    return [[NSArray alloc]initWithArray:descriptions];
}

-(NSArray*)getTags {
    [BBLog Log:@"BBCreateSightingNoteController.getTags:"];
    
    if(_sightingNote.tags.count > 0){
        return [[NSArray alloc]initWithArray:[_sightingNote.tags allObjects]];
    }
    
    return nil;
}


#pragma mark -
#pragma mark - Delegation and Event Handling


// start selecting description to add, finish selecting description to add, add description, remove description
-(void)startAddDescription {
    // pop up a picker control with list of un-added descriptions
    NSMutableArray *descriptions = [[NSMutableArray alloc]init];
    // for each description in current descriptions, find source description object and add to array to exclude on picker screen.'
    for (NSString* key in _sightingNote.descriptions) {
        BBSightingNoteDescription *description = [BBSightingNoteDescription getDescriptionByIdentifier:key];
        [descriptions addObject:description];
    }
    
    BBSightingNoteAddDescriptionController *sightingNoteAddDescription = [[BBSightingNoteAddDescriptionController alloc]initWithDescriptions:[[NSArray alloc]initWithArray:descriptions]];
    
    // descriptions not added yet:
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:sightingNoteAddDescription animated:YES];
    
}

-(void)editDescription:(BBSightingNoteDescriptionCreate *)description {
    [BBLog Log:@"BBCreateSightingController.editDescription:"];
    
    BBSightingNoteEditDescriptionController *sightingNoteEditDescription = [[BBSightingNoteEditDescriptionController alloc]initWithDescriptionEdit:description];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:sightingNoteEditDescription animated:YES];
}

-(void)startAddTag {
    BBSightingNoteTagController *tagController = [[BBSightingNoteTagController alloc]initWithDelegate:self];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:tagController animated:YES];
}

-(void)endAddTag {
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popToViewController:self animated:YES];
    
    [((BBCreateSightingNoteView*)self.view) displayTags];
}

-(void)addTag:(NSString*)tag {
    [_sightingNote.tags addObject:tag];
}

-(void)removeTag:(NSString*)tag {
    [_sightingNote.tags removeObject:tag];
}

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBContainerController"];
    
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark - Notification Responders


-(void)cancelIdentification {
    [self.navigationController popToViewController:self animated:NO];
}

//-(void)setClassificationForNote:(NSNotification *) notification{
//    [self cancelIdentification];
//    
//    NSDictionary* userInfo = [notification userInfo];
//    BBClassification *classification = [userInfo objectForKey:@"classification"];
//    
//    _sightingNote.taxonomy = classification.taxonomy;
//    [((BBCreateSightingNoteView*)self.view) displayIdentification:classification];
//}

-(void)cancelSightingNoteDescriptionEdit {
    [self.navigationController popToViewController:self animated:NO];
}

-(void)saveSightingNoteDescription:(NSNotification *) notification {
    [self cancelSightingNoteDescriptionEdit];
    
    NSDictionary* userInfo = [notification userInfo];
    BBSightingNoteDescriptionCreate *sightingNoteDescription = [userInfo objectForKey:@"description"];
    
    [_sightingNote.descriptions setObject:sightingNoteDescription.value forKey:sightingNoteDescription.key];
    
    [((BBCreateSightingNoteView*)self.view) displayDescriptions];
}

-(void)removeSightingNoteDescription:(NSNotification *) notification {
    [self cancelSightingNoteDescriptionEdit];
    
    NSDictionary* userInfo = [notification userInfo];
    BBSightingNoteDescriptionCreate *sightingNoteDescription = [userInfo objectForKey:@"description"];
    
    [_sightingNote.descriptions removeObjectForKey:sightingNoteDescription.key];
    
    [((BBCreateSightingNoteView*)self.view) displayDescriptions];
}

@end