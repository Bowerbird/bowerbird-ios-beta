//
//  CollectionHelper.m
//  BowerBird
//
//  Created by Hamish Crittenden on 9/08/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "CollectionHelper.h"

@implementation CollectionHelper

+(NSArray*)populateArrayFromDictionary:(NSDictionary*)dictionary
{
    NSMutableArray* arrayOfValues = [[NSMutableArray alloc]init];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [arrayOfValues addObject:obj];
    }];
    
    return [[NSArray alloc]initWithArray:arrayOfValues];
}

@end
