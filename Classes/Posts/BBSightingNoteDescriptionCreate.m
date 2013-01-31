/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingNoteDescriptionCreate.h"


@implementation BBSightingNoteDescriptionCreate


#pragma mark -
#pragma mark - Member Accessors


@synthesize key = _key,
          value = _value;


-(NSString*)key { return _key; }
-(void)setKey:(NSString *)key { _key = key; }
-(NSString*)value { return _value; }
-(void)setValue:(NSString *)value { _value = value; }


@end