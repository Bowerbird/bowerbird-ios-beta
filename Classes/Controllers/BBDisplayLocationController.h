/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <MapKit/MapKit.h>
#import "BBControllerBase.h"


@class PDLocation;


@interface BBDisplayLocationController : BBControllerBase <
    UIGestureRecognizerDelegate
    ,MKMapViewDelegate
>

-(id)initWithLocation:(PDLocation*)location;

@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end