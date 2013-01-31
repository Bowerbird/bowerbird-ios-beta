/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBUser.h"


@implementation BBUser


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier,
            name = _name,
            avatar = _avatar;


-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
-(NSString*)identifier { return _identifier; }
-(void)setName:(NSString *)name { _name = name; }
-(NSString*)name { return _name; }
-(void)setAvatar:(BBMediaResource *)avatar { _avatar = avatar; }
-(BBMediaResource*)avatar { return _avatar; }
-(void)setNilValueForKey:(NSString *)theKey { }
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"Id"]) self.identifier = value;
}


@end