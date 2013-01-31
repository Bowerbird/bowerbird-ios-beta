/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BBLocationEditDelegateProtocol.h"


@interface BBLocationSelectView : UIView <
    BBLocationEditDelegateProtocol
    ,CLLocationManagerDelegate
>

@property (nonatomic,retain) id<BBLocationEditDelegateProtocol> controller;
@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,retain) MKAnnotationView *annotationView;
@property (nonatomic,retain) UILabel *latLabel;
@property (nonatomic,retain) UILabel *lonLabel;
@property (nonatomic,retain) UILabel *addressLabel;

-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate;

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

-(CGPoint)getLocationLatLon;
-(void)updateLocationLatLon:(CGPoint)location;
-(NSString*)getLocationAddress;
-(void)updateLocationAddress:(NSString*)address;
-(void)locationStartEdit;
-(void)locationStopEdit;

@end