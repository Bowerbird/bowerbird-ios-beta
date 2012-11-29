//
//  BBIdentification.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 23/11/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBIdentification.h"

@implementation BBIdentification

@synthesize     isCustomIdentification = _isCustomIdentification,
                              category = _category,
                                  name = _name,
                              rankName = _rankName,
                              rankType = _rankType,
                      commonGroupNames = _commonGroupNames,
                           commonNames = _commonNames,
                              taxonomy = _taxonomy,
                        taxonomicRanks = _taxonomicRanks,
                              synonyms = _synonyms,
                        allCommonNames = _allCommonNames;


-(BOOL)isCustomIdentification {
    return _isCustomIdentification;
}
-(void)setIsCustomIdentification:(BOOL)isCustomIdentification {
    _isCustomIdentification = isCustomIdentification;
}


-(NSString*)category {
    return  _category;
}
-(void)setCategory:(NSString *)category {
    _category = category;
}


-(NSString*)name {
    return _name;
}
-(void)setName:(NSString*)name {
    _name = name;
}


-(NSString*)rankName {
    return _rankName;
}
-(void)setRankName:(NSString*)rankName {
    _rankName = rankName;
}


-(NSString*)rankType {
    return _rankType;
}
-(void)setRankType:(NSString *)rankType {
    _rankType = rankType;
}


-(void)setCommonGroupNames:(NSArray *)commonGroupNames {
    _commonGroupNames = commonGroupNames;
}
-(NSArray*)commonGroupNames {
    if(!_commonGroupNames)_commonGroupNames = [[NSArray alloc]init];
    return _commonGroupNames;
}
-(NSUInteger)countOfCommonGroupNames {
    return [_commonGroupNames count];
}
-(NSEnumerator*)enumeratorOfCommonGroupNames {
    return [_commonGroupNames objectEnumerator];
}


-(NSString*)taxonomy {
    return _taxonomy;
}
-(void)setTaxonomy:(NSString *)taxonomy {
    _taxonomy = taxonomy;
}


-(void)setTaxonomicRanks:(NSArray *)taxonomicRanks {
    _taxonomicRanks = taxonomicRanks;
}
-(NSArray*)taxonomicRanks {
    if(!_taxonomicRanks)_taxonomicRanks = [[NSArray alloc]init];
    return _taxonomicRanks;
}
-(NSUInteger)countOfTaxonomicRanks {
    return [_taxonomicRanks count];
}
-(NSEnumerator*)enumeratorOfTaxonomicRanks {
    return [_taxonomicRanks objectEnumerator];
}


-(void)setSynonyms:(NSArray *)synonyms {
    _synonyms = synonyms;
}
-(NSArray*)synonyms {
    if(!_synonyms)_synonyms = [[NSArray alloc]init];
    return _synonyms;
}
-(NSUInteger)countOfSynonyms {
    return [_synonyms count];
}
-(NSEnumerator*)enumeratorOfSynonyms {
    return [_synonyms objectEnumerator];
}


-(NSString*)allCommonNames {
    return _allCommonNames;
}
-(void)setAllCommonNames:(NSString *)allCommonNames {
    _allCommonNames = allCommonNames;
}

@end