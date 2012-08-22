/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 
 *> Use this protocol for notifying calling objects when the activity has finished loading
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@class BBActivity;

@protocol BBActivityLoaded <NSObject>

@optional

-(void)ActivityHasFinishedLoading:(BBActivity*)activity;

-(void)SetActivities:(NSArray*)activities;

-(void)SetPostActivities:(NSArray*)activities;

-(void)SetObservationActivities:(NSArray*)activities;

@end