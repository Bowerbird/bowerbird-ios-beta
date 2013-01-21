//
//  BBUITableViewCell.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 10/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTableViewCell : UITableViewCell{
	UIView* contentView;
	UIView* selectedContentView;
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted; // subclasses should implement

@end