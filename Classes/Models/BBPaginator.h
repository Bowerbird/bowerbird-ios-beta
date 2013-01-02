//
//  BBPaginator.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 2/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface BBPaginator : RKObjectPaginator

@property (nonatomic,strong) NSMutableSet *items;

-(BOOL)moreItemsExist;

@end