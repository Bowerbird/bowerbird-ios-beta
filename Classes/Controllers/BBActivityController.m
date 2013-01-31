//
//  BBActivityController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 30/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBActivityController.h"

@interface BBActivityController ()
@property (nonatomic,strong) BBActivity* activity;
@end

@implementation BBActivityController

@synthesize activity = _activity;

- (id)initWithActivity:(BBActivity*)activity {
    [BBLog Log:@"BBActivityController.initWithActivity:"];
    
    self = [super init];
    
    if(self) {
        self.activity = activity;
    }
    
    return self;
}

-(void)loadView {
    
    MGBox *box;
    
    if([self.activity.type isEqualToString:@"sightingadded"])
    {
        BBSightingActivityController *sightingActivityController = [[BBSightingActivityController alloc]initWithSightingActivity:self.activity];
        
        box = (MGBox*)sightingActivityController.view;
    }
    
    else if([self.activity.type isEqualToString:@"sightingnoteadded"])
    {
        BBSightingNoteActivityController *sightingNoteActivityController = [[BBSightingNoteActivityController alloc]initWithSightingNoteActivity:self.activity];
        
        box = (MGBox*)sightingNoteActivityController.view;
    }
    else if([self.activity.type isEqualToString:@"identificationadded"])
    {
        BBIdentificationActivityController *identificationActivityController = [[BBIdentificationActivityController alloc]initWithIdentificationActivity:self.activity];

        box = (MGBox*)identificationActivityController.view;
    }
    else if([self.activity.type isEqualToString:@"postadded"])
    {
        BBPostActivityController *postActivityController = [[BBPostActivityController alloc] initWithPostActivity:self.activity];
        
        box = (MGBox*)postActivityController.view;
    }
    
    else {
        [BBLog Log:@"ERROR: BBActivityController.loadView has an unidentified activity type"];
    }
    
    self.view = box;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end