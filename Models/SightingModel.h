//
//  Sighting.h
//  Bowerbird-iOS
//
//  Created by Hamish Crittenden on 27/07/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "ProjectModel.h"

@interface SightingModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) UserModel *createdByUser;
@property (nonatomic, strong) NSDate *observedOn;
@property (nonatomic, strong) NSString *category;
@property (nonatomic) double latitude;  
@property (nonatomic) double longitude;
@property (nonatomic) BOOL anonymiseLocation;
@property (nonatomic, strong) NSArray *groups;

-(void)updateLocation:(double)lat
             toLatLon:(double)lon;

// return the lat lon as a point
-(CGPoint)location;

@end
