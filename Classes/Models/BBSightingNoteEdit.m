/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingNoteEdit.h"


@implementation BBSightingNoteEdit


#pragma mark -
#pragma mark - Member Accessors


@synthesize taxonomy = _taxonomy,
            descriptions = _descriptions,
            tags = _tags,
            sightingId = _sightingId;


-(NSString*)sightingId { return _sightingId; }
-(void)setSightingId:(NSString *)sightingId { _sightingId = sightingId; }
-(NSString*)taxonomy { return _taxonomy; }
-(void)setTaxonomy:(NSString *)taxonomy { _taxonomy = taxonomy; }
-(NSMutableDictionary*)descriptions {
    if(!_descriptions) _descriptions = [[NSMutableDictionary alloc]init];
    return _descriptions;
}
-(void)setDescriptions:(NSMutableDictionary *)descriptions { _descriptions = descriptions; }
-(void)addDescriptionsKey:(NSString*)key value:(NSString*)value { [self.descriptions setObject:value forKey:key]; }
-(void)removeDescriptionsKey:(NSString*)key { [self.descriptions removeObjectForKey:key]; }
-(NSMutableSet*)tags {
    if(!_tags)_tags = [[NSMutableSet alloc]init];
    return _tags;
}
-(void)setTags:(NSMutableSet *)tags { _tags = tags; }
-(void)addTag:(NSString *)tag { [self.tags addObject:tag]; }
-(void)removeTag:(NSString *)tag { [self.tags removeObject:tag]; }


#pragma mark -
#pragma mark - Constructors


-(BBSightingNoteEdit*)initWithSightingId:(NSString*)sightingId {
    self = [super init];
    
    _sightingId = sightingId;
    
    return self;
}


@end