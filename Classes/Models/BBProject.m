/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBProject.h"


@implementation BBProject


#pragma mark -
#pragma mark - Member Accessors


@synthesize observationCount = _observationCount;


-(void)setObservationCount:(int)observationCount { _observationCount  = observationCount; }
-(int)observationCount { return _observationCount; }


@end