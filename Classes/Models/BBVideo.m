/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBVideo.h"


@implementation BBVideo


#pragma mark -
#pragma mark - Member Accessors


@synthesize  original = _original;


-(void)setOriginal:(NSMutableDictionary *)original { _original = original; }
-(NSMutableDictionary*)original { return _original; }
-(NSUInteger)countOfOriginal { return [self.original count]; }
-(NSEnumerator*)enumeratorOfOriginal { return [self.original objectEnumerator]; }
-(NSString*)memberOfOriginal:(NSString *)object { return [self.original objectForKey:object]; }


@end