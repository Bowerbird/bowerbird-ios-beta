/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProjectId.h"
#import "BBHelpers.h"
#import "BBJsonResponse.h"


@implementation BBProjectId


#pragma mark -
#pragma mark - Member Constructors


-(id)initWithProjectId:(NSString *)identifier {
    self = [super initWithId:identifier];
    
    if(self) {
        self.identifier = identifier;
    }
    
    return self;
}


@end