/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 NOTE:
 
 This is unused but is a placeholder for functionality to manipulate a location on a map
 
 -----------------------------------------------------------------------------------------------*/


#import "BBLocationSelectController.h"
#import "BBLocationSelectView.h"
#import "BBMapPoint.h"


@implementation BBLocationSelectController


#pragma mark -
#pragma mark - Member Accessors


@synthesize controller = _controller,
            locationSelectView = _locationSelectView;


#pragma mark -
#pragma mark - Constructors


-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate {
    [BBLog Log:@"BBLocationSelectController.initWithDelegate:"];
    
    self = [super init];
    self.controller = delegate;
    self.locationSelectView = [[BBLocationSelectView alloc]initWithDelegate:self];
    
    return self;
}


#pragma mark -
#pragma mark - Rendering


-(void)loadView {
    [BBLog Log:@"BBLocationSelectController.loadView"];
    
    self.view = self.locationSelectView;
}

-(void)viewWillAppear:(BOOL)animated {
    
    CGPoint locationLatLon = [self.controller getLocationLatLon];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(locationLatLon.x, locationLatLon.y);
    BBMapPoint *mp = [[BBMapPoint alloc]initWithCoordinate:loc title:@"Observation"]; //[[BBMapPoint alloc]
    MKAnnotationView* av = [self mapView:_locationSelectView.mapView viewForAnnotation:mp];
    [_locationSelectView.mapView addAnnotation:av.annotation];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = loc.latitude;
    newRegion.center.longitude = loc.longitude;
    newRegion.span.latitudeDelta = 0.05;
    newRegion.span.longitudeDelta = 0.04;
    [_locationSelectView.mapView setRegion:newRegion animated:YES];
}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(MKAnnotationView *)mapView:(MKMapView *)mV
           viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != _locationSelectView.mapView.userLocation)
    {
        static NSString *defaultPinID = @"bowerbird.pin";
        pinView = (MKAnnotationView *)[_locationSelectView.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"map-pin.png"];    //as suggested by Squatch
        pinView.draggable = YES;
    }
    else {
        [_locationSelectView.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    [self updateLocationLatLon:CGPointMake(location.coordinate.latitude, location.coordinate.longitude)];
}

-(CGPoint)getLocationLatLon {
    return [_controller getLocationLatLon];
}

-(void)updateLocationLatLon:(CGPoint)location {
    [_controller updateLocationLatLon:location];
}

-(NSString*)getLocationAddress {
    return [_controller getLocationAddress];
}

-(void)updateLocationAddress:(NSString*)address {
    [_controller updateLocationAddress:address];
}

-(void)locationStopEdit {
    [_controller locationStopEdit];
}


@end