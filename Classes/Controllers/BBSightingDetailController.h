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
#import "BBCreateSightingNoteController.h"
#import "BBIdentifySightingController.h"
#import "DWTagList.h"
#import "BBArrowView.h"
#import "PDLocation.h"
#import "MapPoint.h"
#import "BBDisplayLocationController.h"
#import "BBDisplayFullImageController.h"
#import "SVProgressHUD.h"

@interface BBSightingDetailController : BBControllerBase <
     UIGestureRecognizerDelegate
    ,MKMapViewDelegate
    ,RKObjectLoaderDelegate
>

@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

-(BBSightingDetailController*)initWithSightingIdentifier:(NSString*)identifier;

@end