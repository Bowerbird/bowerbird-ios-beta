//
//  BBObservationCreateInput.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 14/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBObservationCreate.h"

@implementation BBObservationCreate

@synthesize         title = _title,
               observedOn = _observedOn,
                 latitude = _latitude,
                longitude = _longitude,
                  address = _address,
 isIdentificationRequired = _isIdentificationRequired,
        anonymiseLocation = _anonymiseLocation,
                 category = _category,
                    media = _media,
               projectIds = _projectIds;


-(NSString*)title {
    return _title;
}
-(void)setTitle:(NSString *)title {
    _title = title;
}

-(NSDate *)observedOn {
    return _observedOn;
}
-(void)setObservedOn:(NSDate *)observedOn {
    _observedOn = observedOn;
}

-(NSString *)latitude {
    return _latitude;
}
-(void)setLatitude:(NSString *)latitude {
    _latitude = latitude;
}

-(NSString *)longitude {
    return _longitude;
}
-(void)setLongitude:(NSString *)longitude {
    _longitude = longitude;
}

-(NSString *)address {
    return _address;
}
-(void)setAddress:(NSString *)address {
    _address = address;
}

-(BOOL)isIdentificationRequired {
    return _isIdentificationRequired;
}
-(void)setIsIdentificationRequired:(BOOL)isIdentificationRequired {
    _isIdentificationRequired = isIdentificationRequired;
}

-(BOOL)anonymiseLocation {
    return _anonymiseLocation;
}
-(void)setAnonymiseLocation:(BOOL)anonymiseLocation {
    _anonymiseLocation = anonymiseLocation;
}

-(NSString *)category {
    return _category;
}
-(void)setCategory:(NSString *)category{
    _category = category;
}

-(NSArray *)media {
    return _media;
}
-(void)setMedia:(NSArray *)media{
    _media = media;
}

-(NSArray *)projectIds {
    return _projectIds;
}
-(void)setProjectIds:(NSArray *)projectIds {
    _projectIds = projectIds;
}

@end