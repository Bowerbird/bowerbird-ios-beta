/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBCategory.h"


@implementation BBCategory


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            name = _name,
            taxonomy = _taxonomy;


-(NSString*)identifier { return _identifier; }
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)name { return _name; }
-(void)setName:(NSString *)name { _name = name; }
-(NSString*)taxonomy { return _taxonomy; }
-(void)setTaxonomy:(NSString *)taxonomy { _taxonomy = taxonomy; }
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"Id"]) self.identifier = value;
}


@end