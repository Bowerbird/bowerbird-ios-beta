//
//  BBPaginator.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface BBPaginator : RKObjectPaginator

//@property (nonatomic,strong) NSMutableSet *items;
@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic, readonly) NSUInteger pageCount;

@property (nonatomic, readonly) NSUInteger currentPage;

-(BOOL)moreItemsExist;

-(void)setPageCount:(NSUInteger)pageCount;

-(void)setCurrentPage:(NSUInteger)currentPage;

@end