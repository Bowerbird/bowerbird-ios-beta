/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassification.h"
#import "BBHelpers.h"
#import "SVProgressHUD.h"
#import "BBClassificationPaginator.h"


@implementation BBClassification


#pragma mark -
#pragma mark - Member Accessors


@synthesize taxonomy = _taxonomy,
            name = _name,
            rankPosition = _rankPosition,
            rankName = _rankName,
            rankType = _rankType,
            parentRankName = _parentRankName,
            ranks = _ranks,
            category = _category,
            speciesCount = _speciesCount,
            commonGroupNames = _commonGroupNames,
            commonNames = _commonNames,
            synonyms = _synonyms,
            allCommonNames = _allCommonNames,
            controller = _controller,
            query = _query;


-(NSString*)taxonomy { return _taxonomy; }
-(void)setTaxonomy:(NSString *)taxonomy { _taxonomy = taxonomy; }
-(NSString*)name { return _name; }
-(void)setName:(NSString*)name { _name = name; }
-(int)rankPosition { return _rankPosition; }
-(void)setRankPosition:(int)rankPosition { _rankPosition = rankPosition; }
-(NSString*)rankName { return _rankName; }
-(void)setRankName:(NSString*)rankName { _rankName = rankName; }
-(NSString*)rankType { return _rankType; }
-(void)setRankType:(NSString *)rankType { _rankType = rankType; }
-(NSString*)parentRankName { return _parentRankName; }
-(void)setParentRankName:(NSString *)parentRankName { _parentRankName = parentRankName; }
-(void)setRanks:(NSArray *)ranks { _ranks = ranks; }
-(NSArray*)ranks {
    if(!_ranks)_ranks = [[NSArray alloc]init];
    return _ranks;
}
-(NSUInteger)countOfRanks { return [_ranks count]; }
-(NSEnumerator*)enumeratorOfRanks { return [_ranks objectEnumerator]; }
-(NSString*)category { return _category; }
-(void)setCategory:(NSString *)category { _category = category; }
-(int)speciesCount { return _speciesCount; }
-(void)setSpeciesCount:(int)speciesCount { _speciesCount = speciesCount; }
-(void)setCommonGroupNames:(NSArray *)commonGroupNames { _commonGroupNames = commonGroupNames; }
-(NSArray*)commonGroupNames {
    if(!_commonGroupNames)_commonGroupNames = [[NSArray alloc]init];
    return _commonGroupNames;
}
-(NSUInteger)countOfCommonGroupNames { return [_commonGroupNames count]; }
-(NSEnumerator*)enumeratorOfCommonGroupNames { return [_commonGroupNames objectEnumerator]; }
-(void)setCommonNames:(NSArray *)commonNames { _commonNames = commonNames; }
-(NSArray*)commonNames {
    if(!_commonNames)_commonNames = [[NSArray alloc]init];
    return _commonNames;
}
-(NSUInteger)countOfCommonNames { return [_commonNames count]; }
-(NSEnumerator*)enumeratorOfCommonNames { return [_commonNames objectEnumerator]; }
-(void)setSynonyms:(NSArray *)synonyms { _synonyms = synonyms; }
-(NSArray*)synonyms {
    if(!_synonyms)_synonyms = [[NSArray alloc]init];
    return _synonyms;
}
-(NSUInteger)countOfSynonyms { return [_synonyms count]; }
-(NSEnumerator*)enumeratorOfSynonyms { return [_synonyms objectEnumerator]; }
-(NSString*)allCommonNames { return _allCommonNames; }
-(void)setAllCommonNames:(NSString *)allCommonNames { _allCommonNames = allCommonNames; }


#pragma mark -
#pragma mark - Constructors


-(id)initWithDelegate:(id<BBRankDelegateProtocol>)delegate
             andQuery:(NSString*)text {
    self = [super init];
    
    if(self) {
        
        _controller = delegate;
        
        self.query = text;
        
        [self runClassificationQuery];
    }
    
    return self;
}


#pragma mark -
#pragma mark - Utilities and Helpers


-(void)runClassificationQuery {

    [[RKRequestQueue requestQueue] cancelRequestsWithDelegate:(id)self];

    // this is a candidate for subclassing BBClassificationPaginator as BBClassificationPaginatorSearch and hitting a predefined resourcePath pattern
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@/species?%@&%@", [BBConstants RootUriString], [NSString stringWithFormat:@"query=%@&pagesize=50", self.query], @"X-Requested-With=XMLHttpRequest"]
                                                      delegate:self];

}


#pragma mark -
#pragma mark - Delegation and Event Handling


-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [BBLog Log:@"BBClassificationSearchController.objectLoader:didFailWithError"];
    
    [BBLog Log:error.description];
    
    [SVProgressHUD showErrorWithStatus:error.description];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjectDictionary:(NSDictionary *)dictionary {
    [BBLog Log:@"BBClassificationSearchController.didLoadObjectDictionary"];
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    [BBLog Log:@"BBClassificationBrowseController.didLoadObject"];
    
    if([object isKindOfClass:[BBClassificationPaginator class]]) {
        [self.controller displayRanks:((BBClassificationPaginator*)object).ranks forQuery:self.query];
    }
}

-(void)dealloc {
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}


@end