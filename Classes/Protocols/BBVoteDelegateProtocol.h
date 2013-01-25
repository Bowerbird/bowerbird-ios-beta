//
//  BBVoteDelegateProtocol.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 25/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBVoteDelegateProtocol <NSObject>

@optional
@property (nonatomic,strong) NSNumber* favouritesCount;
@property BOOL userFavourited;

@required
@property (nonatomic,strong) NSNumber* totalVoteScore;
@property (nonatomic,strong) NSNumber* userVoteScore;

@end
