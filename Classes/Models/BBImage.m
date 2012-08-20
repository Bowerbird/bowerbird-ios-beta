/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBImage

@synthesize     identifier = _identifier,
        imageDimensionName = _imageDimensionName,
                  fileName = _fileName,
               relativeUri = _relativeUri,
                    format = _format,
                     width = _width,
                    height = _height,
                 extension = _extension,
                     image = _image,
          originalFileName = _originalFileName,
                  exifData = _exifData;


-(void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
}
-(NSString*)identifier
{
    return _identifier;
}


-(void)setImageDimensionName:(NSString *)imageDimensionName
{
    _imageDimensionName = imageDimensionName;
}
-(NSString*)imageDimensionName
{
    return _imageDimensionName;
}


-(void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
}
-(NSString*)fileName
{
    return _fileName;
}


-(void)setRelativeUri:(NSString *)relativeUri
{
    _relativeUri = relativeUri;
}
-(NSString*)relativeUri
{
    return _relativeUri;
}


-(void)setFormat:(NSString *)format
{
    _format = format;
}
-(NSString*)format
{
    return _format;
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


-(void)setExtension:(NSString *)extension
{
    _extension = extension;
}
-(NSString*)extension
{
    return _extension;
}


-(void)setImage:(UIImage *)image
{
    _image = image;
}
-(UIImage*)image
{
    return _image;
}


-(void)setOriginalFileName:(NSString *)originalFileName
{
    _originalFileName = originalFileName;
}
-(NSString*)originalFileName
{
    return _originalFileName;
}


-(void)setExifData:(NSDictionary *)exifData
{
    _exifData = exifData;
}
-(NSDictionary*)exifData
{
    if(!_exifData)_exifData = [[NSDictionary alloc]init];
    return _exifData;
}
-(NSUInteger)countOfExifData
{
    return [self.exifData count];
}
-(NSEnumerator*)enumeratorOfExifData
{
    return [self.exifData objectEnumerator];
}
-(NSString*)memberOfExifData:(NSString *)object
{
    return [self.exifData objectForKey:object];
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
