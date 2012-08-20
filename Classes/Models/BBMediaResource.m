/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMediaResource.h"

@implementation BBMediaResource

@synthesize     identifier = _identifier,
                 mediaType = _mediaType,
                uploadedOn = _uploadedOn,
                  metaData = _metaData,
                   //image = _image,
                     media = _media,
                      user = _user,
               description = _description,
                   licence = _licence,
                       key = _key,
            isPrimaryMedia = _isPrimaryMedia;


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}
-(NSString*)identifier
{
    return _identifier;
}


-(void)setMediaType:(NSString *)mediaType
{
    _mediaType = mediaType;
}
-(NSString*)mediaType
{
    return _mediaType;
}


-(void)setUploadedOn:(NSDate *)uploadedOn
{
    _uploadedOn = uploadedOn;
}
-(NSDate*)uploadedOn
{
    return _uploadedOn;
}


-(void)setMetaData:(NSDictionary *)metaData
{
    _metaData = metaData;
}
-(NSDictionary*)metaData
{
    if(!_metaData) _metaData = [[NSDictionary alloc]init];
    return _metaData;
}
-(NSUInteger)countOfMetaData
{
    return [self.metaData count];
}
-(NSEnumerator*)enumeratorOfMetaData
{
    return [self.metaData objectEnumerator];
}
-(NSString*)memberOfMetaData:(NSString *)object
{
    return [self.metaData objectForKey:object];
}


-(void)setMedia:(NSDictionary *)media
{
    _media = media;
}
-(NSDictionary*)media
{
    if(!_media)_media = [[NSDictionary alloc]init];
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
-(NSString*)memberOfMedia:(NSString *)object
{
    return [self.media objectForKey:object];
}


//-(void)setImage:(BBImage *)image
//{
//    _image = image;
//}
//-(BBImage*)image
//{
//    return _image;
//}


-(void)setUser:(BBUser *)user
{
    _user = user;
}
-(BBUser*)user
{
    return _user;
}


-(void)setDescription:(NSString *)description
{
    _description = description;
}
-(NSString*)description
{
    return _description;
}


-(void)setLicence:(NSString *)licence
{
    _licence = licence;
}
-(NSString*)licence
{
    return _licence;
}


-(void)setKey:(NSString *)key
{
    _key = key;
}
-(NSString*)key
{
    return _key;
}


- (void)setNilValueForKey:(NSString *)theKey
{
    if ([theKey isEqualToString:@"isPrimaryMedia"]) {
        [self setValue:@"NO" forKey:@"isPrimaryMedia"];
    }
    else {
        [super setNilValueForKey:theKey];
    }
}


@end