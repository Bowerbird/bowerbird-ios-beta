//
//  BBIdentificationController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 4/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBCreateSightingNoteController.h"
#import "NSString+RKAdditions.h"

@interface BBCreateSightingNoteController ()

@end

@implementation BBCreateSightingNoteController

@synthesize sightingNote = _sightingNote;


#pragma mark -
#pragma mark - Setup and Render

-(BBCreateSightingNoteController*)initWithSightingId:(NSString*)sightingId {
    self = [super init];
    
    _sightingNote = [[BBSightingNoteEdit alloc]initWithSightingId:sightingId];
    
    return self;
}

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
#pragma mark - Protocol Impementations

-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    [BBLog Log:@"BBCreateSightingNoteController.objectDidLoadUnexpectedResponse:"];
    
    [BBLog Log:objectLoader.response.bodyAsString];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBCreateSightingNoteController.objectLoaderDidFailWithError:"];
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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

-(void)endAddDescription {
    // hide picker popup but add selected item to view for filling in value
}

// add key/value description pair to the model's description dictionary
-(void)addDescription:(BBSightingNoteDescription *)description {
    //[_sightingNote.descriptions setObject:description.text forKey:description.label];
}

-(void)editDescription:(BBSightingNoteDescriptionCreate *)description {
    [BBLog Log:@"BBSightingEditController.editDescription:"];
    
    BBSightingNoteEditDescriptionController *sightingNoteEditDescription = [[BBSightingNoteEditDescriptionController alloc]initWithDescriptionEdit:description];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:sightingNoteEditDescription animated:YES];
}

-(void)removeDescription:(BBSightingNoteDescription *)description {
    // TODO:
}

-(void)startAddTag {
    BBSightingNoteTagController *tagController = [[BBSightingNoteTagController alloc]initWithDelegate:self];
    
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:tagController animated:YES];
}

-(void)endAddTag {
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popToViewController:self animated:YES];
    
    [((BBCreateSightingNoteView*)self.view) displayTags];
}

// add a tag, remove a tag
-(void)addTag:(NSString*)tag {
    [_sightingNote.tags addObject:tag];
    // update the View's UI
}

-(void)removeTag:(NSString*)tag {
    [_sightingNote.tags removeObject:tag];
    // update the View's UI
}

#pragma mark -
#pragma mark - Save or Cancel Observation

-(void)save {
    [BBLog Log:@"BBSightingEditController.save"];
    
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
    
    if(_sightingNote.tags.count == 0 && _sightingNote.descriptions.count == 0 && ([_sightingNote.taxonomy isEqualToString:@""] || !_sightingNote.taxonomy)) {
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
    postSightingNote.taxonomy = _sightingNote.taxonomy;
    
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
        
    // post this data to the server. On Success, pop this biatch off the stack.
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Saving Sighting Note"]];

    [manager postObject:postSightingNote delegate:self];
    
    /*
    [manager postObject:postSightingNote usingBlock:^(RKObjectLoader *loader) {
        loader.delegate = self;
        loader.method = RKRequestMethodPOST;
        loader.params = [BBConstants AjaxRequestParams];
        NSString *encodedUrl = [postSightingNote.sightingId stringByReplacingURLEncoding];
        loader.resourcePath = [NSString stringWithFormat:@"/%@/createnote", encodedUrl];
    }];
    */
    
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
#pragma mark - Notification Responders

-(void)cancelIdentification {
    [self.navigationController popToViewController:self animated:NO];
}

-(void)setClassificationForNote:(NSNotification *) notification{
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBClassification *classification = [userInfo objectForKey:@"classification"];
    
    _sightingNote.taxonomy = classification.taxonomy;
    [((BBCreateSightingNoteView*)self.view) displayIdentification:classification];
}

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