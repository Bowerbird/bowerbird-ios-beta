//
//  BBOriginalImageController.h
//  BowerBird
//
//  Created by Hamish Crittenden on 19/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBControllerBase.h"
#import "BBOriginalImageView.h"
#import "BBMedia.h"
#import "BBImage.h"

@interface BBImageController : BBControllerBase

@property (nonatomic, strong) BBMedia* media;

-(BBImageController*)initWithMedia:(BBMedia*)media;

@end