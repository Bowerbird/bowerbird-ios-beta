/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

// WTF? Forward reference required for lack of compilation
@class BBObservation;

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

@property (nonatomic,retain) NSSet* groups;

@end
