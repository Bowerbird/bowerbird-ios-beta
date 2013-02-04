/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassificationSelector.h"
#import "BBHelpers.h"
#import "BBClassification.h"
#import "BBClassificationPaginator.h"


@implementation BBClassificationSelector


#pragma mark -
#pragma mark - Member Accessors


@synthesize currentClassification = _currentClassification,
            currentRank = _currentRank,
            ranksToQuery = _ranksToQuery,
            controller = _controller;


#pragma mark -
#pragma mark - Constructors


-(BBClassificationSelector*)initWithDelegate:(id<BBRankDelegateProtocol>)delegate {
    [BBLog Log:@"BBClassificationSelector.initWithClassification:"];
    
    self = [super init];
    
    if(self) {
        _controller = delegate;
        _ranksToQuery = [BBConstants ranksToQuery];
        _currentRank = @"allranks";
    }
    
    return self;
}

-(BBClassificationSelector*)initWithClassification:(BBClassification*)classification
                                    andCurrentRank:(NSString*)currentRank
                                       andDelegate:(id<BBRankDelegateProtocol>)delegate {
    [BBLog Log:@"BBClassificationSelector.initWithClassification:"];
    
    self = [super init];
    
    if(self) {
        _controller = delegate;
        _currentClassification = classification;
        _currentRank = currentRank;
        _ranksToQuery = [BBConstants ranksToQuery];
    }
    
    return self;
}


#pragma mark -
#pragma mark - Methods


-(void)getRanks {
    [BBLog Log:@"BBClassificationBrowseController.getNextRank"];
    
    NSString *query;
    
    if(_currentClassification) {
        query = [NSString stringWithFormat:@"query=%@&field=%@", _currentClassification.name, _currentRank];
    }
    else {
        query = [NSString stringWithFormat:@"query=&field=%@", _currentRank];
    }
    
    NSString *sightingUrl = [NSString stringWithFormat:@"%@/species?%@&%@", [BBConstants RootUriString], query, @"X-Requested-With=XMLHttpRequest"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager loadObjectsAtResourcePath:sightingUrl delegate:self];
}

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

#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)objectLoader:(RKObjectLoader *)objectLoader
   didFailWithError:(NSError *)error {
    [BBLog Log:@"BBClassificationBrowseController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
      didLoadObject:(id)object {
    [BBLog Log:@"BBClassificationBrowseController.objectLoader:didLoadObject"];
    
    if([object isKindOfClass:[BBClassificationPaginator class]]) {
        [self.controller displayRanks:((BBClassificationPaginator*)object).ranks];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader
didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBClassificationBrowseController.didLoadObjectDictionary"];
    
}

-(void)dealloc {
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}


@end