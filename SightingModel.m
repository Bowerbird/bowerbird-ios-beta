//
//  Sighting.m
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "SightingModel.h"

// Private implementation for Observation - must be declared before calling
@interface SightingModel()

// Private Properties
@property (nonatomic) CGPoint location;

@end

@implementation SightingModel

@synthesize identifier = _identifier;
@synthesize createdOn = _createdOn;
@synthesize createdByUser = _createdByUser;
@synthesize observedOn = _observedOn;
@synthesize category = _category;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize location = _location;
@synthesize anonymiseLocation = _anonymiseLocation;
@synthesize groups = _groups;

-(void)updateLocation:(double)lat
             toLatLon:(double)lon    
{
    _latitude = lat;
    _longitude = lon;
    _location = CGPointMake(lat, lon);
}

@end
