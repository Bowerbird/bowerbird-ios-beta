//
//  BBVoteCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 24/01/13.
//  Copyright (c) 2013 Museum Victoria. All rights reserved.
//

#import "BBModels.h"

@implementation BBVoteCreate

@synthesize identifier = _identifier,
            subIdentifier = _subIdentifier,
            contributionType = _contributionType,
            subContributionType = _subContributionType,
            score = _score;


-(id)initWithObservation:(BBObservation*)observation
                           andScore:(NSNumber*)score {
    self = [super init];
    
    if(self) {
        _contributionType = @"observations";
        _identifier = observation.identifier;
        _score = score;
    }
    
    return self;
}
 
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}
-(NSString*)identifier {
    return _identifier;
}

-(void)setSubIdentifier:(NSString *)subIdentifier {
    _subIdentifier = subIdentifier;
}
-(NSString*)subIdentifier {
    return _subIdentifier;
}

-(void)setContributionType:(NSString *)contributionType {
    _contributionType = _contributionType;
}

-(NSString*)contributionType {
    return _contributionType;
}

-(void)setSubContributionType:(NSString *)subContributionType {
    _subContributionType = subContributionType;
}
-(NSString*)subContributionType {
    return _subContributionType;
}

-(void)setScore:(NSNumber *)score {
    _score = score;
}
-(NSNumber*)score {
    return _score;
}

-(void)increment {
    _score = [[NSNumber alloc]initWithInt:([_score intValue] + 1)];
}

-(void)decrement {
    _score = [[NSNumber alloc]initWithInt:([_score intValue] - 1)];
}

@end