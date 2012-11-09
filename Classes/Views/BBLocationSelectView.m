//
//  BBLocationSelectView.m
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBLocationSelectView.h"

@implementation BBLocationSelectView

@synthesize controller = _controller;
@synthesize latLabel = _latLabel;
@synthesize lonLabel = _lonLabel;
@synthesize addressLabel = _addressLabel;
@synthesize mapView = _mapView;

-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate {
    [BBLog Log:@"BBLocationSelectView.initWithDelegate:"];
    
    self = [super init];
    _controller = delegate;
    CGPoint locationLatLon = [_controller getLocationLatLon];
    
//    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 280)];
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, -120, 280, 240)];

    [self addSubview:self.mapView];
    /*
    self.latLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 310, 320, 20)];
    self.latLabel.text = [NSString stringWithFormat:@"Latitude: %f", locationLatLon.x];
    [self addSubview:self.latLabel];
    
    self.lonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 340, 320, 20)];
    self.lonLabel.text = [NSString stringWithFormat:@"Longitude: %f", locationLatLon.y];
    [self addSubview:self.lonLabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 370, 320, 40)];
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.text = [self.controller getLocationAddress];
    [self addSubview:self.addressLabel];    
    
    CoolMGButton* done = [BBUIControlHelper createButtonWithFrame:CGRectMake(0, 440, 320, 40) andTitle:@"Finished finding location" withBlock:^{[self locationStopEdit];}];
    [self addSubview:done];
    */
    return self;
}


-(void)updateLocationLatLon:(CGPoint)location {
    [_controller updateLocationLatLon:location];
}


-(void)updateLocationAddress:(NSString*)address {
    [_controller updateLocationAddress:address];
}

-(void)locationStopEdit {
    [_controller locationStopEdit];
}

@end