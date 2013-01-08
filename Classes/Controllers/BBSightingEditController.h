//
//  BBObservationEditController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 23/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RKRequestSerialization.h>
#import "BBControllerBase.h"
#import "BBModels.h"
#import "MGScrollView.h"
#import "BBStyles.h"
#import "UIView+MGEasyFrame.h" // gives us some helpers for x/y/size/etc
#import "BBSightingEditView.h"
#import "BBSightingDataSource.h"
#import "BBDateSelectController.h"
#import "BBDatePickerDelegateProtocol.h"
#import "BBCategoryPickerController.h"
#import "BBProjectSelectDelegateProtocol.h"
#import "BBProjectSelectController.h"
#import "BBObservationCreate.h"
#import "BBMultipartForm.h"
#import "SVProgressHUD.h"
#import "BBLocationSelectController.h"
#import "MBProgressHUD.h"
#import "UIImage+fixOrientation.h"

@class UIActivityIndicatorView;

@interface BBSightingEditController : BBControllerBase <
     BBSightingDataSource // controller data access methods
    ,BBSightingEditDelegateProtocol
    ,UINavigationControllerDelegate // required for image picker modal popup
    ,UIImagePickerControllerDelegate // required for image picker modal popup
    ,CLLocationManagerDelegate
    ,BBDatePickerDelegateProtocol
    ,BBCategoryPickerDelegateProtocol
    ,BBProjectSelectDelegateProtocol
    ,BBLocationEditDelegateProtocol
    ,RKObjectLoaderDelegate
    ,MBProgressHUDDelegate
> {
    // all these instance vars are for HUD display
    MBProgressHUD *HUD;
	long long expectedLength;
	long long currentLength;
}

@property (nonatomic,retain) BBSightingEdit *observation;
@property (nonatomic,retain) BBSightingEditView *observationEditView;
@property (nonatomic,strong) BBMediaEdit *editingMedia;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentUserCoordinate;
@property (readonly) UIActivityIndicatorView *spinner; // weak
@property (readonly) UIActivityIndicatorView *currentLocationActivityIndicatorView; // weak
@property (readonly, strong) NSMutableDictionary* mediaResourceBoxes;

-(BBSightingEditController*)initWithMedia:(BBMediaEdit*)observationMedia;
-(BBSightingEditController*)initAsRecord;

// CLLocationManagerDelegate methods:
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

-(NSDictionary*)buildPostModel;

@end