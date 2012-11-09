//
//  BBObservationEditController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BBControllerBase.h"
#import "BBModels.h"
#import "MGScrollView.h"
#import "UIView+MGEasyFrame.h" // gives us some helpers for x/y/size/etc
#import "BBSightingEditView.h"
#import "BBSightingDataSource.h"
#import "BBDateSelectController.h"
#import "BBDatePickerDelegateProtocol.h"
#import "BBMediaEditController.h"
#import "BBMediaEditDelegateProtocol.h"
#import "BBLocationSelectController.h"
#import "BBLocationEditDelegateProtocol.h"
#import "BBCategoryPickerController.h"
#import "BBProjectSelectDelegateProtocol.h"
#import "BBProjectSelectController.h"

@class UIActivityIndicatorView;

@interface BBObservationEditController : BBControllerBase <
     BBSightingDataSource // controller data access methods
    ,BBSightingEditDelegateProtocol
    ,UINavigationControllerDelegate // required for image picker modal popup
    ,UIImagePickerControllerDelegate // required for image picker modal popup
    ,UITextFieldDelegate
    ,CLLocationManagerDelegate
    ,BBDatePickerDelegateProtocol
    ,BBMediaEditDelegateProtocol
    ,BBLocationEditDelegateProtocol
    ,BBCategoryPickerDelegateProtocol
    ,BBProjectSelectDelegateProtocol
>

@property (nonatomic,retain) BBSightingEdit *observation;
@property (nonatomic,retain) BBSightingEditView *observationEditView;
@property (nonatomic,strong) BBMediaEdit *editingMedia;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentUserCoordinate;

@property (readonly) UIActivityIndicatorView *spinner; // weak
@property (readonly) UIActivityIndicatorView *currentLocationActivityIndicatorView; // weak

-(BBObservationEditController*)initWithMedia:(BBMediaEdit*)observationMedia;

/*
// BBDatePickerDelegateProtocol methods:
-(void)updateCreatedOn:(NSDate*)date;
-(NSDate*)createdOn;
-(void)createdOnStartEdit;
-(void)createdOnStopEdit;

// BBLocationEditDelegateProtocol methods:
-(CGPoint)getLocationLatLon;
-(void)updateLocationLatLon:(CGPoint)location;
-(NSString*)getLocationAddress;
-(void)updateLocationAddress:(NSString*)address;
-(void)locationStartEdit;
-(void)locationStopEdit;
*/

// CLLocationManagerDelegate methods:
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

// BBMediaEditDelegateProtocol methods:


@end