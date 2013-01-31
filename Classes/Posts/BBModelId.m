/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBModelId.h"


@implementation BBModelId


#pragma mark -
#pragma mark - Member Accessors


@synthesize identifier = _identifier;


-(NSString*)identifier { return _identifier; }
-(void)setIdentifier:(NSString *)identifier { _identifier = identifier; }
- (void)setValue:(id)value forUndefinedKey:(NSString *)key { if([key isEqualToString:@"Id"]) self.identifier = value; }


#pragma mark -
#pragma mark - Constructors


-(id)initWithId:(NSString*)identifier {
    self = [super init];
    
    if(self) {
        _identifier = identifier;
    }
    
    return self;
}


@end