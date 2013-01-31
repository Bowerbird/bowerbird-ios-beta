/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import <RestKit/RestKit.h>
#import "BBControllerBase.h"
#import "BBSightingNoteEditDelegateProtocol.h"


@class BBSightingNoteEdit;


@interface BBCreateSightingNoteController : BBControllerBase <
     RKObjectLoaderDelegate
    ,BBSightingNoteEditDelegateProtocol
>

@property (nonatomic,strong) BBSightingNoteEdit *sightingNote;

-(BBCreateSightingNoteController*)initWithSightingId:(NSString*)sightingId;

@end