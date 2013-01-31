/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
-----------------------------------------------------------------------------------------------*/


#import "BBObservationNote.h"
#import "BBUser.h"


@implementation BBObservationNote


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            createdOn = _createdOn,
            createdOnDescription = _createdOnDescription,
            descriptions = _descriptions,
            tags = _tags,
            user = _user,
            sightingId = _sightingId,
            comments = _comments,
            allTags = _allTags,
            totalVoteScore = _totalVoteScore,
            userVoteScore = _userVoteScore,
            tagCount = _tagCount,
            descriptionCount = _descriptionCount;


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
-(NSString*)createdOnDescription {
    return _createdOnDescription;
}
-(void)setCreatedOnDescription:(NSString *)createdOnDescription {
    _createdOnDescription = createdOnDescription;
}
-(NSArray*)descriptions {
    return _descriptions;
}
-(void)setDescriptions:(NSArray *)descriptions {
    _descriptions = descriptions;
}
-(NSUInteger)countOfDescriptions {
    return [_descriptions count];
}
-(id)objectInDescriptionsAtIndex:(NSUInteger)index {
    return [_descriptions objectAtIndex:index];
}
-(NSArray*)tags {
    return _tags;
}
-(void)setTags:(NSArray *)tags {
    _tags = tags;
}
-(NSUInteger)countOfTags {
    return [_tags count];
}
-(id)objectInTagsAtIndex:(NSUInteger)index {
    return [_tags objectAtIndex:index];
}
-(BBUser*)user {
    return _user;
}
-(void)setUser:(BBUser *)user {
    _user = user;
}
-(NSString*)sightingId {
    return _sightingId;
}
-(void)setSightingId:(NSString *)sightingId {
    _sightingId = sightingId;
}
-(NSString*)comments {
    return _comments;
}
-(void)setComments:(NSString *)comments {
    _comments = comments;
}
-(NSNumber *)tagCount {
    return _tagCount;
}
-(void)setTagCount:(NSNumber *)tagCount{
    _tagCount = tagCount;
}
-(NSNumber *)descriptionCount {
    return _descriptionCount;
}
-(void)setDescriptionCount:(NSNumber *)descriptionCount {
    _descriptionCount = descriptionCount;
}
-(NSString*)allTags {
    return _allTags;
}
-(void)setAllTags:(NSString *)allTags {
    _allTags = allTags;
}
-(NSNumber *)totalVoteScore {
    return _totalVoteScore;
}
-(void)setTotalVoteScore:(NSNumber *)totalVoteScore {
    _totalVoteScore = totalVoteScore;
}
-(NSNumber *)userVoteScore {
    return _userVoteScore;
}
-(void)setUserVoteScore:(NSNumber *)userVoteScore {
    _userVoteScore = userVoteScore;
}


@end