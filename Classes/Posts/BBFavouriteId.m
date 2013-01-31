/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBFavouriteId.h"


@implementation BBFavouriteId


#pragma mark -
#pragma mark - Constructors


-(id)initWithObservationId:(NSString*)identifier {
    
    self = [super initWithId:identifier];
    
    return self;
}


@end