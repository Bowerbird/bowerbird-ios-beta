//
//  BBLocationSelectController.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBLocationSelectController.h"

@implementation BBLocationSelectController

@synthesize controller = _controller,
    locationSelectView = _locationSelectView;


-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate {
    [BBLog Log:@"BBLocationSelectController.initWithDelegate:"];
    
    self = [super init];
    self.controller = delegate;
    self.locationSelectView = [[BBLocationSelectView alloc]initWithDelegate:self];
    
    return self;
}


-(void)loadView {
    [BBLog Log:@"BBLocationSelectController.loadView"];
    
    self.app = (BBAppDelegate *)[UIApplication sharedApplication].delegate;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    
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

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]
                                    initWithAnnotation:annotation reuseIdentifier:nil];
    [pinView setDraggable:YES];
    [pinView setAnimatesDrop:YES];
    [pinView setPinColor:MKPinAnnotationColorGreen];
    return pinView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    //..Whatever you want to happen when the dragging starts or stops
}
*/

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
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

/*

-(void)performCoordinateGeocode:(CLLocation*)location {
    
    
    __block BBSightingEditView *view = (BBSightingEditView*)self.view;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        NSArray *resultantAddress = [NSArray arrayWithArray:placemarks];
        CLPlacemark *place = [resultantAddress lastObject];
        NSString* address = [NSString stringWithFormat:@"%@, %@ %@ %@", place.thoroughfare, place.locality, place.administrativeArea, place.country];
        
        [BBLog Log:[NSString stringWithFormat:@"Address: %@", address]];
        [view updateLocationAddress:address];
    }];
}
*/

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