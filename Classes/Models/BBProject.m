/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBModels.h"

@implementation BBProject

@synthesize observationCount = _observationCount;

-(void)setObservationCount:(int)observationCount
{
    _observationCount  = observationCount;
}
-(int)observationCount
{
    return _observationCount;
}

@end