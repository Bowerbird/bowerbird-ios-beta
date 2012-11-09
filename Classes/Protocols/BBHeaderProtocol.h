//
//  BBHeaderProtocol.h
//  BowerBird
//
//  Created by Hamish Crittenden on 4/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBHeaderProtocol <NSObject>

@optional
-(void)showHeadingWithText:(NSString*)title;

@end