/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBControllerBase.h"


@class BBObservation, BBObservationNote, BBIdentification;


@interface BBVoteController : BBControllerBase

-(id)initWithObservation:(BBObservation*)observation;
-(id)initWithObservationNote:(BBObservationNote*)observationNote;
-(id)initWithIdentification:(BBIdentification*)identification;

@end