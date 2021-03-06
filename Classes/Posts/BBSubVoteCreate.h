/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "BBVoteCreate.h"


@class BBIdentification, BBObservationNote;


@interface BBSubVoteCreate : BBVoteCreate


-(BBSubVoteCreate*)initWithObservationNote:(BBObservationNote*)observationNote
                                  andScore:(NSNumber*)score;


-(BBSubVoteCreate*)initWithIdentification:(BBIdentification*)identification
                                 andScore:(NSNumber*)score;


@end