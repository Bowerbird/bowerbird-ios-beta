//
//  BBSightingController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 17/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BBControllerBase.h"
#import "BBActivity.h"
#import "MGHelpers.h"
#import "PhotoBox.h"
#import "BBUIControlHelper.h"
#import "MBProgressHUD.h"
#import "BBIdentificationController.h"

@interface BBSightingDetailController : BBControllerBase <
     UIGestureRecognizerDelegate
    ,MKMapViewDelegate
    ,RKObjectLoaderDelegate
>

@property (strong, nonatomic) MKMapView *mapView;

-(BBSightingDetailController*)initWithSightingIdentifier:(NSString*)identifier;

@end