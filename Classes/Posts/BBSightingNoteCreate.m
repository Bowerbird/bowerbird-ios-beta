/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingNoteCreate.h"
#import "BBSightingNoteDescriptionCreate.h"


@implementation BBSightingNoteCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            sightingId = _sightingId,
            descriptions = _descriptions,
            tags = _tags,
            comments = _comments,
            errors = _errors;


-(NSString*)identifier { return _identifier; }
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)sightingId { return _sightingId; }
-(void)setSightingId:(NSString *)sightingId { _sightingId = sightingId; }
-(NSMutableArray*)descriptions { return _descriptions; }
-(void)setDescriptions:(NSMutableArray *)descriptions { _descriptions = descriptions; }
-(NSUInteger)countOfDescriptions { return [_descriptions count]; }
-(id)objectInDescriptionsAtIndex:(NSUInteger)index { return [_descriptions objectAtIndex:index]; }
-(void)addDescription:(BBSightingNoteDescriptionCreate*)description { [_descriptions addObject:description]; }
-(NSString*)tags { return _tags; }
-(void)setTags:(NSString *)tags { _tags = tags; }
-(NSString*)comments { return _comments; }
-(void)setComments:(NSString *)comments { _comments = comments; }
-(BBValidationError*)errors { return _errors; }
-(void)setErrors:(BBValidationError *)errors { _errors = errors; }


@end