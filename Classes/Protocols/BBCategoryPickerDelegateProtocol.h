//
//  BBCategoryPickerDelegateProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 30/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCategory.h"

@protocol BBCategoryPickerDelegateProtocol <NSObject>

@optional
-(NSString*)category;
-(NSArray*)getCategories;
-(void)updateCategory:(BBCategory*)category;
-(void)categoryStartEdit;
-(void)categoryStopEdit;

@end