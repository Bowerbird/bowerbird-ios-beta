/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassificationSelector.h"
#import "BBHelpers.h"
#import "BBClassification.h"


@implementation BBClassificationSelector


#pragma mark -
#pragma mark - Member Accessors


@synthesize currentClassification = _currentClassification,
            currentRank = _currentRank,
            ranksToQuery = _ranksToQuery;


#pragma mark -
#pragma mark - Constructors


-(BBClassificationSelector*)init {
    [BBLog Log:@"BBClassificationSelector.initWithClassification:"];
    
    self = [super init];
    
    _ranksToQuery = [BBConstants ranksToQuery];
    _currentRank = @"allranks";
    
    return self;
}

-(BBClassificationSelector*)initWithClassification:(BBClassification*)classification
                                    andCurrentRank:(NSString*)currentRank {
    [BBLog Log:@"BBClassificationSelector.initWithClassification:"];
    
    self = [super init];
    
    _currentClassification = classification;
    _currentRank = currentRank;
    _ranksToQuery = [BBConstants ranksToQuery];
    
    return self;
}


#pragma mark -
#pragma mark - Methods


-(NSString*)getNextRankQuery {
    [BBLog Log:@"BBClassificationSelector.getNextRank"];
    
    // first time query for ranks
    if([_currentRank isEqualToString:@""]) {
        _currentRank = [_ranksToQuery objectAtIndex:0];
        return _currentRank;
    }

    // subsequent rank queries
    int index = [_ranksToQuery indexOfObject:_currentRank];
    if(index < _ranksToQuery.count -1) {
        // we can go again
        //_currentRank = [_ranksToQuery objectAtIndex:(index + 1)];
        
        // lets do this instead.. hopefully works each time.
        return [_ranksToQuery objectAtIndex:(index + 1)];
    }
    
    return _currentRank;
}

-(NSString*)getPreviousRankQuery {
    [BBLog Log:@"BBClassificationSelector.getNextRank"];
    
    int index = [_ranksToQuery indexOfObject:_currentRank];
    
    if(index > 0) { // we can go one better
        return [_ranksToQuery objectAtIndex:(index - 1)];
    }
    
    return nil;
}


@end