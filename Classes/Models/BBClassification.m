/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBClassification.h"


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
            allCommonNames = _allCommonNames;


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


@end