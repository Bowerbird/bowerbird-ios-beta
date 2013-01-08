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
@synthesize pageCount = _pageCount;
@synthesize currentPage = _currentPage;

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
    return self.currentPage < self.pageCount;
}

-(void)setPageCount:(NSUInteger)pageCount {
    _pageCount = pageCount;
}

-(void)setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
}

@end