//
//  BBStarView.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 29/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BBFavouriteSelected,
    BBFavouriteNotSelected
} BBFavouriteType;

@interface BBStarView : UIView

- (id)initWithFrame:(CGRect)frame
   andFavouriteType:(BBFavouriteType)favourite
        andBgColour:(UIColor*)bgColour
        andStarSize:(float)starSize;

@end