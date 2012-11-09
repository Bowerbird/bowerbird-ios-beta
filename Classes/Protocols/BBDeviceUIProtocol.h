//
//  BBDeviceUIProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBDeviceUIProtocol

@required
-(BOOL) deviceIsPhone;
-(BOOL) orientationIsPortrait;
-(double) getOrientationWidth;
-(double) getOrientationHeight;

@end