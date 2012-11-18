//
//  BBMediaResourceCreate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 14/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBGuidGenerator.h"

@interface BBMediaResourceCreate : NSObject

@property (nonatomic,retain) NSData* file;
@property (nonatomic,retain) NSString* fileName;
@property (nonatomic,retain) NSString* usage;
@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* type;

-(BBMediaResourceCreate*)initWithImage:(UIImage*)image forUsage:(NSString*)usage;

@end