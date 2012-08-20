/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for notifying calling objects when the observation has finished loading
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@class BBObservation;

@protocol ObservationLoaded <NSObject>

-(void)ObservationHasFinishedLoading:(BBObservation*)observaiton;

@end
