//
//  BBSubVoteCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBModels.h"
#import "BBVoteCreate.h"
#import "BBSubVoteCreate.h"

@implementation BBSubVoteCreate

-(BBSubVoteCreate*)initWithObservationNote:(BBObservationNote*)observationNote
                                  andScore:(NSNumber*)score {
    self = [super init];
    
    if(self) {
        self.contributionType = @"observations";
        self.subContributionType = @"notes";
        self.identifier = observationNote.sightingId;
        self.subIdentifier = observationNote.identifier;
        self.score = score;
    }
    
    return self;
}

-(BBSubVoteCreate*)initWithIdentification:(BBIdentification*)identification
                                  andScore:(NSNumber*)score {
    self = [super init];
    
    if(self) {
        self.contributionType = @"observations";
        self.subContributionType = @"identifications";
        self.identifier = identification.sightingId;
        self.subIdentifier = identification.identifier;
        self.score = score;
    }
    
    return self;
}

@end