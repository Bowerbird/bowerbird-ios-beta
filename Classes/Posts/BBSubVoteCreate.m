/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSubVoteCreate.h"
#import "BBObservationNote.h"
#import "BBIdentification.h"


@implementation BBSubVoteCreate


#pragma mark -
#pragma mark - Constructors


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