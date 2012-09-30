/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBAudio

@synthesize     dimensionName = _dimensionName,
uri = _uri,
width = _width,
height = _height,
mimeType = _mimeType;


-(void)dimensionName:(NSString *)dimensionName
{
    _dimensionName = dimensionName;
}
-(NSString*)dimensionName
{
    return _dimensionName;
}


-(void)setUri:(NSString *)uri
{
    _uri = uri;
}
-(NSString*)uri
{
    return _uri;
}


-(void)setWidth:(NSNumber *)width
{
    _width = width;
}
-(NSNumber*)width
{
    return _width;
}


-(void)setHeight:(NSNumber *)height
{
    _height = height;
}
-(NSNumber*)height
{
    return _height;
}


-(void)setMimeType:(NSString *)mimeType
{
    _mimeType = mimeType;
}
-(NSString*)mimeType
{
    return _mimeType;
}


- (void)setNilValueForKey:(NSString *)theKey
{
    //    if ([theKey isEqualToString:@"hidden"]) {
    //        [self setValue:@YES forKey:@"hidden"];
    //    }
    //    else {
    //        [super setNilValueForKey:theKey];
    //    }
}


@end