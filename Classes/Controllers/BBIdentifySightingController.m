//
//  BBIdentifySightingController.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 11/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBIdentifySightingController.h"

@interface BBIdentifySightingController()

@property (nonatomic, strong) BBIdentifySightingEdit *identification;

@end

@implementation BBIdentifySightingController

@synthesize identification = _identification;


#pragma mark -
#pragma mark - Setup and Render

-(BBIdentifySightingController*)initWithSightingId:(NSString*)sightingId {
    self = [super init];
    
    _identification = [[BBIdentifySightingEdit alloc]initWithSightingId:sightingId];
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBIdentifySightingController.loadView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelIdentification) name:@"cancelIdentification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setClassification:) name:@"identificationSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCustomIdentification:) name:@"customIdentificationSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveIdentification:) name:@"saveIdentification" object:nil];
    
    // create the view for this container
    self.view = [[BBIdentifySightingView alloc]initWithDelegate:self andSize:[self screenSize]];
    self.view.backgroundColor = [self backgroundColor];
}


#pragma mark -
#pragma mark - Protocol Implementations

// search for Id clicked, browse for Id clicked, remove Id clicked
-(void)searchClassifications {
    BBClassificationSearchController *searchController = [[BBClassificationSearchController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:searchController animated:YES];
}

-(void)browseClassifications {
    BBClassificationBrowseController *browseController = [[BBClassificationBrowseController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:browseController animated:YES];
}

-(void)createClassification {
    BBClassificationCreateController *createController = [[BBClassificationCreateController alloc]init];
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController pushViewController:createController animated:YES];
}

-(void)removeClassification {
    // clear the taxonomy
    // tell the view to clear the classification display box
}

-(void)cancel {
    [((BBAppDelegate *)[UIApplication sharedApplication].delegate).navController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Notification Responders

-(void)cancelIdentification {
    [self.navigationController popToViewController:self animated:NO];
}

// pad this out to set custom identification
-(void)setClassification:(NSNotification *) notification{
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBClassification *classification = [userInfo objectForKey:@"classification"];
    
    _identification.taxonomy = classification.taxonomy;
    [((BBIdentifySightingView*)self.view) displayIdentification:classification];
}

-(void)setCustomIdentification:(NSNotification *) notification{
    [self cancelIdentification];
    
    NSDictionary* userInfo = [notification userInfo];
    BBIdentifySightingEdit *identification = [[BBIdentifySightingEdit alloc]init];
    [identification setCustomIdentification:[userInfo objectForKey:@"customIdentification"]];
}

@end