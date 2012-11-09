//
//  NSString+MGBox_SizeOrientation.h
//  BowerBird
//
//  Created by Hamish Crittenden on 9/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGBox.h"

@interface MGBox (SizeOrientation)

@property BOOL phone;
@property BOOL portrait;
@property (readonly) double deviceWidth;
@property (readonly) double deviceHeight;

-(void)setSizeAndOrientation:(UIInterfaceOrientation)orientation;

@end