//
//  BBObservationMediaCreate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 16/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBObservationMediaCreate : NSObject

@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* mediaResourceId;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* licence;
@property BOOL isPrimaryMedia;

@end
