//
//  BBSubVoteCreate.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBModels.h"
#import "BBVoteCreate.h"

@interface BBSubVoteCreate : BBVoteCreate

-(BBSubVoteCreate*)initWithObservationNote:(BBObservationNote*)observationNote
                                  andScore:(NSNumber*)score;

-(BBSubVoteCreate*)initWithIdentification:(BBIdentification*)identification
                                 andScore:(NSNumber*)score;

@end