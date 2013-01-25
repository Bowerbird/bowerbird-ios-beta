//
//  BBVoteCreate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBObservation.h"

@interface BBVoteCreate : NSObject

@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* subIdentifier;
@property (nonatomic,strong) NSString* contributionType;
@property (nonatomic,strong) NSString* subContributionType;
@property (nonatomic,strong) NSNumber* score;

-(id)initWithObservation:(BBObservation*)observation
                andScore:(NSNumber*)score;

-(void)increment;
-(void)decrement;

@end