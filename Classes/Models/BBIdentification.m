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
                              synonyms = _synonyms,
                        allCommonNames = _allCommonNames,
                            identifier = _identifier,
                            sightingId = _sightingId,
                              comments = _comments,
                  createdOnDescription = _createdOnDescription,
                                 ranks = _ranks,
                        totalVoteScore = _totalVoteScore,
                         userVoteScore = _userVoteScore,
                                  user = _user;


-(void)setSightingId:(NSString *)sightingId {
    _sightingId = sightingId;
}
-(NSString*)sightingId {
    return _sightingId;
}

-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}
-(NSString*)identifier {
    return _identifier;
}

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

-(NSString*)createdOnDescription {
    return _createdOnDescription;
}
-(void)setCreatedOnDescription:(NSString *)createdOnDescription {
    _createdOnDescription = createdOnDescription;
}

-(NSNumber*)totalVoteScore {
    return _totalVoteScore;
}
-(void)setTotalVoteScore:(NSNumber *)totalVoteScore {
    _totalVoteScore = totalVoteScore;
}

-(NSNumber*)userVoteScore {
    return _userVoteScore;
}
-(void)setUserVoteScore:(NSNumber *)userVoteScore {
    _userVoteScore = userVoteScore;
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

-(void)setCommonNames:(NSArray *)commonNames {
    _commonNames = commonNames;
}
-(NSArray*)commonNames {
    if(!_commonNames)_commonNames = [[NSArray alloc]init];
    return _commonNames;
}
-(NSUInteger)countOfCommonNames {
    return [_commonNames count];
}
-(NSEnumerator*)enumeratorOfCommonNames {
    return [_commonNames objectEnumerator];
}

-(void)setComments:(NSString *)comments {
    _comments = comments;
}
-(NSString*)comments {
    return _comments;
}

-(NSString*)taxonomy {
    return _taxonomy;
}
-(void)setTaxonomy:(NSString *)taxonomy {
    _taxonomy = taxonomy;
}

-(void)setRanks:(NSArray *)ranks {
    _ranks = ranks;
}
-(NSArray*)ranks {
    if(!_ranks)_ranks = [[NSArray alloc]init];
    return _ranks;
}
-(NSUInteger)countOfRanks {
    return [_ranks count];
}
-(NSEnumerator*)enumeratorOfRanks {
    return [_ranks objectEnumerator];
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

-(void)setUser:(BBUser *)user {
    _user = user;
}
-(BBUser *)user {
    return _user;
}

@end