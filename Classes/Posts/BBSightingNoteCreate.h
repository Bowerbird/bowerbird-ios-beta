/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@class BBSightingNoteDescriptionCreate, BBValidationError;


@interface BBSightingNoteCreate : NSObject

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSMutableArray *descriptions;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *comments;
@property (nonatomic,strong) BBValidationError *errors;

-(void)addDescription:(BBSightingNoteDescriptionCreate*)description;

@end