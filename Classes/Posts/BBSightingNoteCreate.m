//
//  BBSightingNoteCreate.m
//  BowerBird Beta
//
//  Created by Hamish Crittenden on 7/12/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "BBSightingNoteCreate.h"

@implementation BBSightingNoteCreate

@synthesize   identifier = _identifier,
  isCustomIdentification = _isCustomIdentification,
              sightingId = _sightingId,
            descriptions = _descriptions,
                    tags = _tags,
                taxonomy = _taxonomy;


-(NSString*)identifier {
    return _identifier;
}
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}


-(BOOL)isCustomIdentification {
    return _isCustomIdentification;
}
-(void)setIsCustomIdentification:(BOOL)isCustomIdentification {
    _isCustomIdentification = isCustomIdentification;
}


-(NSString*)sightingId {
    return _sightingId;
}
-(void)setSightingId:(NSString *)sightingId {
    _sightingId = sightingId;
}


-(NSMutableArray*)descriptions {
    return _descriptions;
}
-(void)setDescriptions:(NSMutableArray *)descriptions {
    _descriptions = descriptions;
}
-(NSUInteger)countOfDescriptions
{
    return [_descriptions count];
}
-(id)objectInDescriptionsAtIndex:(NSUInteger)index
{
    return [_descriptions objectAtIndex:index];
}
-(void)addDescription:(BBSightingNoteDescriptionCreate*)description {
    [_descriptions addObject:description];
}


-(NSString*)tags {
    return _tags;
}
-(void)setTags:(NSString *)tags {
    _tags = tags;
}


-(NSString*)taxonomy {
    return _taxonomy;
}
-(void)setTaxonomy:(NSString *)taxonomy {
    _taxonomy = taxonomy;
}


@end