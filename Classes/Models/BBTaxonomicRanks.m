/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBTaxonomicRanks.h"


@implementation BBTaxonomicRanks


#pragma mark -
#pragma mark - Member Accessors


@synthesize name = _name;
@synthesize type = _type;


-(NSString*)name { return _name; }
-(void)setName:(NSString *)name { _name = name; }
-(NSString*)type{ return _type; }
-(void)setType:(NSString *)type { _type = type; }


@end