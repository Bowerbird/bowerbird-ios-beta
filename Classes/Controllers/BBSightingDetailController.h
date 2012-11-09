//
//  BBSightingController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 17/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BBControllerBase.h"\
#import "BBActivity.h"
#import "MGHelpers.h"
#import "PhotoBox.h"

@interface BBSightingDetailController : BBControllerBase <
     UIGestureRecognizerDelegate
    ,MKMapViewDelegate
>

@property (nonatomic,retain) BBActivity* activity;
@property (strong, nonatomic) MKMapView *mapView;

-(BBSightingDetailController*)initWithActivity:(BBActivity*)activity;

@end