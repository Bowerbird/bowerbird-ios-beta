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
    
    // this is causing an exception.. need to follow better example..
    //[dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        //[arrayOfValues addObject:obj];
    //}];
    
    for(id key in dictionary)
    {
        id value = [dictionary objectForKey:key];
        [arrayOfValues addObject:value];
    }
    
    return [[NSArray alloc]initWithArray:arrayOfValues];
}

@end
