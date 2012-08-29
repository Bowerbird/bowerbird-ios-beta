/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "BBModels.h"

@interface BBObservation : BBSighting

@property BOOL isIdentificationRequired;
@property (nonatomic,retain) NSSet* media;
@property (nonatomic,retain) BBMediaResource* primaryMedia;

@end