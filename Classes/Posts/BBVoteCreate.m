/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBVoteCreate.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"
#import "BBObservation.h"


@implementation BBVoteCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            subIdentifier = _subIdentifier,
            contributionType = _contributionType,
            subContributionType = _subContributionType,
            score = _score;

 
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)identifier { return _identifier; }
-(void)setSubIdentifier:(NSString *)subIdentifier { _subIdentifier = subIdentifier; }
-(NSString*)subIdentifier { return _subIdentifier; }
-(void)setContributionType:(NSString *)contributionType { _contributionType = contributionType; }
-(NSString*)contributionType { return _contributionType; }
-(void)setSubContributionType:(NSString *)subContributionType { _subContributionType = subContributionType; }
-(NSString*)subContributionType { return _subContributionType; }
-(void)setScore:(NSNumber *)score { _score = score; }
-(NSNumber*)score { return _score; }


#pragma mark -
#pragma mark - Constructors


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


#pragma mark -
#pragma mark - Utilities


-(void)increment {
    _score = [[NSNumber alloc]initWithInt:([_score intValue] + 1)];
}

-(void)decrement {
    _score = [[NSNumber alloc]initWithInt:([_score intValue] - 1)];
}


@end