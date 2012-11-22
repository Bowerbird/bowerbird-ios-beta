//
//  UIImage+fixOrientation.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 22/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

- (UIImage *)normalizedImage;

@end