/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBObservation

@synthesize     isIdentificationRequired = _isIdentificationRequired,
                                   media = _media,
                            primaryMedia = _primaryMedia;


-(void)setIsIdentificationRequired:(BOOL)isIdentificationRequired
{
    _isIdentificationRequired = isIdentificationRequired;
}
-(BOOL)isIdentificationRequired
{
    return _isIdentificationRequired;
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


- (void)setNilValueForKey:(NSString *)theKey
{
    if ([theKey isEqualToString:@"isIdentificationRequired"]) {
        [self setValue:@"YES" forKey:@"isIdentificationRequired"];
    }
    else {
        [super setNilValueForKey:theKey];
    }
}


@end