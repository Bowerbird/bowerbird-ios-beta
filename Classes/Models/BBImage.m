/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBImage.h"


@implementation BBImage


#pragma mark -
#pragma mark - Member Accessors


@synthesize     mimeType = _mimeType,
                original = _original;


-(void)setMimeType:(NSString *)mimeType { _mimeType = mimeType; }
-(NSString*)mimeType { return _mimeType; }
-(void)setOriginal:(NSMutableDictionary *)original { _original = original; }
-(NSMutableDictionary*)original { return _original; }
-(NSUInteger)countOfOriginal { return [self.original count]; }
-(NSEnumerator*)enumeratorOfOriginal { return [self.original objectEnumerator]; }
-(NSString*)memberOfOriginal:(NSString *)object { return [self.original objectForKey:object]; }


@end