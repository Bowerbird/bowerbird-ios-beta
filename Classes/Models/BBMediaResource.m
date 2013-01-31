/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMediaResource.h"


@implementation BBMediaResource


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            mediaType = _mediaType,
            uploadedOn = _uploadedOn,
            metaData = _metaData,
            imageMedia = _imageMedia,
            audioMedia = _audioMedia,
            description = _description,
            licence = _licence,
            key = _key,
            isPrimaryMedia = _isPrimaryMedia;


-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)identifier { return _identifier; }
-(void)setMediaType:(NSString *)mediaType { _mediaType = mediaType; }
-(NSString*)mediaType { return _mediaType; }
-(void)setUploadedOn:(NSDate *)uploadedOn { _uploadedOn = uploadedOn; }
-(NSDate*)uploadedOn { return _uploadedOn; }
-(void)setMetaData:(NSDictionary *)metaData { _metaData = metaData; }
-(NSDictionary*)metaData {
    if(!_metaData) _metaData = [[NSDictionary alloc]init];
    return _metaData;
}
-(NSUInteger)countOfMetaData { return [self.metaData count]; }
-(NSEnumerator*)enumeratorOfMetaData { return [self.metaData objectEnumerator]; }
-(NSString*)memberOfMetaData:(NSString *)object { return [self.metaData objectForKey:object]; }
-(void)setImageMedia:(NSArray *)imageMedia { _imageMedia = imageMedia; }
-(NSArray*)imageMedia {
    if(!_imageMedia)_imageMedia = [[NSArray alloc]init];
    return _imageMedia;
}
-(NSUInteger)countOfImageMedia { return [self.imageMedia count]; }
-(id)objectInImageMediaAtIndex:(NSUInteger)index { return [self.imageMedia objectAtIndex:index]; }
-(void)setAudioMedia:(NSArray *)audioMedia { _audioMedia = audioMedia; }
-(NSArray*)audioMedia {
    if(!_audioMedia)_audioMedia = [[NSArray alloc]init];
    return _audioMedia;
}
-(NSUInteger)countOfAudioMedia { return [self.audioMedia count]; }
-(id)objectInAudioMediaAtIndex:(NSUInteger)index { return [self.audioMedia objectAtIndex:index]; }
-(void)setDescription:(NSString *)description { _description = description; }
-(NSString*)description { return _description; }
-(void)setLicence:(NSString *)licence { _licence = licence; }
-(NSString*)licence { return _licence; }
-(void)setKey:(NSString *)key { _key = key; }
-(NSString*)key { return _key; }
- (void)setNilValueForKey:(NSString *)theKey {
    if ([theKey isEqualToString:@"isPrimaryMedia"]) {
        [self setValue:@"NO" forKey:@"isPrimaryMedia"];
    }
    else {
        [super setNilValueForKey:theKey];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // Id is the serverside representation of identifier.. had to change because of keyword id.
    if([key isEqualToString:@"Id"]) self.identifier = value;
}


#pragma mark -
#pragma mark - Constructors


-(BBMediaResource*)initWithAvatarObject:(id)avatar {
    BBMediaResource* newAvatar = [[BBMediaResource alloc]init];
    
    return newAvatar;
}


@end