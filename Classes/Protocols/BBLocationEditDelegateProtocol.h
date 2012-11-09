//
//  BBLocationEditDelegateProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBLocationEditDelegateProtocol <NSObject>

-(CGPoint)getLocationLatLon;
-(void)updateLocationLatLon:(CGPoint)location;
-(NSString*)getLocationAddress;
-(void)updateLocationAddress:(NSString*)address;
-(void)locationStartEdit;
-(void)locationStopEdit;

@end