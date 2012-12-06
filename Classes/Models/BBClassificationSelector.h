//
//  BBClassificationSelector.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 5/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHelpers.h"
#import "BBClassification.h"

@interface BBClassificationSelector : NSObject

@property (nonatomic,strong) BBClassification* currentClassification;
@property (nonatomic,strong) NSString* currentRank;
@property (nonatomic,strong) NSArray* ranksToQuery;

-(BBClassificationSelector*)initWithClassification:(BBClassification*)classification
                                    andCurrentRank:(NSString*)currentRank;

-(NSString*)getNextRankQuery;

-(NSString*)getPreviousRankQuery;

@end