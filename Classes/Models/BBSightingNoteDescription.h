//
//  BBSightingNoteDescription.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSightingNoteDescription : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* group;
@property (nonatomic,strong) NSString* label;
@property (nonatomic,strong) NSString* description;
@property (nonatomic,strong) NSString* text;

@end