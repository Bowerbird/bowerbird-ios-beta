/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMediaEdit.h"


@implementation BBMediaEdit


#pragma mark -
#pragma mark - Member Accessors


@synthesize description = _description,
            image = _image,
            isPrimaryImage = _isPrimaryImage,
            licence = _licence,
            key = _key;


-(NSString*)key { return _key; }
-(void)setKey:(NSString *)key { _key = key; }
-(NSString*)description { return _description; }
-(void)setDescription:(NSString *)description { _description = description; }
-(UIImage*)image { return _image; }
-(void)setImage:(UIImage *)image { _image = image; }
-(BOOL)isPrimaryImage { return _isPrimaryImage; }
-(void)setIsPrimaryImage:(BOOL)isPrimaryImage { _isPrimaryImage = isPrimaryImage; }
-(NSString*)licence { return _licence; }
-(void)setLicence:(NSString *)licence { _licence = licence; }


#pragma mark -
#pragma mark - Constructors


-(BBMediaEdit*)initWithImage:(UIImage*)image {
    self = [super init];
    
    _image = image;
    _key = [BBGuidGenerator generateGuid];
    
    return self;
}


@end