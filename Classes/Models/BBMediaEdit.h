//
//  BBMediaCreate.h
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBMediaEdit : NSObject

@property (nonatomic,retain) NSString* licence;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) UIImage* image;
@property BOOL isPrimaryImage;

@end