//
//  BBVoteController.h
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 25/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBControllerBase.h"
#import "BBModels.h"

@interface BBVoteController : BBControllerBase <
    RKObjectLoaderDelegate
>

-(id)initWithObservation:(BBObservation*)observation;
-(id)initWithObservationNote:(BBObservationNote*)observationNote;
-(id)initWithIdentification:(BBIdentification*)identification;

@end