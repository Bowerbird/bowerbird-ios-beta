//
//  BBSightingNoteDescriptionCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteDescriptionCreate.h"

@implementation BBSightingNoteDescriptionCreate


@synthesize key = _key,
          value = _value;


-(NSString*)key {
    return _key;
}
-(void)setKey:(NSString *)key {
    _key = key;
}


-(NSString*)value {
    return _value;
}
-(void)setValue:(NSString *)value {
    _value = value;
}


@end