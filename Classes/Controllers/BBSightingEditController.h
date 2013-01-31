/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RKRequestSerialization.h>
#import "BBControllerBase.h"
#import "BBDatePickerDelegateProtocol.h"
#import "BBProjectSelectDelegateProtocol.h"
#import "BBSightingEditDelegateProtocol.h"
#import "BBSightingDataSource.h"
#import "BBCategoryPickerDelegateProtocol.h"
#import "BBLocationEditDelegateProtocol.h"


@class BBSightingEdit, BBSightingEditView, BBMediaEdit, UIActivityIndicatorView;


@interface BBSightingEditController : BBControllerBase <
     BBSightingDataSource
    ,BBSightingEditDelegateProtocol
    ,UINavigationControllerDelegate
    ,UIImagePickerControllerDelegate
    ,CLLocationManagerDelegate
    ,BBDatePickerDelegateProtocol
    ,BBCategoryPickerDelegateProtocol
    ,BBProjectSelectDelegateProtocol
    ,BBLocationEditDelegateProtocol
    ,RKObjectLoaderDelegate
>

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

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

-(NSDictionary*)buildPostModel;

@end