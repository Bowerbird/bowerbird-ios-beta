/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMedia.h"

@implementation BBMedia

@synthesize     mediaResource = _mediaResource,
                  description = _description,
               isPrimaryMedia = _isPrimaryMedia,
                      licence = _licence;


-(void)setMediaResource:(BBMediaResource *)mediaResource
{
    _mediaResource = mediaResource;
}
-(BBMediaResource*)mediaResource
{
    return _mediaResource;
}


-(void)setDescription:(NSString *)description
{
    _description = description;
}
-(NSString*)description
{
    return _description;
}


-(void)setIsPrimaryMedia:(BOOL)isPrimaryMedia
{
    _isPrimaryMedia = isPrimaryMedia;
}
-(BOOL)isPrimaryMedia
{
    return _isPrimaryMedia;
}


-(void)setLicence:(NSString *)licence
{
    _licence = licence;
}
-(NSString*)licence
{
    return _licence;
}


@end