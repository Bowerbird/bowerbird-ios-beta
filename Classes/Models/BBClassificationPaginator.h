//
//  BBClassificationPaginator.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 3/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBClassificationPaginator : RKObjectPaginator

@property (nonatomic,retain) NSArray* ranks;

@end