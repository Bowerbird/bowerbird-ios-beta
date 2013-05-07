/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import "BBControllerBase.h"
#import "LBYouTubePlayerController.h"


@interface BBSightingDetailController : BBControllerBase <
     UIGestureRecognizerDelegate
    ,MKMapViewDelegate
    ,LBYouTubePlayerControllerDelegate
>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

-(BBSightingDetailController*)initWithSightingIdentifier:(NSString*)identifier;

@end