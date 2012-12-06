/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"


// WTF? Forward reference required for lack of compilation
@class BBMedia;

@interface BBObservation : BBSighting

@property BOOL isIdentificationRequired;
@property (nonatomic,retain) BBMedia* primaryMedia;
@property (nonatomic,retain) NSArray* media;
@property (nonatomic,retain) NSArray* notes;

@end