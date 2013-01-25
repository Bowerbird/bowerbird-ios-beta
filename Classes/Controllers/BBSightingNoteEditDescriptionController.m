//
//  BBSightingNoteEditDescriptionController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 12/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteEditDescriptionController.h"

/*
 Programme flow can get to this VC from two pathways: adding a new description or editing the text of an existing one.
 
 In the first instance, we have a BBSightingNoteDescription which is from the list of allowed descriptions.
 It has meta data allowing it to be grouped, labeled etc on the table of usable descriptions and a key allowing it to be identified.
 
 BBSightingNoteDescriptionCreate is the object that either gets returned from the selection of a description for editing, 
 or gets passed when a previously added description is being updated.
 
 In the first case, we start with a BBSightingNoteDescription selected from the table, we take the identifier value (key) from it,
 the text (value) from the text field entered by the user and create a BBSightingNoteDescriptionCreate object with the Key/Value pair
 which is added to the BBSightingNoteCreate model and passed back to the server. 
 
 */
@implementation BBSightingNoteEditDescriptionController {
    BBSightingNoteDescription *description;
    BBSightingNoteDescriptionCreate *editDescription;
    BOOL isEdit;
}

-(BBSightingNoteEditDescriptionController *)initWithDescription:(BBSightingNoteDescription*)desc {
    [BBLog Log:@"BBSightingNoteEditDescriptionController.initWithDescription:"];
    
    self = [super init];
    
    if(self){
        description = desc;
        isEdit = NO;
    }
    
    return self;
}

-(BBSightingNoteEditDescriptionController *)initWithDescriptionEdit:(BBSightingNoteDescriptionCreate*)editDesc {
    [BBLog Log:@"BBSightingNoteEditDescriptionController.initWithDescription:"];
    
    self = [super init];
    
    if(self){
        editDescription = editDesc;
        NSArray *allDescriptions = [BBSightingNoteDescription getSightingNoteDescriptions];
        __block BBSightingNoteDescription *relatedDesc;
        [allDescriptions enumerateObjectsUsingBlock:^(BBSightingNoteDescription *d, NSUInteger idx, BOOL *stop) {
            if (d.identifier == editDesc.key) {
                *stop = YES;
                relatedDesc = d;
            }
        }];

        description = relatedDesc;
        isEdit = YES;
    }
    
    return self;
}

-(void)loadView {
    // create the scroll view with table displaying unselected descriptions
    self.view = [MGScrollView scrollerWithSize:[UIScreen mainScreen].bounds.size];
    
    MGLine *descriptorTitle = [MGLine lineWithLeft:description.name right:nil size:CGSizeMake(300, 40)];
    descriptorTitle.underlineType = MGUnderlineNone;
    descriptorTitle.margin = UIEdgeInsetsMake(10, 10, 0, 10);
    descriptorTitle.font = HEADER_FONT;
    
    UITextView *descriptor = [BBUIControlHelper createTextViewWithFrame:CGRectMake(0, 0, 300, 240) andDelegate:self];
    descriptor.clipsToBounds = YES;
    descriptor.layer.cornerRadius = 5;
    
    MGLine *descriptorLine = [MGLine lineWithLeft:descriptor right:nil size:CGSizeMake(300, 240)];
    descriptorLine.margin = UIEdgeInsetsMake(10, 10, 0, 10);
    descriptorLine.underlineType = MGUnderlineNone;
    
    MGLine *removeButtonLine;
    if(isEdit) {
        descriptor.text = editDescription.value;

        CoolMGButton *delete = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 10, 300, 40) andTitle:@"Delete" withBlock:^{
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:editDescription forKey:@"description"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingNoteEditDescriptionDeleted" object:self userInfo:userInfo];
        }];
        
        removeButtonLine = [MGLine lineWithLeft:delete right:nil size:CGSizeMake(300, 40)];
        removeButtonLine.underlineType = MGUnderlineNone;
        removeButtonLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    CoolMGButton *done = [BBUIControlHelper createButtonWithFrame:CGRectMake(10, 10, 300, 40) andTitle:@"Save" withBlock:^{
        editDescription = [[BBSightingNoteDescriptionCreate alloc]init];
        editDescription.key = description.identifier;
        editDescription.value = descriptor.text;
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [userInfo setObject:editDescription forKey:@"description"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingNoteEditDescriptionSaved" object:self userInfo:userInfo];
    }];
    
    MGLine *doneButtonLine = [MGLine lineWithLeft:done right:nil size:CGSizeMake(300, 40)];
    doneButtonLine.underlineType = MGUnderlineNone;
    doneButtonLine.margin = UIEdgeInsetsMake(10, 10, 10, 10);

    [((MGScrollView*)self.view).boxes addObject:descriptorTitle];
    [((MGScrollView*)self.view).boxes addObject:descriptorLine];
    if(isEdit)[((MGScrollView*)self.view).boxes addObject:removeButtonLine];
    [((MGScrollView*)self.view).boxes addObject:doneButtonLine];
    
    self.view.backgroundColor = [self backgroundColor];
    
    [(MGScrollView*)self.view layout];
}

-(void)viewDidLoad{
    
    self.title = description.label;
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                   style: UIBarButtonItemStyleBordered
                                                                  target: self
                                                                  action: nil];
    
    self.navigationItem.backBarButtonItem = backButton;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action:@selector(cancelTapped)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

// stop adding/editing this description - triggers return to sighting note add
-(void)cancelTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingNoteEditDescriptionCancel" object:nil userInfo:nil];
}

// used when editing or adding to save
-(void)save {
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:editDescription forKey:@"sightingNoteDescription"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sightingNoteDescriptionSave" object:self userInfo:userInfo];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

@end