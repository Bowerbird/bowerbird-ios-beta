//
//  BBOriginalImageController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 19/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBImageController.h"

@implementation BBImageController


#pragma mark -
#pragma mark - Setup and Render



-(BBImageController*)initWithMedia:(BBMedia*)media {
    self = [super init];
    
    self.media = media;
    
    return self;
}


-(void)loadView {
    [BBLog Log:@"BBImageController.loadView"];
    
    //    self.view = [[BBSightingCreateView alloc]initWithFrame:IPHONE_STREAM_FRAME];
    //    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
    //    self.mapView = [[MKMapView alloc]init];
}


- (void)viewDidLoad {
    [BBLog Log:@"BBImageController.viewDidLoad"];
    
    //    [super viewDidLoad];
    //    self.app.navController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark - Utilities and Helpers



#pragma mark -
#pragma mark - Delegation and Event Handling


- (void)didReceiveMemoryWarning {
    [BBLog Log:@"MEMORY WARNING! - BBImageController"];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end