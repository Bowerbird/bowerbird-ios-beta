//
//  BBClassificationPaginator.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 3/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBClassificationPaginator.h"

@implementation BBClassificationPaginator

@synthesize ranks = _ranks;

-(void)setRanks:(NSArray *)ranks
{
    _ranks = ranks;
}
-(NSArray*)ranks
{
    if(!_ranks)_ranks = [[NSArray alloc]init];
    return _ranks;
}
-(NSUInteger)countOfRanks
{
    return [_ranks count];
}
-(id)objectInRanksAtIndex:(NSUInteger)index
{
    return [_ranks objectAtIndex:index];
}

@end