//
//  BBLocationSelectView.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BBLog.h"
#import "BBLocationEditDelegateProtocol.h"
#import "MGBox.h"
#import "MGLine.h"
#import "BBUIControlHelper.h"
#import "BBMapPoint.h"

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