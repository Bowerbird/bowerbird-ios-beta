/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBObservationNote.h"

@implementation BBObservationNote

@synthesize identifier = _identifier;
@synthesize createdOn = _createdOn;
@synthesize identification = _identification;
@synthesize taxonomy = _taxonomy;
@synthesize descriptions = _descriptions;
@synthesize tags = _tags;
@synthesize user = _user;
@synthesize allTags = _allTags;
@synthesize tagCount = _tagCount;
@synthesize descriptionCount = _descriptionCount;


-(NSString*)identifier {
    return _identifier;
}
-(void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}


-(NSDate*)createdOn {
    return _createdOn;
}
-(void)setCreatedOn:(NSDate *)createdOn {
    _createdOn = createdOn;
}


-(BBIdentification*)identification {
    return _identification;
}
-(void)setIdentification:(BBIdentification *)identification {
    _identification = identification;
}


-(NSString*)taxonomy {
    return _taxonomy;
}
-(void)setTaxonomy:(NSString *)taxonomy {
    _taxonomy = taxonomy;
}


-(NSArray*)descriptions {
    return _descriptions;
}
-(void)setDescriptions:(NSArray *)descriptions {
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


-(NSArray*)tags {
    return _descriptions;
}
-(void)setTags:(NSArray *)tags {
    _tags = tags;
}
-(NSUInteger)countOfTags
{
    return [_tags count];
}
-(id)objectInTagsAtIndex:(NSUInteger)index
{
    return [_tags objectAtIndex:index];
}


-(BBUser*)user {
    return _user;
}
-(void)setUser:(BBUser *)user {
    _user = user;
}


-(int)tagCount {
    return _tagCount;
}
-(void)setTagCount:(int)tagCount{
    _tagCount = tagCount;
}


-(int)descriptionCount {
    return _descriptionCount;
}
-(void)setDescriptionCount:(int)descriptionCount {
    _descriptionCount = descriptionCount;
}


-(NSString*)allTags {
    return _allTags;
}
-(void)setAllTags:(NSString *)allTags {
    _allTags = allTags;
}

@end