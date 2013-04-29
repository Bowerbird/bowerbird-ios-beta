/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBIdentifySightingEdit.h"
#import "BBValidationError.h"


@implementation BBIdentifySightingEdit


#pragma mark -
#pragma mark - Member Accessors


@synthesize sightingId = _sightingId,
            taxonomy = _taxonomy,
            isCustomIdentification = _isCustomIdentification,
            category = _category,
            kingdom = _kingdom,
            phylum = _phylum,
            klass = _klass,
            order = _order,
            family = _family,
            genus = _genus,
            species = _species,
            subSpecies = _subSpecies,
            commonGroupNames = _commonGroupNames,
            commonNames = _commonNames,
            errors = _errors;


-(NSString*)sightingId { return _sightingId; }
-(void)setSightingId:(NSString *)sightingId { _sightingId = sightingId; }
-(NSString*)taxonomy { return _taxonomy; }
-(void)setTaxonomy:(NSString *)taxonomy { _taxonomy = taxonomy; }
-(BOOL)isCustomIdentification { return _isCustomIdentification; }
-(void)setIsCustomIdentification:(BOOL)isCustomIdentification { _isCustomIdentification = isCustomIdentification; }
-(void)setCategory:(NSString *)category { _category = category; }
-(NSString*)category { return _category; }
-(void)setKingdom:(NSString *)kingdom { _kingdom = kingdom; }
-(NSString*)kingdom { return _kingdom; }
-(void)setPhylum:(NSString *)phylum { _phylum = phylum; }
-(NSString*)phylum { return _phylum; }
-(void)setKlass:(NSString *)klass { _klass = klass; }
-(NSString*)klass { return _klass; }
-(void)setOrder:(NSString *)order { _order = order; }
-(NSString*)order { return _order; }
-(void)setFamily:(NSString *)family { _family = family; }
-(NSString*)family { return _family; }
-(void)setGenus:(NSString *)genus { _genus = genus; }
-(NSString*)genus { return _genus; }
-(void)setSpecies:(NSString *)species { _species = species; }
-(NSString*)species { return _species; }
-(void)setSubSpecies:(NSString *)subSpecies { _subSpecies = subSpecies; }
-(NSString*)subSpecies { return _subSpecies; }
-(void)setCommonGroupNames:(NSMutableArray *)commonGroupNames { _commonGroupNames = commonGroupNames; }
-(NSMutableArray*)commonGroupNames { return _commonGroupNames; }
-(NSUInteger)countOfCommonGroupNames { return [_commonGroupNames count]; }
-(id)objectInCommonGroupNamesAtIndex:(NSUInteger)index { return [_commonGroupNames objectAtIndex:index]; }
-(void)addCommonGroupNamesObject:(NSString*)commonGroupName { [_commonGroupNames addObject:commonGroupName]; }
-(void)setCommonNames:(NSMutableArray *)commonNames { _commonNames = commonNames; }
-(NSMutableArray*)commonNames { return _commonNames; }
-(NSUInteger)countOfCommonNames { return [_commonNames count]; }
-(id)objectInCommonNamesAtIndex:(NSUInteger)index { return [_commonNames objectAtIndex:index]; }
-(void)addCommonNamesObject:(NSString*)commonName { [_commonNames addObject:commonName]; }
-(BBValidationError*)errors { return _errors; }
-(void)setErrors:(BBValidationError *)errors { _errors = errors; }


#pragma mark -
#pragma mark - Constructors


-(BBIdentifySightingEdit*)initWithSightingId:(NSString *)sightingId {
    self = [super init];
    
    if(self) _sightingId = sightingId;
    
    return self;
}


#pragma mark -
#pragma mark - Methods


-(void)setCustomIdentification:(NSDictionary*)customId {
    _isCustomIdentification = YES;
    _category = [customId objectForKey:@"category"];
    _kingdom = [customId objectForKey:@"kingdom"];
    _phylum = [customId objectForKey:@"phylum"];
    _klass = [customId objectForKey:@"klass"];
    _order = [customId objectForKey:@"order"];
    _family = [customId objectForKey:@"family"];
    _genus = [customId objectForKey:@"genus"];
    _species = [customId objectForKey:@"species"];
    _subSpecies = [customId objectForKey:@"subSpecies"];
    _commonGroupNames = [customId objectForKey:@"commonGroupNames"];
    _commonNames = [customId objectForKey:@"commonNames"];
}


@end