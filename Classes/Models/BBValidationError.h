//
//  BBValidationError.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 29/04/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBValidationError : NSObject

@property (nonatomic,strong) NSString* field;
@property (nonatomic,strong) NSArray* messages;

@end