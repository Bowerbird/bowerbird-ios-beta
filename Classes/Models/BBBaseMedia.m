/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBBaseMedia.h"


@implementation BBBaseMedia


#pragma mark -
#pragma mark - Member Accessors


@synthesize     dimensionName = _dimensionName,
                uri = _uri,
                width = _width,
                height = _height;


-(void)dimensionName:(NSString *)dimensionName { _dimensionName = dimensionName; }
-(NSString*)dimensionName { return _dimensionName; }
-(void)setUri:(NSString *)uri { _uri = uri; }
-(NSString*)uri { return _uri; }
-(void)setWidth:(NSNumber *)width { _width = width; }
-(NSNumber*)width { return _width; }
-(void)setHeight:(NSNumber *)height { _height = height; }
-(NSNumber*)height { return _height; }


@end