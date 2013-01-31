/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBObservation, BBObservationNote, BBPost, BBUser, BBIdentification, BBGroup;


@interface BBActivity : NSObject


@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* type;
@property (nonatomic,retain) NSDate* createdOn;
@property (nonatomic,retain) NSString* order;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) BBUser* user;
@property (nonatomic,retain) BBObservation* observation;
@property (nonatomic,retain) BBPost* post;
@property (nonatomic,retain) BBObservationNote* observationNote;
@property (nonatomic,retain) BBObservation* observationNoteObservation;
@property (nonatomic,retain) BBObservation* identificationObservation;
@property (nonatomic,retain) BBIdentification* identification;
@property (nonatomic,retain) NSSet* groups;


@end