/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBActivity.h"


@implementation BBActivity


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            type = _type,
            createdOn = _createdOn,
            order = _order,
            description = _description,
            user = _user,
            groups = _groups,
            observation = _observation,
            post = _post,
            observationNote = _observationNote,
            observationNoteObservation = _observationNoteObservation,
            identificationObservation = _identificationObservation,
            identification = _identification;


-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)identifier { return _identifier; }
-(void)setType:(NSString *)type { _type = type; }
-(NSString*)type { return _type; }
-(void)setCreatedOn:(NSDate *)createdOn { _createdOn = createdOn; }
-(NSDate*)createdOn { return _createdOn; }
-(void)setOrder:(NSString *)order { _order = order; }
-(NSString*)order { return _order; }
-(void)setDescription:(NSString *)description { _description = description; }
-(NSString*)description { return _description; }
-(void)setUser:(BBUser *)user { _user = user; }
-(BBUser*)user { return _user; }
-(void)setGroups:(NSSet *)groups { _groups = groups; }
-(NSSet*)groups { if(!_groups) _groups = [[NSSet alloc]init]; return _groups; }
-(NSUInteger)countOfGroups { return [self.groups count]; }
-(NSEnumerator *)enumeratorOfGroups { return [self.groups objectEnumerator]; }
-(BBGroup*)memberOfGroups:(BBGroup *)object { return [self.groups member:object]; }
-(void)setObservation:(BBObservation *)observation { _observation = observation; }
-(BBObservation*)observation { return _observation; }
-(void)setObservationNoteObservation:(BBObservation *)observationNoteObservation { _observationNoteObservation = observationNoteObservation; }
-(BBObservation*)observationNoteObservation { return _observationNoteObservation; }
-(void)setIdentificationObservation:(BBObservation*)identificationObservation { _identificationObservation = identificationObservation; }
-(BBObservation*)identificationObservation { return _identificationObservation; }
-(void)setIdentification:(BBIdentification *)identification { _identification = identification; }
-(BBIdentification*)identification { return _identification; }
-(void)setPost:(BBPost *)post { _post = post; }
-(BBPost*)post { return _post; }
- (void)setNilValueForKey:(NSString *)theKey { }


@end