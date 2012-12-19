//
//  BBSightingNoteTagController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 17/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteTagController.h"

@interface BBSightingNoteTagController ()

@end

@implementation BBSightingNoteTagController {
    UITextField *tagTextField;
    NSMutableArray *tags;
    MGBox *tagBox;
    MGTableBoxStyled *tagInstructionBox;
}

@synthesize controller = _controller;

-(BBSightingNoteTagController*)initWithDelegate:(id<BBSightingNoteEditDelegateProtocol>)delegate {
    self = [super init];
    
    _controller = delegate;
    
    return self;
}

-(void)loadView {
    // create the scroll view with table displaying unselected descriptions
    self.view = [MGScrollView scrollerWithSize:[UIScreen mainScreen].bounds.size];
    
    tagInstructionBox = [MGTableBoxStyled box];// boxWithSize:CGSizeMake(300, 40)];
    tagInstructionBox.width = 300;
    
    MGTableBoxStyled *createTagTable = [MGTableBoxStyled boxWithSize:CGSizeMake(300,40)];
    
    // add tag typing box
//    MGBox *createTagBox = [MGBox boxWithSize:CGSizeMake(300, 50)];
    tagTextField = [BBUIControlHelper createTextFieldWithFrame:CGRectMake(0, 0, 280, 40) andPlaceholder:@"Enter your tag..." andDelegate:self];
    tagTextField.returnKeyType = UIReturnKeyDone;
    
    MGLine *tagTextFieldLine = [MGLine lineWithLeft:tagTextField right:nil size:CGSizeMake(280,40)];
    tagTextFieldLine.underlineType = MGUnderlineNone;
    tagTextFieldLine.margin = UIEdgeInsetsMake(10, 10, 0, 10);
    
//    [createTagBox.boxes addObject:tagTextFieldLine];
    [createTagTable.middleLines addObject:tagTextFieldLine];

    CoolMGButton *tagUpText = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 130, 40) andTitle:@"Create" withBlock:^{
        // pass to notification system:
        [self tagUpTextClicked];
    }];
    tagUpText.margin = UIEdgeInsetsMake(0, 0, 0, 0);
    CoolMGButton *done = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 0, 130, 40) andTitle:@"Done" withBlock:^{
        // pass to notification system:
        [_controller endAddTag];
    }];
    done.margin = UIEdgeInsetsMake(0, 10, 0, 0);
    MGLine *buttonLine = [MGLine lineWithLeft:tagUpText right:done size:CGSizeMake(280, 60)];
    buttonLine.underlineType = MGUnderlineNone;
    buttonLine.margin = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [createTagTable.bottomLines addObject:buttonLine];
    
    
    // display the tags
    tagBox = [MGBox boxWithSize:CGSizeMake(300, 50)];
    tagBox.margin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    [((MGScrollView*)self.view).boxes addObject:tagInstructionBox];
    [((MGScrollView*)self.view).boxes addObject:createTagTable];
    [((MGScrollView*)self.view).boxes addObject:tagBox];
    
    [self displayTagCloud];
    
    self.view.backgroundColor = [self backgroundColor];
    
    [(MGScrollView*)self.view layout];
}

-(void)displayTagInstructions {
    MGLine *createTagInstructions = [MGLine multilineWithText:@"Type your tag and click 'Create'. Tap tag to remove."
                                                         font:HEADER_FONT
                                                        width:300
                                                      padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    createTagInstructions.underlineType = MGUnderlineNone;
    createTagInstructions.height = 50;
    [tagInstructionBox.middleLines addObject:createTagInstructions];
}

-(void)hideTagInstructions {
    [tagInstructionBox.middleLines removeAllObjects];
}

-(void)tagUpTextClicked {
    
    if([tagTextField.text isEqualToString:@""]) return;
    
    [_controller addTag:tagTextField.text];
    
    [tagTextField setText:@""];
    [self displayTagCloud];
    
    [(MGScrollView*)self.view layout];
}

-(void)displayTagCloud {
    
    DWTagList *tagList = [[DWTagList alloc]initWithFrame:CGRectMake(0, 0, 280, 80)];
    
    [tagList setTags:[_controller getTags]];
    tagList.delegate = self;
    
    if(tagBox.subviews.count > 0){
        [[tagBox.subviews objectAtIndex:0] removeFromSuperview];
        [self hideTagInstructions];
    }
    else {
        [self displayTagInstructions];
    }
    
    [tagBox addSubview:tagList];
    
    // calling method must then call layout on this view
}

- (void)selectedTag:(NSString*)tagName {
    [_controller removeTag:tagName];
    
    [self displayTagCloud];
}

-(void)viewDidLoad{
    
    self.title = @"Add Tags";
    
    ((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                   style: UIBarButtonItemStyleBordered
                                                                  target: self
                                                                  action: nil];
    
    self.navigationItem.backBarButtonItem = backButton;
    /*
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action:@selector(cancelTapped)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Hide keyboard.
    [textField resignFirstResponder];
    
    return YES;
}

@end