//
//  BBPaginator.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBPaginator.h"

@implementation BBPaginator

@synthesize items = _items;

-(NSMutableSet*)items {
    if(!_items)_items = [[NSMutableSet alloc]init];
    return _items;
}
-(void)setItems:(NSMutableSet *)items {
    _items = items;
}
-(void)addItemsObject:(NSObject *)item {
    [_items addObject:item];
}
-(void)removeItemsObject:(NSObject *)item {
    [_items removeObject:item];
}

-(BOOL)moreItemsExist {
    BOOL moreItems = YES;
    
    if(![self hasNextPage]) {
        moreItems = NO;
    }
    
    return moreItems;
}

@end