/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBObservation

@synthesize     identifier = _identifier,
                     title = _title,
            observedOnDate = _observedOnDate,
                   address = _address,
                  latitude = _latitude,
                 longitude = _longitude,
                  category = _category,
  isIdentificationRequired = _isIdentificationRequired,
         anonymiseLocation = _anonymiseLocation,
                     media = _media,
              primaryMedia = _primaryMedia,
                      user = _user,
                  comments = _comments,
                projectIds = _projectIds;


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}
-(NSString*)identifier
{
    return _identifier;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
}
-(NSString*)title
{
    return _title;
}


-(void)setObservedOnDate:(NSDate *)observedOnDate
{
    _observedOnDate = observedOnDate;
}
-(NSDate*)observedOnDate
{
    return _observedOnDate;
}


-(void)setAddress:(NSString *)address
{
    _address = address;
}
-(NSString*)address
{
    return _address;
}


-(void)setLatitude:(float)latitude
{
    _latitude = latitude;
}
-(float)latitude
{
    return _latitude;
}


-(void)setLongitude:(float)longitude
{
    _longitude = longitude;
}
-(float)longitude
{
    return _longitude;
}


-(void)setCategory:(NSString *)category
{
    _category = category;
}
-(NSString*)category
{
    return _category;
}


-(void)setIsIdentificationRequired:(BOOL)isIdentificationRequired
{
    _isIdentificationRequired = isIdentificationRequired;
}

-(BOOL)isIdentificationRequired
{
    return _isIdentificationRequired;
}


-(void)setAnonymiseLocation:(BOOL)anonymiseLocation
{
    _anonymiseLocation = anonymiseLocation;
}
-(BOOL)anonymiseLocation
{
    return _anonymiseLocation;
}


-(void)setMedia:(NSSet *)media
{
    _media = media;
}
-(NSSet*)media
{
    if(!_media)_media = [[NSSet alloc]init];
    return _media;
}
-(NSUInteger)countOfMedia
{
    return [self.media count];
}
-(NSEnumerator*)enumeratorOfMedia
{
    return [self.media objectEnumerator];
}
-(BBMediaResource*)memberOfMedia:(BBMediaResource *)object
{
    return [self.media member:object];
}


-(void)setPrimaryMedia:(BBMediaResource *)primaryMedia
{
    _primaryMedia = primaryMedia;
}
-(BBMediaResource*)primaryMedia
{
    return _primaryMedia;
}


-(void)setUser:(BBUser *)user
{
    _user = user;
}
-(BBUser *)user
{
    return _user;
}


-(void)setComments:(NSArray *)comments
{
    _comments = comments;
}
-(NSArray*)comments
{
    if(!_comments) _comments = [[NSArray alloc]init];
    return _comments;
}
-(NSUInteger)countOfComments
{
    return [self.comments count];
}
-(id)objectInCommentsAtIndex:(NSUInteger)index
{
    return [_comments objectAtIndex:index];
}


-(void)setProjectIds:(NSSet *)projectIds
{
    _projectIds = projectIds;
}
-(NSSet*)projectIds
{
    if(!_projectIds)_projectIds = [[NSSet alloc]init];
    return _projectIds;
}
-(NSUInteger)countOfProjectIds
{
    return [self.projectIds count];
}
-(NSEnumerator*)enumeratorOfProjectIds
{
    return [self.projectIds objectEnumerator];
}
-(NSString*)memberOfProjectIds:(NSString *)object
{
    return [self.projectIds member:object];
}


- (void)setNilValueForKey:(NSString *)theKey
{
    if ([theKey isEqualToString:@"isIdentificationRequired"]) {
        [self setValue:@"YES" forKey:@"isIdentificationRequired"];
    }
    else if([theKey isEqualToString:@"anonymiseLocation"]){
        [self setValue:@"NO" forKey:@"anonymiseLocation"];
    }
    else {
        [super setNilValueForKey:theKey];
    }
}


@end