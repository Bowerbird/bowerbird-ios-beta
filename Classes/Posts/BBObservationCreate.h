//
//  BBObservationCreateInput.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 14/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBObservationCreate : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *observedOn;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *address;
@property BOOL isIdentificationRequired;
@property BOOL anonymiseLocation;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSArray *media;
@property (nonatomic, retain) NSArray *projectIds;

@end