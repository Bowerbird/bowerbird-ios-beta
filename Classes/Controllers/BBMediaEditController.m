//
//  BBMediaDescriptionController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBMediaEditController.h"

@implementation BBMediaEditController

@synthesize controller = _controller;
@synthesize media = _media;
@synthesize mediaEditView = _mediaEditView;

#pragma mark -
#pragma mark - Setup and Render

-(id)initWithDelegate:(id<BBMediaEditDelegateProtocol>)delegate andMedia:(BBMediaEdit*)media {
    self = [super init];
    
    self.controller = delegate;
    self.media = media;
    
    return self;
}

-(void)loadView {
    [BBLog Log:@"BBMediaEditController.loadView"];
    
    self.mediaEditView = [[BBMediaEditView alloc]initWithDelegate:self
                                                         andImage:self.media.image];
    
    self.view = self.mediaEditView;
}

- (void)viewDidLoad {
    [BBLog Log:@"BBMediaEditController.viewDidLoad"];
}

#pragma mark -
#pragma mark - Utilities and Helpers

-(NSArray*)getLicences {
    BBApplication *appData = [BBApplication sharedInstance];
    return appData.licences;
}

-(NSString*)getUserDefaultLicence {
    BBApplication *appData = [BBApplication sharedInstance];
    return appData.authenticatedUser.defaultLicence;
}

-(void)updateLicence:(NSString*)licence {
    self.media.licence = licence;
}

-(void)updateCaption:(NSString*)caption {
    self.media.description = caption;
}

-(void)setAsPrimaryImage {
    self.media.isPrimaryImage = YES;
}

-(void)saveMediaEdit {
    [self.controller saveMediaEdit];
}

-(void)cancelMediaEdit {
    [self.controller cancelMediaEdit];
}

#pragma mark -
#pragma mark - Delegation and Event Handling

- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBMediaEditController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end