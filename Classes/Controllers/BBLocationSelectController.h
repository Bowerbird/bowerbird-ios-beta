//
//  BBLocationSelectController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 26/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BBLocationEditDelegateProtocol.h"
#import "BBLocationSelectView.h"
#import "BBLog.h"
#import "BBStyles.h"
#import "BBControllerBase.h"
#import "BBMapPoint.h"
#import "BBLocationSelectView.h"

@interface BBLocationSelectController : BBControllerBase <
    BBLocationEditDelegateProtocol
    ,CLLocationManagerDelegate
    ,MKMapViewDelegate
>

@property (nonatomic,retain) id controller; // parent controller
@property (nonatomic,strong) BBLocationSelectView *locationSelectView; // da view

-(id)initWithDelegate:(id<BBLocationEditDelegateProtocol>)delegate; // setup with pointer to parent

@end