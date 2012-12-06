/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBObservation.h"

@implementation BBObservation

@synthesize     isIdentificationRequired = _isIdentificationRequired,
                                   media = _media,
                            primaryMedia = _primaryMedia,
                                   notes = _notes;


-(void)setIsIdentificationRequired:(BOOL)isIdentificationRequired
{
    _isIdentificationRequired = isIdentificationRequired;
}
-(BOOL)isIdentificationRequired
{
    return _isIdentificationRequired;
}


// change from an NSSet to an NSArray
-(void)setMedia:(NSArray *)media
{
    _media = media;
}
-(NSArray*)media
{
    if(!_media)_media = [[NSArray alloc]init];
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
//-(BBMediaResource*)memberOfMedia:(BBMediaResource *)object
//{
//    return [self.media member:object];
//}


-(void)setPrimaryMedia:(BBMedia *)primaryMedia
{
    _primaryMedia = primaryMedia;
}
-(BBMedia*)primaryMedia
{
    return _primaryMedia;
}


-(void)setNotes:(NSArray *)notes
{
    _notes = notes;
}
-(NSArray*)notes
{
    if(!_notes) _notes = [[NSArray alloc]init];
    return _notes;
}
-(NSUInteger)countOfNotes
{
    return [_notes count];
}
-(id)objectInNotesAtIndex:(NSUInteger)index
{
    return [_notes objectAtIndex:index];
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