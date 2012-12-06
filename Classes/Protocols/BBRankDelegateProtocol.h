//
//  BBRankDelegateProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 5/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBRankDelegateProtocol <NSObject>

@optional
-(void)loadRankForQuery:(NSString*)query;
-(BBClassification*)getCurrentClassification;
-(void)loadNextRankForClassification:(BBClassification*)classification;
-(void)setSelectedClassification:(BBClassification*)classification;

@end