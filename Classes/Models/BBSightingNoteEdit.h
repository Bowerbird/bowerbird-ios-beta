/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>


@interface BBSightingNoteEdit : NSObject


@property (nonatomic,strong) NSString *sightingId;
@property (nonatomic,strong) NSString *taxonomy;
@property (nonatomic,strong) NSMutableDictionary *descriptions;
@property (nonatomic,strong) NSMutableSet *tags;


-(BBSightingNoteEdit*)initWithSightingId:(NSString*)sightingId;


@end