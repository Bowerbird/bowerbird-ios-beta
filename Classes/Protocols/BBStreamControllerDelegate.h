//
//  BBStreamControllerDelegate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 30/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBStreamControllerDelegate <NSObject>

@required
-(void)pagingLoadingComplete;
-(void)pageLoadingStarted;
-(void)pullToRefreshCompleted;
-(void)displayItems;

@end