//
//  BBArrowView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 9/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BBArrowBack,
    BBArrowNext
} BBArrowType;

@interface BBArrowView : UIView

- (id)initWithFrame:(CGRect)frame
       andDirection:(BBArrowType)direction
     andArrowColour:(UIColor*)colour
        andBgColour:(UIColor*)bgColour;

@end
