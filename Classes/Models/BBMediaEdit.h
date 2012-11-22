//
//  BBMediaCreate.h
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBGuidGenerator.h"

@interface BBMediaEdit : NSObject

-(BBMediaEdit*)initWithImage:(UIImage*)image;

@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* licence;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) UIImage* image;
@property BOOL isPrimaryImage;

@end