//
//  BBDisplayLocationController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 15/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BBControllerBase.h"
#import "PDLocation.h"
#import "MapPoint.h"
#import "BBSightingDetailController.h"

//@class BBLocationSelectDelegate;

@interface BBDisplayLocationController : BBControllerBase <
    UIGestureRecognizerDelegate
    ,MKMapViewDelegate
>

-(id)initWithLocation:(PDLocation*)location;

@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end